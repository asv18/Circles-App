import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/components/type_based/Goals/goal_widget.dart';
import 'package:circlesapp/services/component_service.dart';
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

  void _getTapPosition(TapDownDetails details) {
    setState(() {
      _tapPosition = details.globalPosition;
    });
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
                onPressed: () async {
                  await ComponentService.navigateAndRefreshCreateGoal(
                    context,
                    widget.callback,
                  );

                  setState(() {});
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
                            showActionsGoalMenu: () async {
                              await ComponentService.showActionsGoalMenu(
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
                                              snapshot.data![index].id) {
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
