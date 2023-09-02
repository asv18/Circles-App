import 'package:circlesapp/shared/task.dart';

class Goal implements Comparable<Goal> {
  String? id;
  final String name;
  final DateTime endDate;
  DateTime? startDate;
  String? description;
  List<Task>? tasks;
  int? progress;

  Goal({
    this.id,
    required this.name,
    required this.endDate,
    this.startDate,
    this.description,
    this.progress,
    this.tasks,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    List<dynamic> rawTasks = json["tasks"];

    List<Task> tasks = List.empty(growable: true);

    for (var e in rawTasks) {
      Task task = Task.fromJson(e);

      tasks.add(task);
    }

    return Goal(
      id: json["id"] as String,
      name: json["name"] as String,
      endDate: DateTime.parse(json["finish_date"]),
      startDate: DateTime.parse(json["start_date"]),
      description: json["description"] as String,
      progress: ((((DateTime.now().millisecondsSinceEpoch -
                          DateTime.parse(json["start_date"])
                              .millisecondsSinceEpoch) /
                      (DateTime.parse(json["finish_date"])
                              .millisecondsSinceEpoch -
                          DateTime.parse(json["start_date"])
                              .millisecondsSinceEpoch)) *
                  100.0) +
              0.5)
          .floor(),
      tasks: tasks,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "end_date": endDate,
      "start_date": startDate,
      "description": description,
      "progress": progress,
      "tasks": tasks,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Goal && id == other.id;
  }

  @override
  int get hashCode => endDate.hashCode;

  @override
  String toString() => toJson().toString();

  @override
  int compareTo(Goal other) {
    return endDate.compareTo(other.endDate);
  }
}
