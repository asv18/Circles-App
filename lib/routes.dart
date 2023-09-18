import 'package:circlesapp/pages/authscreens/authscreen.dart';
import 'package:circlesapp/pages/create_goal/create_goal_screen.dart';
import 'package:circlesapp/pages/main/mainscreen.dart';
import 'package:flutter/material.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const AuthScreen(),
  '/creategoal': (context) => const CreateGoalScreen(),
};

GlobalKey<NavigatorState> mainKeyNav = GlobalKey();
GlobalKey<NavigatorState> listKeyNav = GlobalKey();
