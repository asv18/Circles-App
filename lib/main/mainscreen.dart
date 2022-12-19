import 'package:circlesapp/friends/friendspage.dart';
import 'package:circlesapp/main/home/homepage.dart';
import 'package:circlesapp/login/loginscreen.dart';
import 'package:circlesapp/profile/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:circlesapp/services/auth_service.dart';

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
          return const MainPage();
        } else {
          return const LoginScreen();
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

  final pages = [
    HomePage(),
    FriendsPage(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_index],
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
                  width: MediaQuery.of(context).size.width / 7.0,
                  height: MediaQuery.of(context).size.height / 14.0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _index = 0;
                      });
                    },
                    icon: FittedBox(
                      child: Icon(
                        _index == 0 ? Icons.home : Icons.home_outlined,
                        size: MediaQuery.of(context).size.width / 7.0,
                        color: _index == 0 ? Colors.amber : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 7.0,
                  height: MediaQuery.of(context).size.height / 14.0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _index = 1;
                      });
                    },
                    icon: FittedBox(
                      child: Icon(
                        _index == 1 ? Icons.group : Icons.group_outlined,
                        size: MediaQuery.of(context).size.width / 7.0,
                        color: _index == 1 ? Colors.amber : Colors.grey,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 7.0,
                  height: MediaQuery.of(context).size.height / 14.0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _index = 2;
                      });
                    },
                    icon: FittedBox(
                      child: Icon(
                        _index == 2
                            ? Icons.account_circle
                            : Icons.account_circle_outlined,
                        size: MediaQuery.of(context).size.width / 7.0,
                        color: _index == 2 ? Colors.amber : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
