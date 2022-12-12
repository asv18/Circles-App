import 'package:circlesapp/home/main/mainpage.dart';
import 'package:circlesapp/login/loginscreen.dart';
import 'package:circlesapp/profile/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:circlesapp/services/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../shared/bottom_nav.dart';

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
          return const HomePage();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 1;
  final pages = [
    ProfileScreen(),
    MainPage(),
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
                  width: 45.0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _index = 0;
                      });
                    },
                    icon: Icon(
                      Icons.account_circle_outlined,
                      size: 30.0,
                      color: _index == 0 ? Colors.amber : Colors.grey,
                    ),
                  ),
                ),
                // const Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: 30.0, vertical: 35.0),
                // ),
                SizedBox(
                  width: 45.0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _index = 1;
                      });
                    },
                    icon: Icon(
                      Icons.home_outlined,
                      size: 30.0,
                      color: _index == 1 ? Colors.amber : Colors.grey,
                    ),
                  ),
                ),
                // const Padding(
                //   padding:
                //       EdgeInsets.symmetric(horizontal: 30.0, vertical: 35.0),
                // ),
                const SizedBox(
                  width: 45.0,
                  child: Icon(
                    Icons.group_outlined,
                    size: 30.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
