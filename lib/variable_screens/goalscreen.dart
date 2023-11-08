import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/components/UI/custom_text_button.dart';
import 'package:circlesapp/components/UI/custom_text_field.dart';
import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/components/type_based/Goals/Tasks/edit_task_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
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

  late final TextEditingController _goalNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _dateTextController;
  late DateTime _selectedDate;
  late List<Task> tasks;
  late List<Task> newTasks;

  List<bool> toggled = [];

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

    tasks = [...widget.goal.tasks!];

    newTasks = [...widget.goal.tasks!];
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
                    "No Update Goal",
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
                child: (tasks.isNotEmpty)
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: newTasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return EditTaskWidget(
                            task: tasks[index],
                            onDismissed: (direction) {
                              setState(() {
                                if (index < tasks.length) {
                                  tasks.removeAt(index);
                                }

                                newTasks.removeAt(index);
                              });
                            },
                            onChangedName: (value) {
                              setState(() {
                                if (index < tasks.length) {
                                  tasks[index].name = value!;
                                }

                                newTasks[index].name = value!;
                              });
                            },
                            onChangedDropdown: (String? value) {
                              setState(() {
                                if (index < tasks.length) {
                                  tasks[index].repeat = value!;
                                }

                                newTasks[index].repeat = value!;
                              });
                            },
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

                        newTasks.add(
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
                  onPressed: () async {
                    if (_goalNameController.text.isEmpty ||
                        _dateTextController.text == "mm / dd / yyyy" ||
                        anyNull(newTasks)) {
                      List<String> neglected = [];

                      if (_goalNameController.text.isEmpty) {
                        neglected.add("Goal Name");
                      }

                      if (_dateTextController.text == "mm / dd / yyyy") {
                        neglected.add("Date");
                      }

                      if (anyNull(tasks)) {
                        neglected.add("Task Names/Repeats");
                      }

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "You have left the following fields blank: ${neglected.toString().substring(1, neglected.toString().length - 1)}",
                          textAlign: TextAlign.center,
                        ),
                        duration: const Duration(seconds: 5),
                      ));
                    } else {
                      widget.goal.name = _goalNameController.text;
                      widget.goal.endDate = _selectedDate;
                      widget.goal.description = _descriptionController.text;

                      await GoalService().updateGoal(
                        widget.goal,
                        tasks,
                        newTasks,
                      );

                      if (mounted) {
                        mainKeyNav.currentState!.pop(
                          [
                            "Updated Goal",
                          ],
                        );
                      }
                    }
                  },
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
