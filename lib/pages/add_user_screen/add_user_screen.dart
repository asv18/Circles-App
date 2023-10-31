import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/components/UI/search_appbar.dart';
import 'package:circlesapp/components/type_based/Users/user_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({
    super.key,
    required this.circle,
  });

  final Circle circle;

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  late Future<List<User>> usersFuture;
  final TextEditingController _textEditingControllerSearchUsers =
      TextEditingController();
  List<User> users = List.empty(growable: true);

  String searchTerm = "";

  @override
  void initState() {
    super.initState();

    usersFuture = UserService().queryUsers("", widget.circle.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "ADD A USER",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ExitButton(
              onPressed: () {
                mainKeyNav.currentState!.pop(
                  [
                    "User Not Added",
                  ],
                );
              },
              icon: FontAwesome.x,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: SearchAppBar(
              controller: _textEditingControllerSearchUsers,
              onChanged: (value) {
                usersFuture =
                    UserService().queryUsers(value, widget.circle.id!);
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: FutureBuilder<List<User>>(
            future: usersFuture,
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
                          (prospect) => UserWidget(
                            user: prospect,
                            onPressed: () async {
                              await CircleService().connectForeignUserToCircle(
                                prospect.fKey!,
                                widget.circle.id!,
                              );

                              mainKeyNav.currentState!.pop(
                                [
                                  "User Added",
                                ],
                              );
                            },
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
