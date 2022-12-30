import 'package:circlesapp/create_goal/create_goal_screen.dart';
import 'package:circlesapp/login/loginscreen.dart';
import 'package:circlesapp/main/mainscreen.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
  '/creategoal': (context) => const CreateGoalScreen(),
};
