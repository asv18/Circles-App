import 'package:circlesapp/login/loginscreen.dart';
import 'package:circlesapp/home/homescreen.dart';

var appRoutes = {
  '/': (context) => const HomeScreen(),
  '/login': (context) => const LoginScreen(),
};
