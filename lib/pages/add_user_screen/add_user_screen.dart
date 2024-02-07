import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/components/UI/search_appbar.dart';
import 'package:circlesapp/components/type_based/Users/user_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
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
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        toolbarHeight: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          75,
        ),
        backgroundColor: Theme.of(context).canvasColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "ADD A USER",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ExitButton(
              onPressed: () {
                mainKeyNav.currentState!.pop(
                  [
                    "User Not Added",
                  ],
                );
              },
              icon: FontAwesome.x_solid,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              30,
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ComponentService.convertWidth(
                MediaQuery.of(context).size.width,
                10,
              ),
            ),
            child: SearchAppBar(
              controller: _textEditingControllerSearchUsers,
              onChanged: (value) {
                setState(() {
                  usersFuture =
                      UserService().queryUsers(value, widget.circle.id!);
                });
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
                return const Text("ERROR!!!!!");
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return UserWidget(
                      user: snapshot.data![index],
                      onPressed: () async {
                        await CircleService().connectForeignUserToCircle(
                          snapshot.data![index].fKey!,
                          widget.circle.id!,
                        );

                        mainKeyNav.currentState!.pop(
                          [
                            "User Added",
                          ],
                        );
                      },
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
