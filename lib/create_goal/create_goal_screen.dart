import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:flutter/material.dart';

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

  final List<Circle> _circles = [
    Circle(
        name: "circle 1",
        updates: 3,
        userCount: 5,
        image: "https://source.unsplash.com/random/400x400?sig=1"),
    Circle(
        name: "circle 2",
        updates: 8,
        userCount: 8,
        image: "https://source.unsplash.com/random/400x400?sig=2"),
    Circle(
        name: "circle 3",
        updates: 10,
        userCount: 3,
        image: "https://source.unsplash.com/random/400x400?sig=3"),
    Circle(
        name: "circle 4",
        updates: 7,
        userCount: 2,
        image: "https://source.unsplash.com/random/400x400?sig=4"),
    Circle(
        name: "circle 5",
        updates: 2,
        userCount: 6,
        image: "https://source.unsplash.com/random/400x400?sig=5"),
    Circle(
        name: "circle 6",
        updates: 6,
        userCount: 10,
        image: "https://source.unsplash.com/random/400x400?sig=6"),
  ];

  String? _goalName = null;
  String _dateText = "mm / dd / yyyy";
  DateTime _selectedDate = DateTime.now();
  List<Task> _tasks = [
    Task(
      name: "",
      repeat: "Repeats?",
    ),
  ];

  List<bool> toggled = List<bool>.filled(6, false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "New Goal",
          style: TextStyle(
            color: Colors.black,
            fontSize: 48.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.grey[50],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 40.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    margin: const EdgeInsets.only(right: 20.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "What do you want to achieve?",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        width: 275.0,
                        height: 50.0,
                        child: TextField(
                          decoration: const InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            hintText: "Think about the outcome you want...",
                            hintStyle: TextStyle(fontSize: 15.0),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _goalName = value;
                            });
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 30.0),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      child: const Icon(
                        Icons.calendar_month_outlined,
                        size: 75.0,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "By when?",
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          width: 275,
                          height: 50,
                          child: TextField(
                            readOnly: true,
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
                                  _dateText =
                                      "${_selectedDate.month} / ${_selectedDate.day} / ${_selectedDate.year}";
                                });
                              }
                            },
                            decoration: InputDecoration(
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              hintText: _dateText,
                              hintStyle: TextStyle(
                                fontSize: 15.0,
                                color: (_dateText == "mm / dd / yyyy")
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 30.0,
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      child: const Icon(
                        Icons.list,
                        size: 75.0,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        "What are some tasks that will help you get there?",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10.0),
                child: _tasks.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _tasks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            key: ValueKey<Task>(_tasks[index]),
                            onDismissed: (direction) {
                              setState(() {
                                _tasks.removeAt(index);
                              });
                            },
                            child: TaskWidget(
                              tasks: _tasks,
                              index: index,
                            ),
                          );
                        },
                      )
                    : SizedBox(
                        height: 170.0,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 30.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "We strongly recommend adding tasks to reach your goal",
                                style: TextStyle(
                                  fontSize: 20.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Icon(
                                Icons.dns_outlined,
                                size: 40.0,
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      if (_tasks.length == 10) {
                        ScaffoldMessenger.of(context).showSnackBar(taskLimit);
                      } else {
                        setState(() {
                          _tasks.add(
                            Task(
                              name: "",
                              repeat: "Repeats?",
                            ),
                          );
                        });
                      }
                    },
                    icon: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: const Divider(
                  thickness: 2.0,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    FlutterLogo(
                      size: 50.0,
                    ),
                    Text(
                      "Select a Circle (or Circles) to share this goal with",
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                      maxLines: 3,
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 4 / 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: _circles.length,
                  itemBuilder: (BuildContext context, index) {
                    return Material(
                      borderRadius: BorderRadius.circular(15.0),
                      color: (toggled[index])
                          ? Colors.deepPurple[200]
                          : Colors.blue,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            toggled[index] = !toggled[index];
                          });
                        },
                        child: Center(
                          child: Text(
                            _circles[index].name,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Center(
                  child: IconButton(
                    onPressed: () {
                      if (_goalName == null ||
                          _dateText == "mm / dd / yyyy" ||
                          anyNull(_tasks)) {
                        List<String> neglected = [];
                        if (_goalName == null) {
                          neglected.add("Goal Name");
                        }
                        if (_dateText == "mm / dd / yyyy") {
                          neglected.add("Date");
                        }

                        if (anyNull(_tasks)) {
                          neglected.add("Task Names/Repeats");
                        }

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "You have left the following fields blank: ${neglected.toString().substring(1, neglected.toString().length - 1)}",
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 5),
                        ));
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
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
      if (task.name == "" || task.repeat == "Repeats?") {
        return true;
      }
    }
    return false;
  }
}

class TaskWidget extends StatefulWidget {
  List<Task> tasks;
  int index;

  TaskWidget({super.key, required this.tasks, required this.index});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  List<String> spinnerItems = [
    "Repeats?",
    "Daily",
    "Weekly",
    "Monthly",
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      height: 130.0,
      child: Material(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(color: Colors.teal),
        ),
        color: Colors.white,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "${widget.index + 1}.",
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
              const SizedBox(
                width: 50.0,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText:
                            "Think about a milestone you can check off...",
                        hintStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          widget.tasks[widget.index].name = value;
                        });
                      },
                    ),
                    DropdownButton<String>(
                      value: widget.tasks[widget.index].repeat,
                      onChanged: (String? value) {
                        setState(() {
                          widget.tasks[widget.index].repeat = value!;
                        });
                      },
                      items: spinnerItems.map<DropdownMenuItem<String>>(
                        (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
