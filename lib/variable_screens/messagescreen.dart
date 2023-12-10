import 'dart:convert';

import 'package:circlesapp/components/type_based/Users/user_image_widget.dart';
import 'package:circlesapp/components/type_based/messages/message_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/friend_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/friendship.dart';
import 'package:circlesapp/shared/message.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

//TODO: add responsive layout
class MessageScreen extends StatefulWidget {
  const MessageScreen({
    super.key,
    required this.friend,
    required this.friendship,
    required this.messages,
  });

  final User friend;
  final Friendship friendship;
  final List<Message> messages;

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  late WebSocketChannel channel;

  final TextEditingController _messageController = TextEditingController();
  BigInt? replyId;

  late List<Message> messages;

  BigInt offset = BigInt.zero;
  BigInt newMessages = BigInt.zero;

  final _scrollController = ScrollController();

  String getFormattedTime(DateTime time) {
    var timeFormat = DateFormat("h:mm");
    String timePortion = timeFormat.format(time);
    return timePortion;
  }

  String getFormattedDate(DateTime time) {
    var timeFormat = DateFormat("M/d/yy h:mm");
    String timePortion = timeFormat.format(time);
    return timePortion;
  }

  void connectToWebsocket() {
    channel = WebSocketChannel.connect(
      Uri.parse(
        "ws://localhost:3000/ws/v1/messages/",
      ),
    );

    var params = jsonEncode({
      "type": "connection_id",
      "friendship_id": widget.friendship.id.toString(),
    });

    channel.sink.add(params);
  }

  @override
  void initState() {
    super.initState();

    messages = widget.messages;

    connectToWebsocket();

    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;

        if (!isTop) {
          offset = BigInt.from(messages.length) - newMessages;

          //TODO: change this
          if (offset.modPow(BigInt.one, BigInt.from(20)) == BigInt.zero) {
            List<Message> newMessages = await FriendService().fetchMessages(
              widget.friendship.id!,
              offset,
            );

            setState(() {
              offset = BigInt.from(messages.length);

              messages.insertAll(0, newMessages);
            });
          }

          print('At the bottom: $offset');
        }
      }
    });
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
                    mainKeyNav.currentState!.pop();
                  },
                  icon: const Icon(
                    FontAwesome.arrow_left,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                UserImageWidget(
                  photoUrl: widget.friend.photoUrl ??
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                  dimensions: 35,
                  margin: 12,
                ),
                Expanded(
                  child: Text(
                    "${widget.friend.name}",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Icon(
                  FontAwesome.gear,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: StreamBuilder(
          stream: channel.stream,
          builder: (context, snapshot) {
            if (messages.isEmpty && !snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "This is the beginning of your conversation history with ${widget.friend.name}",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (snapshot.hasData || messages.isNotEmpty) {
              if (snapshot.data != null) {
                newMessages = newMessages + BigInt.one;
                messages.add(
                  Message.fromJson(
                    jsonDecode(
                      snapshot.data,
                    ),
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  if (index + 1 != messages.length) {
                    Duration separation =
                        messages.reversed.toList()[index].dateSent!.difference(
                              messages.reversed.toList()[index + 1].dateSent!,
                            );

                    if (messages.reversed.toList()[index].dateSent!.day !=
                        messages.reversed.toList()[index + 1].dateSent!.day) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 40.0,
                                    right: 10.0,
                                  ),
                                  child: const Divider(
                                    color: Colors.black,
                                    height: 36,
                                  ),
                                ),
                              ),
                              Text(
                                getFormattedDate(
                                  messages.reversed.toList()[index].dateSent!,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 40.0,
                                  ),
                                  child: const Divider(
                                    color: Colors.black,
                                    height: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          MessageWidget(
                            message: messages.reversed.toList()[index],
                            margin: 20,
                            replyFunction: (context) {
                              setState(() {
                                replyId = messages.reversed.toList()[index].id;
                              });
                            },
                          ),
                        ],
                      );
                    }

                    if (separation.inHours >= 1) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 40.0,
                                    right: 10.0,
                                  ),
                                  child: const Divider(
                                    color: Colors.black,
                                    height: 36,
                                  ),
                                ),
                              ),
                              Text(
                                getFormattedTime(
                                  messages.reversed.toList()[index].dateSent!,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 40.0,
                                  ),
                                  child: const Divider(
                                    color: Colors.black,
                                    height: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          MessageWidget(
                            message: messages.reversed.toList()[index],
                            margin: 20,
                            replyFunction: (context) {
                              setState(() {
                                replyId = messages.reversed.toList()[index].id;
                              });
                            },
                          ),
                        ],
                      );
                    }

                    if (separation.inMinutes >= 3) {
                      return MessageWidget(
                        message: messages.reversed.toList()[index],
                        margin: 20,
                        replyFunction: (context) {
                          setState(() {
                            replyId = messages.reversed.toList()[index].id;
                          });
                        },
                      );
                    }
                  } else if (messages.length - 1 == index) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 40.0,
                                  right: 10.0,
                                ),
                                child: const Divider(
                                  color: Colors.black,
                                  height: 36,
                                ),
                              ),
                            ),
                            Text(
                              getFormattedDate(
                                messages.reversed.toList()[index].dateSent!,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 40.0,
                                ),
                                child: const Divider(
                                  color: Colors.black,
                                  height: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                        MessageWidget(
                          message: messages.reversed.toList()[index],
                          margin: 20,
                          replyFunction: (context) {
                            setState(() {
                              replyId = messages.reversed.toList()[index].id;
                            });
                          },
                        ),
                      ],
                    );
                  }

                  return MessageWidget(
                    message: messages.reversed.toList()[index],
                    margin: 5,
                    replyFunction: (context) {
                      setState(() {
                        replyId = messages.reversed.toList()[index].id;
                      });
                    },
                  );
                },
              );
            }

            return const CircularProgressIndicator();
          },
        ),
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
                    controller: _messageController,
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
                    onPressed: () async {
                      if (_messageController.text.trim() != "") {
                        final message = {
                          "type": "message",
                          "contents": _messageController.text,
                          "friendship_id": widget.friendship.id.toString(),
                          "user_fkey": UserService.dataUser.fKey,
                          "reply_id": replyId.toString(),
                          "date_sent": DateTime.now().toIso8601String(),
                        };

                        channel.sink.add(jsonEncode(message));
                      }

                      _messageController.clear();
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
