import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/components/type_based/Users/user_image_widget.dart';
import 'package:circlesapp/components/type_based/Circles/circles_list_widget.dart';
import 'package:circlesapp/components/type_based/Goals/goals_list_widget.dart';
import 'package:circlesapp/components/type_based/Goals/Tasks/task_complete_dialog.dart';
import 'package:circlesapp/components/type_based/Goals/Tasks/task_widget.dart';
import 'package:circlesapp/variable_screens/goalscreen.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/services/auth_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:circlesapp/variable_screens/taskscreen.dart';
import 'package:flutter/material.dart';

import '../../../services/circles_service.dart';

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
      await GoalService().fetchGoals();

      setState(() {});
    }
  }

  List<Task> tasks = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _markTaskCompleteOrIncomplete(Task task) async {
    if (task.complete! && context.mounted) {
      DateTime nextDate = DateTime.now();

      switch (task.repeat) {
        case "Daily":
          {
            nextDate = DateTime(
              nextDate.year,
              nextDate.month,
              nextDate.day + 1,
            );
            break;
          }
        case "Weekly":
          {
            nextDate = DateTime(
              nextDate.year,
              nextDate.month,
              nextDate.day - nextDate.weekday % 7,
            );
            break;
          }
        case "Monthly":
          {
            nextDate = DateTime(nextDate.year, nextDate.month + 1, 0);
            break;
          }
      }

      task.nextDate = nextDate;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return TaskCompleteDialog(
            onPressedShare: () {},
            onPressedDismiss: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    } else {
      DateTime nextDate = DateTime.now();

      switch (task.repeat) {
        case "Weekly":
          {
            nextDate = DateTime(
              nextDate.year,
              nextDate.month,
              nextDate.day - nextDate.weekday % 7,
            );
            break;
          }
        case "Monthly":
          {
            nextDate = DateTime(nextDate.year, nextDate.month - 1, 0);
            break;
          }
      }

      task.nextDate = nextDate;
    }

    await GoalService().updateTask(task);
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
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => TaskScreen(
              task: task,
            ),
          ),
        );
      }
    } else if (result == "Complete Task") {
      setState(() {
        task.complete = !task.complete!;
        _markTaskCompleteOrIncomplete(task);
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

  void _showActionsGoalMenu(BuildContext context, Goal goal) async {
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
          value: "Edit Goal",
          child: Text("Edit ${goal.name}"),
        ),
        PopupMenuItem(
          value: "Delete Goal",
          child: Text("Delete ${goal.name}"),
        ),
      ],
    );

    if (result == "Edit Goal") {
      if (context.mounted) {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GoalScreen(
              goal: goal,
            ),
          ),
        );
      }
    } else if (result == "Delete Goal") {
      await GoalService().deleteGoal(goal.id!);

      setState(() {
        List<Goal> goals = List.empty(growable: true);
        GoalService.goals.then(
          (value) {
            for (Goal obj in value) {
              if (obj.id != goal.id) {
                goals.add(obj);
              }
            }
          },
        );

        GoalService.goals = Future.value(
          goals,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            toolbarHeight: MediaQuery.of(context).size.height / 8.5,
            flexibleSpace: const Image(
              image: CachedNetworkImageProvider(
                'https://picsum.photos/600/600',
              ),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Transform.translate(
                  offset: const Offset(0, 15.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          UserImageWidget(
                            photoUrl: UserService.dataUser.photoUrl,
                            dimensions: 100.0,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            children: [
                              Text(
                                UserService.dataUser.name!.replaceAll(
                                  " ",
                                  "\n",
                                ),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Theme.of(context).canvasColor,
                        ),
                        height: 40.0,
                        width: 40.0,
                        alignment: Alignment.center,
                        child: Center(
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.settings,
                              size: 20.0,
                              color: Colors.black,
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
        body: RefreshIndicator(
          onRefresh: () async {
            await GoalService().fetchGoals();
            await CircleService().fetchCircles();
          },
          backgroundColor: Theme.of(context).primaryColorLight,
          color: Theme.of(context).primaryColor,
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.fromLTRB(12.0, 40.0, 12.0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "UPCOMING TASKS",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  FutureBuilder<List<Goal>>(
                    future: GoalService.goals,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else if (snapshot.hasData) {
                        tasks = List.empty(growable: true);
                        for (var goal in snapshot.data!) {
                          for (var task in goal.tasks!) {
                            if (!task.complete! ||
                                task.nextDate!.compareTo(
                                      DateTime.now(),
                                    ) >=
                                    0) {
                              tasks.add(task);
                            }
                          }
                        }
                        if (tasks.isEmpty) {
                          return Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 5),
                            color: Theme.of(context).primaryColorLight,
                            child: Center(
                              child: Text(
                                "No tasks for today!",
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        } else {
                          return SizedBox(
                            height: 120.0,
                            child: ListView.builder(
                              itemCount: tasks.length,
                              padding: const EdgeInsets.all(0),
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
                                    onChanged: (bool? value) {
                                      setState(() {
                                        tasks[index].complete = value!;
                                        _markTaskCompleteOrIncomplete(
                                          tasks[index],
                                        );
                                      });
                                    },
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
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "GOALS",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          CreateButton(
                            text: "Create Goal",
                            onPressed: () {
                              _navigateAndRefresh(context);
                            },
                          ),
                        ],
                      ),
                      FutureBuilder<List<Goal>>(
                        future: GoalService.goals,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else if (snapshot.hasData) {
                            if (snapshot.data!.isEmpty) {
                              return Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                color: Theme.of(context).primaryColorLight,
                                child: Center(
                                  child: Text(
                                    "Set your goals and make them happen",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox(
                                height: 110.0,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return GoalsListWidget(
                                      goal: snapshot.data![index],
                                      showActionsGoalMenu: _showActionsGoalMenu,
                                      getTapPosition: _getTapPosition,
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
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Circles",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          CreateButton(
                            text: "Join or Create Circle",
                            onPressed: () {
                              _navigateAndRefresh(context);
                            },
                          ),
                        ],
                      ),
                      FutureBuilder<List<Circle>>(
                        future: CircleService.circles,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return ListView.builder(
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CircleListWidget(
                                    circle: snapshot.data![index],
                                  );
                                },
                              );
                            } else {
                              return const SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "You are not a part of any circles yet...",
                                    style: TextStyle(
                                      fontSize: 26,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }

                          // By default, show a loading spinner.
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Signout'),
                      onPressed: () async {
                        await AuthService().signOut();
                        if (context.mounted) {
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/', (route) => false);
                        }
                      },
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
