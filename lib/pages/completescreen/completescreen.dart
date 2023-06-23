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
        leading: BackButton(
          color: Colors.black,
          onPressed: () {},
        ),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Complete Task",
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
          children: [],
        ),
      ),
    );
  }
}
