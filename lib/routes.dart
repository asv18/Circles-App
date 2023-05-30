import 'package:circlesapp/authscreens/authscreen.dart';
import 'package:circlesapp/create_goal/create_goal_screen.dart';
import 'package:circlesapp/main/mainscreen.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const AuthScreen(),
  '/creategoal': (context) => const CreateGoalScreen(),
};
