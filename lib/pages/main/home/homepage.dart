import 'package:circlesapp/pages/main/home/circles/circlesdisplay.dart';
import 'package:circlesapp/pages/main/home/goals/goalsdisplay.dart';
import 'package:circlesapp/services/auth_service.dart';
import 'package:circlesapp/services/data_service.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  late Future<User> user;
  late TabController _tabController;

  final pages = const [
    CirclesDisp(),
    GoalsDisp(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: pages.length, vsync: this);
    user = DataService().fetchUserFromAuth(AuthService().user?.uid);
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
                  FutureBuilder<User>(
                    future: user,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                            "Hi ${snapshot.data!.firstName} ${snapshot.data!.lastName}!");
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      // By default, show a loading spinner.
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                  Container(
                    width: double.infinity,
                    height: 32.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(30.0),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Stuff",
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(30.0),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Stuff",
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                      ),
                    ),
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
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text(
                "Circles",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Tab(
              child: Text(
                "Goals",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
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

class PageButton extends StatelessWidget {
  final String text;
  final PageController controller;
  final int toPage;

  const PageButton({
    Key? key,
    required this.controller,
    required this.text,
    required this.toPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: () {
          controller.animateToPage(
            toPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
