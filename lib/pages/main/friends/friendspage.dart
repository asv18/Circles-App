import 'package:circlesapp/components/UI/custom_icon_button.dart';
import 'package:circlesapp/components/type_based/Users/friend_widget.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/services/friend_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

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

  String searchTerm = "";

  @override
  void initState() {
    super.initState();

    friends = FriendService().fetchFriendSkeletons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          60,
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "FRIENDS",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            CustomIconButton(
              onPressed: () {},
              icon: MingCute.user_add_line,
              color: Theme.of(context).primaryColor,
              iconColor: Colors.white,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).canvasColor,
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
                return ListView(
                  children: [
                    ...snapshot.data!
                        .where(
                          (prospect) =>
                              searchTerm.isEmpty ||
                              prospect.name!
                                  .toLowerCase()
                                  .contains(searchTerm) ||
                              prospect.username!
                                  .toLowerCase()
                                  .contains(searchTerm),
                        )
                        .map(
                          (prospect) => FriendWidget(
                            friend: prospect,
                          ),
                        )
                        .toList(),
                  ],
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
