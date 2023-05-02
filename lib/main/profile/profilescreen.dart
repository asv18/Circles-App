import 'package:circlesapp/services/data_service.dart';
import 'package:circlesapp/shared/circlescreen.dart';
import 'package:circlesapp/services/auth_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:circlesapp/shared/taskscreen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  late Future<List<Goal>> goals;
  Offset _tapPosition = Offset.zero;

  Future<void> _navigateAndRefresh(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final response = await Navigator.pushNamed(
      context,
      '/creategoal',
    );

    if (!mounted) return;

    if (response == "Goal Created") {
      goals = DataService.fetchGoals();
    }
  }

  final List<Circle> circles = [
    Circle(
        name: "circle 1",
        updates: 3,
        userCount: 5,
        image: "https://source.unsplash.com/random/400x400?sig=1"),
    Circle(
        name: "circle 2",
        updates: 8,
        userCount: 8,
        image: "https://source.unsplash.com/random/400x400?sig=2"),
    Circle(
        name: "circle 3",
        updates: 10,
        userCount: 3,
        image: "https://source.unsplash.com/random/400x400?sig=3"),
    Circle(
        name: "circle 4",
        updates: 7,
        userCount: 2,
        image: "https://source.unsplash.com/random/400x400?sig=4"),
    Circle(
        name: "circle 5",
        updates: 2,
        userCount: 6,
        image: "https://source.unsplash.com/random/400x400?sig=5"),
    Circle(
        name: "circle 6",
        updates: 6,
        userCount: 10,
        image: "https://source.unsplash.com/random/400x400?sig=6"),
  ];

  List<Task> tasks = [
    // Task(name: "task 1", repeat: "Never"),
    // Task(name: "task 2", repeat: "Daily"),
    // Task(name: "task 3", repeat: "Monthly"),
    // Task(name: "task 4", repeat: "Weekly"),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goals = DataService.fetchGoals();
  }

  void _getTapPosition(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(details.globalPosition);
    });
  }

  void _showActionsTaskMenu(BuildContext context, Task task) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
        Rect.fromLTWH(
          0,
          0,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      items: [
        PopupMenuItem(
          value: "Edit Task",
          child: Text("Edit ${task.name}"),
        ),
        PopupMenuItem(
          value: "Mark Task",
          child: Text(
              "Mark ${task.name} as ${(task.complete!) ? "incomplete" : "complete"}"),
        ),
      ],
    );

    if (result == "Edit Task") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => TaskScreen(
            task: task,
          ),
        ),
      );
    } else if (result == "Mark Task") {
      setState(() {
        task.complete = !task.complete!;
      });
    }
  }

  void _showActionsCircleMenu(BuildContext context) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
        Rect.fromLTWH(
          0,
          0,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      items: [
        const PopupMenuItem(
          value: "Join Circle",
          child: Text("Join Circle"),
        ),
        const PopupMenuItem(
          value: "Create Circle",
          child: Text("Create Circle"),
        ),
      ],
    );

    if (result == "Join Circle") {
    } else if (result == "Create Circle") {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: ((context, innerBoxIsScrolled) => [
              SliverAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 6.0,
                flexibleSpace: const Image(
                  image: NetworkImage(
                      'https://source.unsplash.com/random/600x600?sig=1'),
                  fit: BoxFit.cover,
                ),
                backgroundColor: Colors.transparent,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Transform.translate(
                      offset: const Offset(0, 60.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            child: PhysicalModel(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              elevation: 5,
                              child: Container(
                                width: 150.0,
                                height: 150.0,
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
                            ),
                          ),
                          PhysicalModel(
                            borderRadius: BorderRadius.circular(20.0),
                            elevation: 5,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.blue,
                              ),
                              height: 50.0,
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Center(
                                child: InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.settings,
                                    size: 30.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 75.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 20.0, 0, 20.0),
                  child: const Text(
                    "Tasks",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  height: 170.0,
                  child: ListView.builder(
                    itemCount: tasks.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 225.0,
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: (tasks[index].complete!)
                              ? Colors.green[400]
                              : Colors.blue,
                        ),
                        child: InkWell(
                          onTapDown: (details) => _getTapPosition(details),
                          onLongPress: () => _showActionsTaskMenu(
                            context,
                            tasks[index],
                          ),
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        tasks[index].name,
                                        style: const TextStyle(
                                          fontSize: 24.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      (tasks[index].repeat == "Never")
                                          ? "Not Recurring"
                                          : tasks[index].repeat,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Transform.scale(
                                  scale: 1.5,
                                  child: Checkbox(
                                    checkColor: Colors.green[400],
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Colors.white,
                                    ),
                                    value: tasks[index].complete,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        tasks[index].complete = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  indent: 20.0,
                  endIndent: 20.0,
                  color: Colors.black,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Goals",
                              style: TextStyle(fontSize: 24),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 20.0),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  _navigateAndRefresh(context);
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: const EdgeInsets.symmetric(horizontal: 30.0),
                        height: 150.0,
                        child: FutureBuilder(
                          future: goals,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else if (snapshot.hasData) {
                              return ListView.builder(
                                padding: const EdgeInsets.all(0),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    color: Colors.grey[50],
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              DataService.truncateWithEllipsis(
                                                15,
                                                snapshot.data![index].name,
                                              ),
                                              style: const TextStyle(
                                                fontSize: 16.0,
                                              ),
                                            ),
                                            Row(
                                              children: List.generate(
                                                5,
                                                (i) {
                                                  if (i <
                                                      snapshot.data![index]
                                                          .progress!
                                                          .toInt()) {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5.0),
                                                      child: Icon(
                                                        Icons.circle,
                                                        color:
                                                            Colors.green[500],
                                                      ),
                                                    );
                                                  } else {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 5.0),
                                                      child: Icon(
                                                        Icons.circle_outlined,
                                                        color:
                                                            Colors.green[500],
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1,
                                          color: (index ==
                                                  snapshot.data!.length - 1)
                                              ? Colors.transparent
                                              : Colors.black,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }

                            return const CircularProgressIndicator();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  indent: 20.0,
                  endIndent: 20.0,
                  color: Colors.black,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Circles",
                              style: TextStyle(fontSize: 24),
                            ),
                            Container(
                              width: 50.0,
                              height: 50.0,
                              margin: const EdgeInsets.only(left: 20.0),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                onTapDown: (details) =>
                                    _getTapPosition(details),
                                onTap: () => _showActionsCircleMenu(context),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        itemCount: circles.length,
                        itemBuilder: (context, index) {
                          return Hero(
                            tag: circles[index].image,
                            child: Material(
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 500),
                                      pageBuilder: (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                      ) {
                                        return CircleScreen(
                                          circle: circles[index],
                                        );
                                      },
                                      transitionsBuilder: (
                                        BuildContext context,
                                        Animation<double> animation,
                                        Animation<double> secondaryAnimation,
                                        Widget child,
                                      ) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: DecorationImage(
                                      image: NetworkImage(circles[index].image),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 10.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          circles[index].name,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 30.0,
                                              width: 75.0,
                                              child: Stack(
                                                children: List.generate(
                                                  circles[index].userCount <= 3
                                                      ? circles[index].userCount
                                                      : 3,
                                                  (index) {
                                                    return Positioned(
                                                      left: index * 15,
                                                      child: Container(
                                                        width: 30.0,
                                                        height: 30.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                              'https://source.unsplash.com/random/200x200?sig=${index}',
                                                            ),
                                                          ),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.0,
                                              child: Visibility(
                                                visible:
                                                    circles[index].userCount >
                                                        3,
                                                child: Text(
                                                  "+${circles[index].userCount - 3}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w300,
                                                    shadows: [
                                                      Shadow(
                                                        offset: const Offset(
                                                            2.5, 2.5),
                                                        blurRadius: 10.0,
                                                        color: Colors.black
                                                            .withOpacity(0.8),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Signout'),
                      onPressed: () async {
                        await AuthService().signOut();
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil('/', (route) => false);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
