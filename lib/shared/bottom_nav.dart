import 'package:circlesapp/home/homescreen.dart';
import 'package:circlesapp/profile/profilescreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppBottomNavBar extends StatefulWidget {
  const AppBottomNavBar({super.key});

  @override
  State<AppBottomNavBar> createState() => _AppBottomNavBarState();
}

class _AppBottomNavBarState extends State<AppBottomNavBar> {
  final pages = [
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        // child: Row(
        //   children: [
        //     IconButton(
        //       onPressed: () {
        //         setState(() {
        //           _index = 0;
        //         });
        //       },
        //       icon: Icon(FontAwesomeIcons.house),
        //     ),
        //     IconButton(
        //       onPressed: () {
        //         setState(() {
        //           _index = 1;
        //         });
        //       },
        //       icon: Icon(FontAwesomeIcons.person),
        //     ),
        //   ],
        // ),
        );
  }
}
