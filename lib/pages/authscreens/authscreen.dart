import 'package:animated_background/animated_background.dart';
// import 'package:circlesapp/components/UI/provider_button.dart';
import 'package:circlesapp/pages/authscreens/login/loginscreen.dart';
import 'package:circlesapp/pages/authscreens/signup/signupscreen.dart';
// import 'package:circlesapp/services/auth_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:flutter/material.dart';

/*
Row(
  children: [
    Expanded(
      child: Container(
        margin:
            const EdgeInsets.only(left: 10.0, right: 20.0),
        child: const Divider(
          color: Colors.black,
          height: 36,
        ),
      ),
    ),
    const Text("OR"),
    Expanded(
      child: Container(
        margin:
            const EdgeInsets.only(left: 20.0, right: 10.0),
        child: const Divider(
          color: Colors.black,
          height: 36,
        ),
      ),
    ),
  ],
),
Expanded(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      ProviderButton(
        icon: const AssetImage(
          'assets/google_logo.png',
        ),
        backgroundColor: Colors.white,
        loginMethod: AuthService().googleLogin,
      ),
      const SizedBox(
        width: 10,
      ),
      ProviderButton(
        icon: const AssetImage(
          'assets/apple_logo.png',
        ),
        backgroundColor: Colors.black,
        loginMethod: AuthService().googleLogin,
      ),
      const SizedBox(
        width: 10,
      ),
      ProviderButton(
        icon: const AssetImage(
          'assets/facebook_logo.png',
        ),
        backgroundColor:
            const Color.fromARGB(255, 66, 103, 178),
        loginMethod: AuthService().googleLogin,
      ),
    ],
  ),
),
*/
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
              margin: const EdgeInsets.symmetric(vertical: 30),
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
                        UserService.dataUser.exists = _index == 0;
                        _index = (_index == 0) ? 1 : 0;
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
