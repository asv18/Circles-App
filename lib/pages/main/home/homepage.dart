import 'package:circlesapp/components/type_based/Users/circle_image_widget.dart';
import 'package:circlesapp/components/UI/notifcation_button.dart';
import 'package:circlesapp/components/UI/tab_button.dart';
import 'package:circlesapp/pages/main/home/circles/circlesdisplay.dart';
import 'package:circlesapp/pages/main/home/goals/goalsdisplay.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  final pages = const [
    CirclesDisp(),
    GoalsDisp(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: pages.length, vsync: this);

    if (UserService.dataUser.exists) {
      GoalService().fetchGoals();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleImageWidget(
              photoUrl: UserService.dataUser.photoUrl,
              dimensions: 120.0,
              margin: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hey ${UserService.dataUser.firstName}!",
                    style: GoogleFonts.karla(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  NotifButton(
                    onPressed: () {},
                    contents: "Stuff",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  NotifButton(
                    onPressed: () {},
                    contents: "Stuff",
                  ),
                ],
              ),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColorLight,
        toolbarHeight: MediaQuery.of(context).size.height / 6.0,
        bottom: TabBar(
          indicatorColor: Colors.amber,
          indicatorSize: TabBarIndicatorSize.label,
          controller: _tabController,
          tabs: const [
            TabButton(name: "Circles"),
            TabButton(name: "Goals"),
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: TabBarView(
          controller: _tabController,
          children: pages,
        ),
      ),
    );
  }
}
