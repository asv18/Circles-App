import 'package:circlesapp/components/UI/bottom_appbar_button.dart';
import 'package:circlesapp/pages/auth_screens/authscreen.dart';
import 'package:circlesapp/pages/main/friends/friendspage.dart';
import 'package:circlesapp/pages/main/home/homepage.dart';
import 'package:circlesapp/pages/main/profile/profilescreen.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:flutter/material.dart';
import 'package:circlesapp/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:icons_plus/icons_plus.dart';

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

    if (userID != null) {
      UserService.dataUser.id = userID;
      UserService.dataUser.name = await openedBox.get("name");
      UserService.dataUser.username = await openedBox.get("username");
      UserService.dataUser.email = await openedBox.get("email");
      UserService.dataUser.fKey = await openedBox.get("f_key");

      String photoUrl = await openedBox.get("photo_url");
      UserService.dataUser.photoUrl = (photoUrl != "null") ? photoUrl : null;

      await CircleService().fetchCircles();
      await GoalService().fetchGoals();

      return const MainPage();
    }

    return FutureBuilder(
      future: _returnHomePage(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("${snapshot.error} :(");
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
    if (!UserService.dataUser.exists) {
      String name = AuthService().user!.displayName ?? "";

      bool exists = UserService.dataUser.exists;

      UserService.dataUser = User(
        id: null,
        name: UserService.dataUser.name ?? name,
        username: AuthService().user!.displayName,
        email: UserService.dataUser.email ?? AuthService().user!.email,
        photoUrl: UserService.dataUser.photoUrl ?? AuthService().user!.photoURL,
        fKey: null,
      );

      UserService.dataUser.exists = exists;
    }

    if (UserService.dataUser.exists) {
      await UserService().fetchUserFromAuth(AuthService().user!.uid);
    } else {
      await UserService().createNewUser(UserService.dataUser);
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
    double width = MediaQuery.of(context).size.width / 9.0;
    double height = MediaQuery.of(context).size.height / 14.0;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: pages,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).canvasColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              30,
            ),
            vertical: ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              5,
            ),
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
                icon: MingCute.home_3_fill,
                color:
                    _index == 0 ? Theme.of(context).primaryColor : Colors.grey,
              ),
              BottomAppBarButton(
                width: width,
                height: height,
                onPressed: () {
                  _pageController.jumpToPage(1);
                  setState(() {
                    _index = 1;
                  });

                  // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //   content: Text(
                  //     "Coming soon!",
                  //     textAlign: TextAlign.center,
                  //   ),
                  //   duration: Duration(seconds: 3),
                  // ));
                },
                icon: MingCute.group_fill,
                color:
                    _index == 1 ? Theme.of(context).primaryColor : Colors.grey,
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
                icon: IonIcons.person_circle,
                color:
                    _index == 2 ? Theme.of(context).primaryColor : Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
