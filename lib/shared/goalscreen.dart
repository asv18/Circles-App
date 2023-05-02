import 'dart:convert';

import 'package:circlesapp/services/data_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:circlesapp/shared/taskscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class GoalScreen extends StatefulWidget {
  GoalScreen({
    super.key,
    required this.goal,
  });

  Goal goal;

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  Offset _tapPosition = Offset.zero;
  List<Task>? tasks;

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
          value: "Mark Task",
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
    } else if (result == "Mark Task") {
      setState(() {
        task.complete = !task.complete!;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.goal.tasks != null) {
      tasks = [];
      for (var i in widget.goal.tasks!) {
        Task task = Task(
          id: i.id,
          name: i.name,
          repeat: i.repeat,
          startDate: i.startDate,
          nextDate: i.nextDate,
          complete: i.complete,
          owner: i.owner,
        );
        tasks!.add(task);
      }
    } else {
      tasks = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (tasks != null) {
          List<Task> updatedTasks = List.empty(growable: true);

          for (int i = 0; i < tasks!.length; i++) {
            if (tasks![i].complete! &&
                DateTime.now().compareTo(tasks![i].nextDate!) >= 0) {
              Task updateTask = widget.goal.tasks![i];
              DateTime startingPointDate = updateTask.nextDate!;

              if (DateTime.now().compareTo(startingPointDate) == 1) {
                startingPointDate = DateTime.now();

                if (updateTask.repeat == "Weekly") {
                  startingPointDate = startingPointDate.add(
                    Duration(
                      days: DateTime.daysPerWeek - startingPointDate.weekday,
                    ),
                  );
                }
              }

              switch (updateTask.repeat) {
                case "Daily":
                  if (updateTask.complete!) {
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
                  if (updateTask.complete!) {
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
                  if (updateTask.complete!) {
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

              updateTask.nextDate = startingPointDate;

              updatedTasks.add(updateTask);
            }
          }
          await DataService.updateTasks(updatedTasks, widget.goal);
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: (MediaQuery.of(context).size.height / 10),
          elevation: 2,
          backgroundColor: Colors.blue[800],
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
                          color: (widget.goal.tasks![index].nextDate!
                                      .compareTo(DateTime.now()) <
                                  0)
                              ? Colors.red[400]
                              : (widget.goal.tasks![index].complete!)
                                  ? Colors.green[400]
                                  : Colors.blue,
                        ),
                        child: InkWell(
                          onTapDown: (details) => _getTapPosition(details),
                          onLongPress: () => _showActionsTaskMenu(
                            context,
                            widget.goal.tasks![index],
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
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
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
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Colors.white,
                                    ),
                                    value: widget.goal.tasks![index].complete,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        widget.goal.tasks![index].complete =
                                            value!;
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
      ),
    );
  }
}
