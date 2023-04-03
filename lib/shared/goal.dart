import 'package:circlesapp/shared/task.dart';
import 'dart:convert';

class Goal implements Comparable<Goal> {
  String? id;
  final String name;
  final DateTime endDate;
  DateTime? startDate;
  final String? description;
  List<Task>? tasks;
  int? progress;
  String? owner;

  Goal({
    required this.id,
    required this.name,
    required this.endDate,
    required this.startDate,
    required this.description,
    required this.progress,
    required this.owner,
    required this.tasks,
  });

  Goal.newGoal({
    required this.name,
    required this.endDate,
    required this.description,
    required this.tasks,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    List<dynamic> list = json["tasks"];

    List<Task> tasks = [];

    for (var e in list) {
      Task task = Task.fromJson(e);

      tasks.add(task);
    }

    return Goal(
      id: json["id"] as String,
      name: json["name"] as String,
      endDate: DateTime.parse(json["finish_date"]),
      startDate: DateTime.parse(json["start_date"]),
      description: json["description"] as String,
      progress: int.parse(json["progress"]),
      owner: json["owner"] as String,
      tasks: tasks,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Goal && id == other.id;
  }

  @override
  int get hashCode => endDate.hashCode;

  @override
  String toString() => '{ id: $id }';

  @override
  int compareTo(Goal other) {
    // TODO: implement compareTo
    return endDate.compareTo(other.endDate);
  }
}
