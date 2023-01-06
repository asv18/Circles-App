import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';

class GoalsDisp extends StatefulWidget {
  const GoalsDisp({super.key});

  @override
  State<GoalsDisp> createState() => _GoalsDispState();
}

class _GoalsDispState extends State<GoalsDisp> {
  List<Goal> goals = [
    Goal(
      name: "goal 1",
      timeLim: 3,
      numTasks: 4,
      numRecur: 1,
      progress: 2,
    ),
    Goal(
      name: "goal 2",
      timeLim: 5,
      numTasks: 2,
      numRecur: 1,
      progress: 1,
    ),
    Goal(
      name: "goal 3",
      timeLim: 1,
      numTasks: 2,
      numRecur: 0,
      progress: 4,
    ),
    Goal(
      name: "goal 4",
      timeLim: 8,
      numTasks: 6,
      numRecur: 3,
      progress: 4,
    ),
    Goal(
      name: "goal 5",
      timeLim: 2,
      numTasks: 6,
      numRecur: 4,
      progress: 3,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
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
              Navigator.pushNamed(context, '/creategoal');
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
          child: ListView.builder(
            itemCount: goals.length,
            itemBuilder: (BuildContext context, int index) {
              return GoalWidget(
                goals: goals,
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}

class GoalWidget extends StatelessWidget {
  const GoalWidget({
    Key? key,
    required this.goals,
    required this.index,
  }) : super(key: key);

  final List<Goal> goals;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  goals[index].name,
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
                      if (i < goals[index].progress) {
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
                "Time: ${goals[index].timeLim} months",
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
              "${goals[index].numTasks} tasks (${goals[index].numRecur} recurring)",
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
    );
  }
}
