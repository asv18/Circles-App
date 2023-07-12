import 'package:circlesapp/components/type_based/Users/friend_widget.dart';
import 'package:circlesapp/components/UI/search_appbar.dart';
import 'package:circlesapp/services/friend_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../shared/user.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late Future<List<User>> friends;
  final TextEditingController _textEditingControllerSearchFriends =
      TextEditingController();
  List<User> users = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    friends = FriendService().fetchFriendSkeletons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: SearchAppBar(
          controller: _textEditingControllerSearchFriends,
          onChanged: (value) {
            setState(() {
              users = List.empty(growable: true);

              friends.then((value) {
                for (User user in value) {
                  if ("${user.firstName}${user.lastName}"
                          .contains(_textEditingControllerSearchFriends.text) ||
                      user.username!
                          .contains(_textEditingControllerSearchFriends.text)) {
                    users.add(user);
                  }
                }
              });
            });
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 20,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                FontAwesomeIcons.userPlus,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: FutureBuilder<List<User>>(
            future: friends,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                return const Text("ERROR!!!!!");
              } else if (snapshot.hasData) {
                if (_textEditingControllerSearchFriends.value !=
                    TextEditingValue.empty) {
                  users = List.empty(growable: true);
                  for (User user in snapshot.data!) {
                    if ("${user.firstName}${user.lastName}"
                            .toLowerCase()
                            .contains(
                              _textEditingControllerSearchFriends.text
                                  .toLowerCase(),
                            ) ||
                        user.username!.toLowerCase().contains(
                              _textEditingControllerSearchFriends.text
                                  .toLowerCase(),
                            )) {
                      users.add(user);
                    }
                  }
                } else {
                  users = snapshot.data!;
                }
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        FriendWidget(
                          friend: snapshot.data![index],
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                      ],
                    );
                  },
                );
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
