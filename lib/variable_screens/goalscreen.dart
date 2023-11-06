import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/components/UI/custom_text_button.dart';
import 'package:circlesapp/components/UI/custom_text_field.dart';
import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/components/type_based/Goals/Tasks/task_complete_dialog.dart';
import 'package:circlesapp/components/type_based/Goals/Tasks/task_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:circlesapp/variable_screens/taskscreen.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

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
  final taskLimit = const SnackBar(
    content: Text(
      "You have reached the max limit of tasks",
      textAlign: TextAlign.center,
    ),
    duration: Duration(seconds: 5),
  );

  Offset _tapPosition = Offset.zero;

  late final TextEditingController _goalNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateTextController;
  late DateTime _selectedDate;
  late List<Task> tasks;

  List<bool> toggled = [];

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
            "Mark ${task.name} as ${(task.complete!) ? "incomplete" : "complete"}",
          ),
        ),
      ],
    );

    if (result == "Edit Task") {
      if (mainKeyNav.currentState!.mounted) {
        mainKeyNav.currentState!.push(
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

  @override
  void initState() {
    super.initState();

    _goalNameController = TextEditingController(text: widget.goal.name);

    _descriptionController = TextEditingController(
      text: widget.goal.description,
    );

    _selectedDate = widget.goal.endDate;

    _dateTextController = TextEditingController(
      text:
          "${_selectedDate.month} / ${_selectedDate.day} / ${_selectedDate.year}",
    );

    tasks = widget.goal.tasks!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: Text(
          widget.goal.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ExitButton(
              onPressed: () {
                mainKeyNav.currentState!.pop(
                  [
                    "Goal Not Edited",
                  ],
                );
              },
              icon: FontAwesome.x,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
        ],
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                labelText: "Goal Title",
                hintText: "What do you want to achieve?",
                controller: _goalNameController,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextField(
                labelText: "Goal Description",
                hintText: "What best describes your goal?",
                controller: _descriptionController,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextField(
                labelText: "Goal End Date",
                hintText: "By when do you want to achieve this?",
                controller: _dateTextController,
                readOnly: true,
                suffixIcon: const Icon(
                  Bootstrap.calendar3,
                  color: Colors.black,
                  size: 24,
                ),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(1999),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _dateTextController.text =
                          "${_selectedDate.month} / ${_selectedDate.day} / ${_selectedDate.year}";
                    });
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                "Your tasks for this goal",
                maxLines: 2,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                height: 120,
                child: (tasks.isNotEmpty)
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: tasks.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
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
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20.0),
                        color: Theme.of(context).primaryColorLight,
                        child: Center(
                          child: Text(
                            "Set tasks to help your goals",
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CreateButton(
                    text: "Add Task",
                    onPressed: () {
                      setState(() {
                        tasks.add(
                          Task(
                            name: "",
                            repeat: "Never",
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              Align(
                alignment: Alignment.center,
                child: CustomTextButton(
                  onPressed: () async {},
                  text: "Update Goal",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool anyNull(List<Task> tasks) {
    for (Task task in tasks) {
      if (task.name == "") {
        return true;
      }
    }
    return false;
  }
}
