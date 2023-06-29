import 'package:circlesapp/components/bottom_appbar_button.dart';
import 'package:circlesapp/pages/authscreens/authscreen.dart';
import 'package:circlesapp/pages/main/friends/friendspage.dart';
import 'package:circlesapp/pages/main/home/homepage.dart';
import 'package:circlesapp/pages/main/profile/profilescreen.dart';
import 'package:circlesapp/services/data_service.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:flutter/material.dart';
import 'package:circlesapp/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Widget> _read() async {
    const secureStorage = FlutterSecureStorage();

    final userIDKey = await secureStorage.read(
      key: "idKey",
    );

    final openedBox = Hive.box("userBox");

    final userID = await openedBox.get(userIDKey);

    print("$userID fetched");

    if (userID != null) {
      DataService.dataUser.id = userID;
      DataService.dataUser.firstName = await openedBox.get("first_name");
      DataService.dataUser.lastName = await openedBox.get("last_name");
      DataService.dataUser.username = await openedBox.get("username");
      DataService.dataUser.email = await openedBox.get("email");

      return const MainPage();
    }

    return FutureBuilder(
      future: _returnHomePage(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else if (snapshot.hasData) {
          return snapshot.data!;
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<Widget> _returnHomePage() async {
    if (!DataService.dataUser.exists) {
      User newUser = User.newUser(
        exists: true,
      );

      newUser.email = AuthService().user!.email;

      List<String> firstLastName = AuthService().user!.displayName!.split(" ");
      newUser.firstName = firstLastName[0];
      newUser.lastName = firstLastName[1];
      newUser.username = AuthService().user!.displayName!;
      newUser.email = AuthService().user!.email;

      await DataService().createUser(newUser);
    } else {
      await DataService().fetchUserFromAuth(AuthService().user!.uid);
    }

    return const MainPage();
  }

  @override
  void initState() {
    super.initState();
  }

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
          return FutureBuilder(
            future: _read(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.hasData) {
                return snapshot.data!;
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        } else {
          return const AuthScreen();
        }
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;
  late final PageController _pageController;

  final pages = [
    const HomePage(),
    const FriendsPage(),
    const ProfileScreen(),
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
    double width = MediaQuery.of(context).size.width / 8.0;
    double height = MediaQuery.of(context).size.height / 14.0;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 45.0,
            vertical: 15.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BottomAppBarButton(
                width: width,
                height: height,
                onPressed: () {
                  _pageController.jumpToPage(0);
                  setState(() {
                    _index = 0;
                  });
                },
                icon: _index == 0 ? Icons.home : Icons.home_outlined,
                color: _index == 0 ? Colors.amber : Colors.grey,
              ),
              BottomAppBarButton(
                width: width,
                height: height,
                onPressed: () {
                  _pageController.jumpToPage(1);
                  setState(() {
                    _index = 1;
                  });
                },
                icon: _index == 1 ? Icons.group : Icons.group_outlined,
                color: _index == 1 ? Colors.amber : Colors.grey,
              ),
              BottomAppBarButton(
                width: width,
                height: height,
                onPressed: () {
                  _pageController.jumpToPage(2);
                  setState(() {
                    _index = 2;
                  });
                },
                icon: _index == 2
                    ? Icons.account_circle
                    : Icons.account_circle_outlined,
                color: _index == 2 ? Colors.amber : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
