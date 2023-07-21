import 'dart:convert';

import 'package:circlesapp/components/type_based/Users/circle_image_widget.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.friend,
  });

  final User friend;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late WebSocketChannel channel;

  final TextEditingController _controller = TextEditingController();

  Map<String, String> messages = <String, String>{};

  @override
  void initState() {
    super.initState();

    channel = WebSocketChannel.connect(
      Uri.parse(
        "ws://localhost:3000/messages",
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.arrowLeft,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                CircleImageWidget(
                  photoUrl: widget.friend.photoUrl,
                  dimensions: 35,
                  margin: 12,
                ),
                Expanded(
                  child: Text(
                    "${widget.friend.firstName} ${widget.friend.lastName}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(
                  FontAwesomeIcons.gear,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          messages.addAll(snapshot.data);
          if (snapshot.hasData || messages.isNotEmpty) {
            messages.addAll(snapshot.data);
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, builder) {
                return Text(messages.toString());
              },
            );
          }

          return const CircularProgressIndicator();
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Write message...",
                      hintStyle: TextStyle(
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(
                        0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(left: 20.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (_controller.value != TextEditingValue.empty) {
                        final message = jsonEncode(
                          {
                            "message": _controller.text,
                            "id": UserService.dataUser.id,
                          },
                        );
                        channel.sink.add(message);
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
