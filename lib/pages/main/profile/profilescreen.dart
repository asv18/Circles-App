import 'package:circlesapp/components/circles_list_widget.dart';
import 'package:circlesapp/components/goals_list_widget.dart';
import 'package:circlesapp/components/task_widget.dart';
import 'package:circlesapp/services/data_service.dart';
import 'package:circlesapp/services/auth_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:circlesapp/extraneous_screens/taskscreen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Offset _tapPosition = Offset.zero;

  Future<void> _navigateAndRefresh(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final response = (await Navigator.pushNamed(
      context,
      '/creategoal',
    )) as List;

    if (!mounted) return;

    if (response[0] == "Goal Created") {
      await DataService().fetchGoals();

      setState(() {});
    }
  }

  final List<Circle> circles = [
    Circle(
        name: "circle 1",
        updates: 3,
        userCount: 5,
        image: "https://picsum.photos/400/400?random=1"),
    Circle(
        name: "circle 2",
        updates: 8,
        userCount: 8,
        image: "https://picsum.photos/400/400?random=2"),
    Circle(
        name: "circle 3",
        updates: 10,
        userCount: 3,
        image: "https://picsum.photos/400/400?random=3"),
    Circle(
        name: "circle 4",
        updates: 7,
        userCount: 2,
        image: "https://picsum.photos/400/400?random=4"),
    Circle(
        name: "circle 5",
        updates: 2,
        userCount: 6,
        image: "https://picsum.photos/400/400?random=5"),
    Circle(
        name: "circle 6",
        updates: 6,
        userCount: 10,
        image: "https://picsum.photos/400/400?random=6"),
  ];

  List<Task> tasks = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    // goals = DataService().fetchGoals();
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
          value: "Complete Task",
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
    } else if (result == "Complete Task") {
      setState(() {
        task.complete = !task.complete!;
      });

      DataService().updateTask(task);
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
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            toolbarHeight: MediaQuery.of(context).size.height / 6.0,
            flexibleSpace: const Image(
              image: NetworkImage(
                'https://picsum.photos/600/600?&blur=2',
              ),
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  DataService.dataUser.photoUrl ??
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
                            color: Theme.of(context).primaryColor,
                          ),
                          height: 50.0,
                          width: 50.0,
                          alignment: Alignment.center,
                          child: Center(
                            child: InkWell(
                              onTap: () {},
                              child: const Icon(
                                Icons.settings,
                                size: 25.0,
                                color: Colors.white,
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
        ],
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20.0, 75.0, 20.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tasks",
                  style: TextStyle(fontSize: 24),
                ),
                FutureBuilder<List<Goal>>(
                  future: DataService.goals,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else if (snapshot.hasData) {
                      tasks = List.empty(growable: true);
                      for (var goal in snapshot.data!) {
                        for (var task in goal.tasks!) {
                          if (!task.complete!) {
                            tasks.add(task);
                          }
                        }
                      }
                      if (tasks.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Center(
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 40,
                              ),
                              child: const Center(
                                child: Text(
                                  "You have no tasks for today...",
                                  style: TextStyle(
                                    fontSize: 17.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: 170.0,
                          child: ListView.builder(
                            itemCount: tasks.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTapDown: (details) => _getTapPosition(
                                  details,
                                ),
                                onLongPress: () => _showActionsTaskMenu(
                                  context,
                                  tasks[index],
                                ),
                                child: TaskWidget(
                                  task: tasks[index],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                const Divider(
                  thickness: 1.0,
                  color: Colors.black,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
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
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
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
                      FutureBuilder(
                        future: DataService.goals,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: const Text(
                                  "You have no goals yet...",
                                  style: TextStyle(
                                    fontSize: 17.5,
                                  ),
                                ),
                              );
                            } else {
                              return GoalsListWidget(goals: snapshot.data!);
                            }
                          }

                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  color: Colors.black,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
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
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
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
                          return CircleListWidget(
                            circle: circles[index],
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
}
