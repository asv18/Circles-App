import 'package:circlesapp/services/data_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/goalscreen.dart';
import 'package:flutter/material.dart';

class GoalsDisp extends StatefulWidget {
  const GoalsDisp({super.key});

  @override
  State<GoalsDisp> createState() => _GoalsDispState();
}

class _GoalsDispState extends State<GoalsDisp>
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
      setState(() {
        goals = DataService.fetchGoals();
      });
    }
  }

  void _getTapPosition(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(details.globalPosition);
    });
  }

  void _showActionsGoalMenu(BuildContext context, Goal goal) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy + 60 + 178, 100, 100),
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
          child: Text("Edit ${goal.name}"),
        ),
        PopupMenuItem(
          value: "Delete Goal",
          child: Text("Delete ${goal.name}"),
        ),
      ],
    );

    if (result == "Edit Goal") {
      return;
    } else if (result == "Delete Goal") {
      await DataService.deleteGoal(goal.id!);
      setState(() {
        goals = DataService.fetchGoals();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goals = DataService.fetchGoals();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          goals = DataService.fetchGoals();
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 10.0, 50.0, 10.0),
            decoration: BoxDecoration(
              color: Colors.blue[800],
              borderRadius: BorderRadius.circular(20.0),
            ),
            width: 100.0,
            height: 40.0,
            child: TextButton(
              onPressed: () {
                _navigateAndRefresh(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  Text(
                    "Create",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: goals,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    snapshot.data!.sort();
                    return ListView.builder(
                      itemCount:
                          snapshot.data != null ? snapshot.data!.length : 0,
                      itemBuilder: (BuildContext context, int index) {
                        return GoalWidget(
                          goals: snapshot.data!,
                          index: index,
                          showActionsGoalMenu: _showActionsGoalMenu,
                          getTapPosition: _getTapPosition,
                        );
                      },
                    );
                  } else {
                    return const SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          "You have no goals yet...",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class GoalWidget extends StatelessWidget {
  const GoalWidget({
    Key? key,
    required this.goals,
    required this.index,
    required this.showActionsGoalMenu,
    required this.getTapPosition,
  }) : super(key: key);

  final List<Goal> goals;
  final int index;
  final Function showActionsGoalMenu;
  final Function getTapPosition;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (details) => getTapPosition(details),
      onLongPress: () => showActionsGoalMenu(
        context,
        goals[index],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GoalScreen(
              goal: goals[index],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        height: 175.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.blue[800],
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DataService.truncateWithEllipsis(8, goals[index].name),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(2.5, 2.5),
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) {
                        if (i < goals[index].progress!.toInt()) {
                          return Container(
                            margin: const EdgeInsets.only(right: 5.0),
                            child: Stack(
                              children: [
                                const Positioned(
                                  left: 1.0,
                                  top: 2.0,
                                  child: Icon(
                                    Icons.circle,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  Icons.circle,
                                  color: Colors.green[500],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.only(right: 5.0),
                            child: Stack(
                              children: [
                                const Positioned(
                                  left: 1.0,
                                  top: 2.0,
                                  child: Icon(
                                    Icons.circle_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                                Icon(
                                  Icons.circle_outlined,
                                  color: Colors.green[500],
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Time Left: ${timeLeft(goals[index].endDate)}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(
                        offset: const Offset(2.5, 2.5),
                        blurRadius: 10.0,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
              ),
              Text(
                DataService.truncateWithEllipsis(
                  20,
                  (goals[index].description != "null")
                      ? goals[index].description!
                      : "",
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  shadows: [
                    Shadow(
                      offset: const Offset(2.5, 2.5),
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String timeLeft(DateTime date) {
  int years = (date.difference(DateTime.now()).inHours / 8760).round();
  int months = (date.difference(DateTime.now()).inHours / 730).round();
  int days = (date.difference(DateTime.now()).inHours / 24).round();
  int hours = (date.difference(DateTime.now()).inHours).round();

  if (years != 0) {
    if (years > 1) {
      return "$years years";
    } else {
      return "$years year";
    }
  } else if (months != 0) {
    if (months > 1) {
      return "$months months";
    } else {
      return "$months month";
    }
  } else if (days != 0) {
    if (days > 1) {
      return "$days days";
    } else {
      return "$days day";
    }
  } else {
    if (hours > 1) {
      return "$hours hours";
    } else {
      return "$hours hour";
    }
  }
}
