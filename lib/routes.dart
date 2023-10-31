import 'package:circlesapp/pages/auth_screens/authscreen.dart';
import 'package:circlesapp/pages/create_circle/create_or_join_circle_screen.dart';
import 'package:circlesapp/pages/create_goal/create_goal_screen.dart';
import 'package:circlesapp/pages/create_post/create_post_screen.dart';
import 'package:circlesapp/pages/main/mainscreen.dart';
import 'package:flutter/material.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const AuthScreen(),
  '/creategoal': (context) => const CreateGoalScreen(),
  '/createorjoincircle': (context) => const CreateOrJoinCircleScreen(),
  '/createpost': (context) => const CreatePostScreen(),
};

GlobalKey<NavigatorState> mainKeyNav = GlobalKey();
GlobalKey<NavigatorState> listKeyNav = GlobalKey();
