import 'package:circlesapp/components/UI/number_display.dart';
import 'package:circlesapp/components/type_based/Users/user_image_widget.dart';
import 'package:circlesapp/components/UI/tab_button.dart';
import 'package:circlesapp/pages/main/home/circles/circlesdisplay.dart';
import 'package:circlesapp/pages/main/home/goals/goalsdisplay.dart';
import 'package:circlesapp/services/circles_service.dart';
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
      CircleService().fetchCircles();
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
        centerTitle: true,
        flexibleSpace: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Hello, ",
                                  style: GoogleFonts.karla(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                ),
                                TextSpan(
                                  text: "${UserService.dataUser.name}!",
                                  style: GoogleFonts.karla(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            "Have a nice day!",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                    ),
                    UserImageWidget(
                      photoUrl: UserService.dataUser.photoUrl,
                      dimensions: 60.0,
                      margin: 0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NumberDisplay(
                        future: GoalService.goals!,
                        text: "Tasks",
                      ),
                      NumberDisplay(
                        future: GoalService.goals!,
                        text: "Goals",
                      ),
                      NumberDisplay(
                        future: CircleService.circles!,
                        text: "Circles",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        toolbarHeight: MediaQuery.of(context).size.height / 6.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
              ),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              controller: _tabController,
              labelStyle: const TextStyle(
                color: Colors.black,
              ),
              labelPadding: EdgeInsets.zero,
              labelColor: Colors.white,
              unselectedLabelColor: Theme.of(context).primaryColor,
              tabs: const [
                TabButton(
                  name: "Circles",
                ),
                TabButton(
                  name: "Goals",
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 10.0,
          left: 16.0,
          right: 16.0,
        ),
        child: TabBarView(
          controller: _tabController,
          children: pages,
        ),
      ),
    );
  }
}
