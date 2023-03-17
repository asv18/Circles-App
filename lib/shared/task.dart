class Task {
  int? id;
  String name;
  String repeat;
  DateTime? startDate;
  DateTime? endDate;
  bool? complete;

  Task({
    required this.id,
    required this.name,
    required this.repeat,
    required this.startDate,
    required this.endDate,
  });

  Task.newTask({
    required this.name,
    required this.repeat,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: int.parse(json["id"]),
      name: json["name"] as String,
      repeat: json["repeat"] as String,
      startDate: DateTime.parse(json["start_date"]),
      endDate: DateTime.parse(json["endDate"]),
    );
  }
}
