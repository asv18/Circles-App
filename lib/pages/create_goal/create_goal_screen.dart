import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/components/UI/custom_text_button.dart';
import 'package:circlesapp/components/UI/custom_text_field.dart';
import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/components/type_based/Circles/circle_list_toggle.dart';
import 'package:circlesapp/components/type_based/Goals/Tasks/new_task_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final taskLimit = const SnackBar(
    content: Text(
      "You have reached the max limit of tasks",
      textAlign: TextAlign.center,
    ),
    duration: Duration(seconds: 5),
  );

  final _goalNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateTextController = TextEditingController(text: "mm / dd / yyyy");
  DateTime _selectedDate = DateTime.now();
  List<Task> tasks = [
    Task(
      name: "",
      repeat: "Never",
    ),
  ];

  List<bool> toggled = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          60,
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "CREATE A NEW GOAL",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ExitButton(
              onPressed: () {
                mainKeyNav.currentState!.pop(
                  [
                    "Goal Not Created",
                  ],
                );
              },
              icon: FontAwesome.x_solid,
            ),
          ],
        ),
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).canvasColor,
          margin: EdgeInsets.fromLTRB(
            ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              16,
            ),
            ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              15,
            ),
            ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              16,
            ),
            ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              40,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                labelText: "Goal Title",
                hintText: "What do you want to achieve?",
                controller: _goalNameController,
              ),
              SizedBox(
                height: ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  10,
                ),
              ),
              CustomTextField(
                labelText: "Goal Description",
                hintText: "What best describes your goal?",
                controller: _descriptionController,
              ),
              SizedBox(
                height: ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  10,
                ),
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
                    firstDate: DateTime.now(),
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
              SizedBox(
                height: ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  20,
                ),
              ),
              Text(
                "What are some tasks that will help you get there?",
                maxLines: 2,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Container(
                margin: EdgeInsets.only(
                  bottom: ComponentService.convertHeight(
                    MediaQuery.of(context).size.height,
                    10,
                  ),
                ),
                child: (tasks.isNotEmpty)
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: tasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return NewTaskWidget(
                            task: tasks[index],
                            onDismissed: (direction) {
                              setState(() {
                                tasks.removeAt(index);
                              });
                            },
                          );
                        },
                      )
                    : Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(
                          ComponentService.convertWidth(
                            MediaQuery.of(context).size.width,
                            20,
                          ),
                        ),
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
              SizedBox(
                height: ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  10,
                ),
              ),
              Text(
                "POST TO CIRCLES",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  10,
                ),
              ),
              FutureBuilder<List<Circle>>(
                future: CircleService.circles,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    toggled = List.generate(
                      snapshot.data!.length,
                      (int index) => false,
                      growable: false,
                    );

                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                              bottom: (index != snapshot.data!.length - 1)
                                  ? ComponentService.convertHeight(
                                      MediaQuery.of(context).size.height,
                                      10,
                                    )
                                  : 0,
                            ),
                            child: CircleListToggle(
                              circle: snapshot.data![index],
                              toggled: toggled,
                              index: index,
                            ),
                          );
                        },
                      );
                    } else {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(
                          ComponentService.convertWidth(
                            MediaQuery.of(context).size.width,
                            20,
                          ),
                        ),
                        color: Theme.of(context).primaryColorLight,
                        child: Center(
                          child: Text(
                            "You are not a part of any circles yet",
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              SizedBox(
                height: ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  100,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CustomTextButton(
                  onPressed: () async {
                    if (_goalNameController.text.isEmpty ||
                        _dateTextController.text == "mm / dd / yyyy" ||
                        anyNull(tasks)) {
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
                      Goal newGoal = Goal(
                        name: _goalNameController.text,
                        endDate: _selectedDate,
                        description: _descriptionController.text,
                        tasks: tasks,
                      );

                      await GoalService().createGoal(newGoal);

                      await CircleService.circles.then(
                        (value) async {
                          for (int i = 0; i < value.length; i++) {
                            if (toggled[i]) {
                              final goalPost = CirclePost(
                                title:
                                    "Support ${UserService.dataUser.name} in their new goal!",
                                description:
                                    "${UserService.dataUser.name}''s new goal: ${newGoal.name}",
                              );
                              await CircleService()
                                  .createPost(goalPost, value[i].id!);
                            }
                          }
                        },
                      );

                      if (mainKeyNav.currentState!.mounted) {
                        mainKeyNav.currentState!.pop(
                          [
                            "Goal Created",
                            newGoal,
                          ],
                        );
                      }
                    }
                  },
                  text: "Create New Goal",
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
