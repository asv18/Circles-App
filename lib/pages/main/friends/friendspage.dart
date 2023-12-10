import 'package:circlesapp/components/type_based/Users/friend_widget.dart';
import 'package:circlesapp/components/UI/search_appbar.dart';
import 'package:circlesapp/services/friend_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
        backgroundColor: Theme.of(context).primaryColorLight,
        elevation: 2,
        toolbarHeight: MediaQuery.of(context).size.height / 6.0,
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Conversations",
                    style: GoogleFonts.karla(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesome.user_plus,
                    ),
                  ),
                ],
              ),
            ),
            SearchAppBar(
              controller: _textEditingControllerSearchFriends,
              onChanged: (value) {
                setState(() {
                  searchTerm = value.toString().toLowerCase();
                });
              },
            ),
          ],
        ),
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
