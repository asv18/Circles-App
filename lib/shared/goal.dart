import 'package:circlesapp/shared/task.dart';

class Goal {
  String? id;
  final String name;
  final DateTime endDate;
  final String description;
  List<Task>? tasks;
  int? progress;
  String? owner;

  Goal({
    required this.id,
    required this.name,
    required this.endDate,
    required this.description,
    required this.progress,
    required this.owner,
  });

  Goal.newGoal({
    required this.name,
    required this.endDate,
    required this.description,
    required this.tasks,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json["id"] as String,
      name: json["name"] as String,
      endDate: DateTime.parse(json["finish_date"]),
      description: json["description"] as String,
      progress: int.parse(json["progress"]),
      owner: json["owner"] as String,
    );
  }
}
