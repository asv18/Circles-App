import 'package:animated_background/animated_background.dart';
// import 'package:circlesapp/components/UI/provider_button.dart';
import 'package:circlesapp/pages/auth_screens/login/loginscreen.dart';
import 'package:circlesapp/pages/auth_screens/signup/signupscreen.dart';
import 'package:circlesapp/services/component_service.dart';
// import 'package:circlesapp/services/auth_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  int _index = 0;
  late final PageController _pageController;

  final pages = [
    const SingleChildScrollView(child: LoginScreen()),
    const SingleChildScrollView(child: SignUpScreen()),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: AnimatedBackground(
          behaviour: BubblesBehaviour(),
          vsync: this,
          child: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  30,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: IntrinsicHeight(
                      child: PageView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        children: pages,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _index = (_index == 0) ? 1 : 0;

                        UserService.dataUser.exists = _index == 0;
                      });

                      _pageController.animateToPage(
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
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
