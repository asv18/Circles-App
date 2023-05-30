import 'package:animated_background/animated_background.dart';
import 'package:circlesapp/authscreens/login/loginscreen.dart';
import 'package:circlesapp/authscreens/signup/signupscreen.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  int _index = 0;
  late final PageController pageController;

  final pages = [
    const LoginScreen(),
    const SignUpScreen(),
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
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: (_index == 0)
              ? Color.lerp(Colors.blue[900], Colors.grey[50], 1)
              : Color.lerp(Colors.grey[50], Colors.blue[900], 1),
        ),
        child: AnimatedBackground(
          behaviour: BubblesBehaviour(),
          vsync: this,
          child: Column(
            children: [
              Flexible(
                flex: 5,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: pages,
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _index = (_index == 0) ? 1 : 0;
                    });
                    pageController.animateToPage(
                      _index,
                      duration: const Duration(
                        milliseconds: 500,
                      ),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Text(
                    (_index == 0)
                        ? "Don't have an account? Sign up instead."
                        : "Already have an account? Log in instead",
                    style: TextStyle(
                      color: (_index == 1) ? Colors.white : Colors.blue,
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
