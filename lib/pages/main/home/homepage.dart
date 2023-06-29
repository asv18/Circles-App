import 'package:circlesapp/components/notifcation_button.dart';
import 'package:circlesapp/components/tab_button.dart';
import 'package:circlesapp/pages/main/home/circles/circlesdisplay.dart';
import 'package:circlesapp/pages/main/home/goals/goalsdisplay.dart';
import 'package:circlesapp/services/data_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late TabController _tabController;

  final pages = const [
    CirclesDisp(),
    GoalsDisp(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: pages.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
              margin: const EdgeInsets.only(right: 20.0),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hi ${DataService.dataUser.firstName} ${DataService.dataUser.lastName}!",
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

  @override
  bool get wantKeepAlive => true;
}
