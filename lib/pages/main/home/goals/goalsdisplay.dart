import 'package:circlesapp/components/create_button.dart';
import 'package:circlesapp/components/goal_widget.dart';
import 'package:circlesapp/services/data_service.dart';
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
      await DataService().fetchGoals();

      setState(() {});
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
      await DataService().deleteGoal(goal.id!);

      setState(() {
        List<Goal> goals = List.empty(growable: true);
        DataService.goals.then(
          (value) {
            for (Goal obj in value) {
              if (obj.id != goal.id) {
                goals.add(obj);
              }
            }
          },
        );

        DataService.goals = Future.value(
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
        await DataService().fetchGoals();
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
                future: DataService.goals,
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
