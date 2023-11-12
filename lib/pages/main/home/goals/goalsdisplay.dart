import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/components/type_based/Goals/goal_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/variable_screens/edit_goal_screen.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';

class GoalsDisp extends StatefulWidget {
  const GoalsDisp({
    super.key,
    required this.callback,
  });

  final Function callback;

  @override
  State<GoalsDisp> createState() => _GoalsDispState();
}

class _GoalsDispState extends State<GoalsDisp> {
  Offset _tapPosition = Offset.zero;

  Future<void> _navigateAndRefresh(BuildContext context) async {
    final response = (await mainKeyNav.currentState!.pushNamed(
      '/creategoal',
    )) as List;

    if (!mainKeyNav.currentState!.mounted) return;

    if (response[0] == "Goal Created") {
      await GoalService().fetchGoals();

      widget.callback();
      setState(() {});
    }
  }

  void _getTapPosition(TapDownDetails details) {
    setState(() {
      _tapPosition = details.globalPosition;
    });
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
      if (mainKeyNav.currentState!.mounted) {
        final result = (await mainKeyNav.currentState!.push(
          MaterialPageRoute(
            builder: (context) => GoalScreen(
              goal: goal,
            ),
          ),
        )) as List;

        if (result[0] == "Updated Goal") {
          await GoalService().fetchGoals();

          setState(() {});
        }
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await GoalService().fetchGoals();
      },
      backgroundColor: Theme.of(context).primaryColorLight,
      color: Theme.of(context).primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "MY GOALS",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              CreateButton(
                onPressed: () {
                  _navigateAndRefresh(context);
                },
                text: "Create Goal",
              ),
            ],
          ),
          SizedBox(
            height: ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              10,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Goal>>(
              future: GoalService.goals,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    snapshot.data!.sort();
                    return SafeArea(
                      child: ListView.builder(
                        itemCount:
                            snapshot.data != null ? snapshot.data!.length : 0,
                        itemBuilder: (BuildContext context, int index) {
                          return GoalWidget(
                            goal: snapshot.data![index],
                            showActionsGoalMenu: _showActionsGoalMenu,
                            getTapPosition: _getTapPosition,
                          );
                        },
                      ),
                    );
                  } else {
                    return Container(
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
                          style: Theme.of(context).textTheme.headlineMedium,
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
          ),
        ],
      ),
    );
  }
}
