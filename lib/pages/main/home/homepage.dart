import 'package:circlesapp/components/UI/number_display.dart';
import 'package:circlesapp/components/type_based/Users/user_image_widget.dart';
import 'package:circlesapp/components/UI/tab_button.dart';
import 'package:circlesapp/pages/main/home/circles/circlesdisplay.dart';
import 'package:circlesapp/pages/main/home/goals/goalsdisplay.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
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

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    pages = [
      CirclesDisp(
        callback: callback,
      ),
      GoalsDisp(
        callback: callback,
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void callback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ComponentService.convertWidth(
                MediaQuery.of(context).size.width,
                16,
              ),
              vertical: ComponentService.convertHeight(
                MediaQuery.of(context).size.height,
                10,
              ),
            ),
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
                                    fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "${UserService.dataUser.name!.split(" ")[0]}!",
                                  style: GoogleFonts.karla(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            "Let's get something done today!",
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ],
                      ),
                    ),
                    UserImageWidget(
                      photoUrl: UserService.dataUser.photoUrl ??
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                      dimensions: ComponentService.convertWidth(
                        MediaQuery.of(context).size.width,
                        60,
                      ),
                      margin: 0,
                    ),
                  ],
                ),
                SizedBox(
                  height: ComponentService.convertHeight(
                    MediaQuery.of(context).size.height,
                    20,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: ComponentService.convertWidth(
                      MediaQuery.of(context).size.width,
                      40,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NumberDisplay(
                        future: GoalService.goals,
                        text: "Tasks",
                      ),
                      NumberDisplay(
                        future: GoalService.goals,
                        text: "Goals",
                      ),
                      NumberDisplay(
                        future: CircleService.circles,
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
        toolbarHeight: ComponentService.convertWidth(
          MediaQuery.of(context).size.width,
          160,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              40,
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ComponentService.convertWidth(
                MediaQuery.of(context).size.width,
                16,
              ),
            ),
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
              labelColor: Theme.of(context).canvasColor,
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
        margin: EdgeInsets.only(
          top: ComponentService.convertHeight(
            MediaQuery.of(context).size.height,
            10,
          ),
          left: ComponentService.convertWidth(
            MediaQuery.of(context).size.width,
            16,
          ),
          right: ComponentService.convertWidth(
            MediaQuery.of(context).size.width,
            16,
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: pages,
        ),
      ),
    );
  }
}
