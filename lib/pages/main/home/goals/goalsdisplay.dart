import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/components/type_based/Goals/goal_widget.dart';
import 'package:circlesapp/extraneous_screens/goalscreen.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';

class GoalsDisp extends StatefulWidget {
  const GoalsDisp({super.key});

  @override
  State<GoalsDisp> createState() => _GoalsDispState();
}

class _GoalsDispState extends State<GoalsDisp> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await GoalService().fetchGoals();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 10,
              ),
              child: CreateButton(
                text: "Create",
                onPressed: () => _navigateAndRefresh(context),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Goal>>(
                future: GoalService.goals,
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
