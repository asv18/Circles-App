import 'package:circlesapp/shared/task.dart';
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({
    super.key,
    required this.task,
  });
  final Task task;
  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<String> spinnerItems = [
    "Never",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Edit Task",
          style: TextStyle(
            color: Colors.black,
            fontSize: 48.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.grey[50],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: TextEditingController.fromValue(
                TextEditingValue(
                  text: widget.task.name,
                ),
              ),
              decoration: const InputDecoration(
                helperText: "Task Name",
                helperStyle: TextStyle(fontSize: 18),
              ),
              style: const TextStyle(
                fontSize: 22,
              ),
              onChanged: (value) {
                setState(() {
                  widget.task.name = value;
                });
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.centerLeft,
              child: DropdownButton<String>(
                value: widget.task.repeat,
                onChanged: (String? value) {
                  setState(() {
                    widget.task.repeat = value!;
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
            ),
          ],
        ),
      ),
    );
  }
}
