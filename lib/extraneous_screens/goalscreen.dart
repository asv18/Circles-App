import 'package:circlesapp/services/data_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:circlesapp/extraneous_screens/taskscreen.dart';
import 'package:flutter/material.dart';

void markCompleteOrUncomplete(Task task, Goal goal) async {
  DateTime startingPointDate = DateTime.now();

  if (task.repeat == "Weekly") {
    startingPointDate = startingPointDate.add(
      Duration(
        days: DateTime.daysPerWeek - startingPointDate.weekday,
      ),
    );
  }

  switch (task.repeat) {
    case "Daily":
      if (task.complete!) {
        startingPointDate = DateTime(
          startingPointDate.year,
          startingPointDate.month,
          startingPointDate.day + 1,
        );
      } else if (DateTime(
            startingPointDate.year,
            startingPointDate.month,
            startingPointDate.day - 1,
          ).compareTo(
            DateTime.now(),
          ) ==
          1) {
        startingPointDate = DateTime(
          startingPointDate.year,
          startingPointDate.month,
          startingPointDate.day - 1,
        );
      }
      break;
    case "Weekly":
      if (task.complete!) {
        startingPointDate = DateTime(
          startingPointDate.year,
          startingPointDate.month,
          startingPointDate.day + 7,
        );
      } else {
        startingPointDate = DateTime(
          startingPointDate.year,
          startingPointDate.month,
          startingPointDate.day - 7,
        );
      }
      break;
    case "Monthly":
      if (task.complete!) {
        startingPointDate = DateTime(
          startingPointDate.year,
          startingPointDate.month + 2,
          0,
        );
      } else if (DateTime(
            startingPointDate.year,
            startingPointDate.month - 1,
            0,
          ).compareTo(
            DateTime.now(),
          ) ==
          1) {
        startingPointDate = DateTime(
          startingPointDate.year,
          startingPointDate.month - 1,
          0,
        );
      }
      break;
  }

  task.nextDate = startingPointDate;
  await DataService().updateTask(task);
}

class GoalScreen extends StatefulWidget {
  const GoalScreen({
    super.key,
    required this.goal,
  });

  final Goal goal;

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(details.globalPosition);
    });
  }

  void _showActionsTaskMenu(
    BuildContext context,
    Task task,
    int index,
  ) async {
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
          child: Text(
            "Edit ${task.name}",
          ),
        ),
        PopupMenuItem(
          value: "Mark Task",
          child: Text(
            "Mark ${task.name} as ${(task.complete!) ? "incomplete" : "complete"}",
          ),
        ),
        PopupMenuItem(
          value: "Delete Task",
          child: Text(
            "Delete ${task.name}",
          ),
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

        // DataService.updateTask(task, widget.goal);
        markCompleteOrUncomplete(task, widget.goal);
      });
    } else if (result == "Delete Task") {
      setState(() {
        widget.goal.tasks!.removeAt(index);
      });

      DataService().deleteTask(task.owner!, task.id!);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: (MediaQuery.of(context).size.height / 10),
        elevation: 2,
        backgroundColor: Theme.of(context).primaryColorDark,
        title: Text(
          DataService.truncateWithEllipsis(
            32,
            widget.goal.name,
          ),
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
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.goal.tasks!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 225.0,
                      margin: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: (widget.goal.tasks![index].complete!)
                            ? Colors.green[400]
                            : (widget.goal.tasks![index].repeat != "Never")
                                ? (widget.goal.tasks![index].nextDate!
                                            .compareTo(DateTime.now()) <
                                        0)
                                    ? Colors.red[400]
                                    : Theme.of(context).primaryColor
                                : Theme.of(context).primaryColor,
                      ),
                      child: InkWell(
                        onTapDown: (details) => _getTapPosition(details),
                        onLongPress: () => _showActionsTaskMenu(
                          context,
                          widget.goal.tasks![index],
                          index,
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 30.0,
                            vertical: 20.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 200.0,
                                    margin: const EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      DataService.truncateWithEllipsis(
                                        15,
                                        widget.goal.tasks![index].name,
                                      ),
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    (widget.goal.tasks![index].repeat ==
                                            "Never")
                                        ? "Not Recurring"
                                        : widget.goal.tasks![index].repeat,
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
                                  fillColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.white,
                                  ),
                                  value: widget.goal.tasks![index].complete,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      widget.goal.tasks![index].complete =
                                          value!;

                                      // DataService.updateTask(
                                      //   widget.goal.tasks![index],
                                      //   widget.goal,
                                      // );
                                      markCompleteOrUncomplete(
                                        widget.goal.tasks![index],
                                        widget.goal,
                                      );
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
            ],
          ),
        ),
      ),
    );
  }
}
