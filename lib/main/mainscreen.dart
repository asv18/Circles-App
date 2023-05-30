import 'package:circlesapp/authscreens/authscreen.dart';
import 'package:circlesapp/main/friends/friendspage.dart';
import 'package:circlesapp/main/home/homepage.dart';
import 'package:circlesapp/main/profile/profilescreen.dart';
import 'package:circlesapp/services/data_service.dart';
import 'package:circlesapp/shared/user.dart';
// import 'package:circlesapp/shared/user.dart';
import 'package:flutter/material.dart';
import 'package:circlesapp/services/auth_service.dart';

import '../shared/goal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthService().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error"),
          );
        } else if (snapshot.hasData) {
          if (!DataService.dataUser.exists) {
            User newUser = User.newUser(
              exists: true,
            );

            //print(AuthService().user!.displayName!.split(" "));

            newUser.email = AuthService().user!.email;

            List<String> firstLastName =
                AuthService().user!.displayName!.split(" ");
            newUser.firstName = firstLastName[0];
            newUser.lastName = firstLastName[1];
            newUser.username = AuthService().user!.displayName!;
            newUser.email = AuthService().user!.email;

            DataService().createUser(newUser);
          }

          return const MainPage();
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  late final PageController pageController;

  final pages = [
    const HomePage(),
    const FriendsPage(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 8.0;
    double height = MediaQuery.of(context).size.height / 14.0;

    return Scaffold(
      body: PageView(
        controller: pageController,
        children: pages,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 45.0,
            vertical: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width,
                height: height,
                child: IconButton(
                  onPressed: () {
                    pageController.jumpToPage(0);
                    setState(() {
                      _index = 0;
                    });
                  },
                  icon: FittedBox(
                    child: Icon(
                      _index == 0 ? Icons.home : Icons.home_outlined,
                      size: width,
                      color: _index == 0 ? Colors.amber : Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width,
                height: height,
                child: IconButton(
                  onPressed: () {
                    pageController.jumpToPage(1);
                    setState(() {
                      _index = 1;
                    });
                  },
                  icon: FittedBox(
                    child: Icon(
                      _index == 1 ? Icons.group : Icons.group_outlined,
                      size: width,
                      color: _index == 1 ? Colors.amber : Colors.grey,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: width,
                height: height,
                child: IconButton(
                  onPressed: () {
                    pageController.jumpToPage(2);
                    setState(() {
                      _index = 2;
                    });
                  },
                  icon: FittedBox(
                    child: Icon(
                      _index == 2
                          ? Icons.account_circle
                          : Icons.account_circle_outlined,
                      size: width,
                      color: _index == 2 ? Colors.amber : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
