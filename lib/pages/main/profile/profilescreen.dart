import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/components/type_based/Users/user_image_widget.dart';
import 'package:circlesapp/components/type_based/Circles/circles_list_widget.dart';
import 'package:circlesapp/components/type_based/Goals/goals_list_widget.dart';
import 'package:circlesapp/components/type_based/Goals/Tasks/task_complete_dialog.dart';
import 'package:circlesapp/components/type_based/Goals/Tasks/task_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/variable_screens/circles/circlescreen.dart';
import 'package:circlesapp/variable_screens/edit_goal_screen.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/services/auth_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:flutter/material.dart';

import '../../../services/circles_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Offset _tapPosition = Offset.zero;
  String type = "/profile/circles/tag";

  List<Task> tasks = List.empty(growable: true);

  Future<void> _markTaskCompleteOrIncomplete(Task task) async {
    if (task.complete! && mainKeyNav.currentState!.mounted) {
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
              nextDate.day - nextDate.weekday % 7 + 7,
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
            // onPressedShare: () async {
            //   CirclePost taskPost = CirclePost(
            //     taskID: task.id.toString(),
            //     title: "${UserService.dataUser.name} completed ${task.name}!",
            //   );

            //   await CircleService().createPost(taskPost, )
            // },
            onPressedDismiss: () {
              mainKeyNav.currentState!.pop();
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
            "Mark ${task.name} as ${(task.complete!) ? "incomplete" : "complete"}",
          ),
        ),
      ],
    );

    if (result == "Edit Task") {
      if (mainKeyNav.currentState!.mounted) {
        Goal? goal = await GoalService.goals.then(
          (value) {
            for (Goal g in value) {
              if (g.id == task.owner) return g;
            }
            return null;
          },
        );

        if (goal != null) {
          await mainKeyNav.currentState!.push(
            MaterialPageRoute(
              builder: (context) => GoalScreen(
                goal: goal,
              ),
            ),
          );
        }
      }
    } else if (result == "Complete Task") {
      setState(() {
        task.complete = !task.complete!;
        _markTaskCompleteOrIncomplete(task);
      });
    }
  }

  void _getTapPosition(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(details.globalPosition);
    });
  }

  String genTag = "/profile/image";
  String userTag = "/user/image/${UserService.dataUser.photoUrl}";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            toolbarHeight: ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              110,
            ),
            flexibleSpace: Hero(
              tag: genTag,
              child: const Image(
                image: CachedNetworkImageProvider(
                  'https://picsum.photos/600/600',
                ),
                fit: BoxFit.cover,
              ),
            ),
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  48,
                ),
              ),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: ComponentService.convertWidth(
                    MediaQuery.of(context).size.width,
                    20,
                  ),
                ),
                child: Transform.translate(
                  offset: Offset(
                    0,
                    ComponentService.convertWidth(
                      MediaQuery.of(context).size.width,
                      15,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: userTag,
                            child: UserImageWidget(
                              photoUrl: UserService.dataUser.photoUrl ??
                                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                              dimensions: ComponentService.convertWidth(
                                MediaQuery.of(context).size.width,
                                100,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: ComponentService.convertWidth(
                              MediaQuery.of(context).size.width,
                              15,
                            ),
                          ),
                          DefaultTextStyle(
                            style: Theme.of(context).textTheme.titleLarge!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            child: Text(
                              UserService.dataUser.name!,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Theme.of(context).canvasColor,
                        ),
                        height: ComponentService.convertWidth(
                          MediaQuery.of(context).size.width,
                          40,
                        ),
                        width: ComponentService.convertWidth(
                          MediaQuery.of(context).size.width,
                          40,
                        ),
                        alignment: Alignment.center,
                        child: Center(
                          child: IconButton(
                            onPressed: () async {
                              await mainKeyNav.currentState!.pushNamed(
                                "/edituser",
                              );

                              setState(() {});
                            },
                            icon: const Icon(
                              Icons.settings,
                              size: 18.0,
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
              margin: EdgeInsets.fromLTRB(
                ComponentService.convertWidth(
                  MediaQuery.of(context).size.width,
                  12,
                ),
                ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  40,
                ),
                ComponentService.convertWidth(
                  MediaQuery.of(context).size.width,
                  12,
                ),
                0,
              ),
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
                          if (goal.progress! < 100) {
                            for (var task in goal.tasks!) {
                              if (!task.complete! ||
                                  task.nextDate!.compareTo(DateTime.now()) >=
                                      0) {
                                tasks.add(task);
                              }
                            }
                          }
                        }

                        tasks.sort(
                          ((x, y) {
                            return (x.complete == y.complete)
                                ? 0
                                : (x.complete! ? 1 : -1);
                          }),
                        );

                        if (tasks.isEmpty) {
                          return Container(
                            height: ComponentService.convertWidth(
                              MediaQuery.of(context).size.width,
                              120,
                            ),
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
                            height: ComponentService.convertWidth(
                              MediaQuery.of(context).size.width,
                              120,
                            ),
                            child: ListView.builder(
                              itemCount: tasks.length,
                              padding: const EdgeInsets.all(0),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return TaskWidget(
                                  task: tasks[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      tasks[index].complete = value!;
                                      _markTaskCompleteOrIncomplete(
                                        tasks[index],
                                      );
                                    });
                                  },
                                  showActionsTaskMenu: _showActionsTaskMenu,
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
                  SizedBox(
                    height: ComponentService.convertHeight(
                      MediaQuery.of(context).size.height,
                      5,
                    ),
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
                            onPressed: () async {
                              await ComponentService
                                  .navigateAndRefreshCreateGoal(
                                context,
                                null,
                              );

                              setState(() {});
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
                                height: ComponentService.convertWidth(
                                  MediaQuery.of(context).size.width,
                                  120,
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                  vertical: ComponentService.convertHeight(
                                    MediaQuery.of(context).size.height,
                                    10,
                                  ),
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
                                height: ComponentService.convertWidth(
                                  MediaQuery.of(context).size.width,
                                  110,
                                ),
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return GoalsListWidget(
                                      goal: snapshot.data![index],
                                      showActionsGoalMenu: () async {
                                        await ComponentService
                                            .showActionsGoalMenu(
                                          context,
                                          snapshot.data![index],
                                          _tapPosition,
                                          () {
                                            setState(() {
                                              List<Goal> goals =
                                                  List.empty(growable: true);
                                              GoalService.goals.then(
                                                (value) {
                                                  for (Goal obj in value) {
                                                    if (obj.id !=
                                                        snapshot
                                                            .data![index].id) {
                                                      goals.add(obj);
                                                    }
                                                  }
                                                },
                                              );

                                              GoalService.goals = Future.value(
                                                goals,
                                              );
                                            });
                                          },
                                        );

                                        setState(() {});
                                      },
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
                  SizedBox(
                    height: ComponentService.convertHeight(
                      MediaQuery.of(context).size.height,
                      5,
                    ),
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
                            text: "Create or Join Circle",
                            onPressed: () async {
                              await ComponentService
                                  .navigateAndRefreshCreateCircles(
                                context,
                                null,
                              );

                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ComponentService.convertHeight(
                          MediaQuery.of(context).size.height,
                          10,
                        ),
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
                                    tag: "${snapshot.data![index].id}$type",
                                    circle: snapshot.data![index],
                                    getTapPosition: _getTapPosition,
                                    showActionsCircleMenu: () async {
                                      await ComponentService
                                          .showActionsCircleMenu(
                                        context,
                                        snapshot.data![index],
                                        _tapPosition,
                                      );

                                      setState(() {});
                                    },
                                    navigate: () {
                                      mainKeyNav.currentState!.push(
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 400),
                                          pageBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation,
                                          ) {
                                            return CircleScreen(
                                              circle: snapshot.data![index],
                                              tag:
                                                  "${snapshot.data![index].id}$type",
                                            );
                                          },
                                          transitionsBuilder: (
                                            BuildContext context,
                                            Animation<double> animation,
                                            Animation<double>
                                                secondaryAnimation,
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
                                  );
                                },
                              );
                            } else {
                              return Container(
                                height: ComponentService.convertHeight(
                                  MediaQuery.of(context).size.height,
                                  120,
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                  vertical: ComponentService.convertHeight(
                                    MediaQuery.of(context).size.height,
                                    10,
                                  ),
                                ),
                                color: Theme.of(context).primaryColorLight,
                                child: Center(
                                  child: Text(
                                    "Join a circle and share your goals",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
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
                  SizedBox(
                    height: ComponentService.convertHeight(
                      MediaQuery.of(context).size.height,
                      5,
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Sign Out',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      onPressed: () async {
                        await AuthService().signOut();
                        if (mainKeyNav.currentState!.mounted) {
                          mainKeyNav.currentState!
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
