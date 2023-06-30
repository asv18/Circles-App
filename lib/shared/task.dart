class Task {
  BigInt? id;
  String name;
  String repeat;
  DateTime? startDate;
  DateTime? nextDate;
  bool? complete;
  String? owner;

  Task({
    required this.id,
    required this.name,
    required this.repeat,
    required this.startDate,
    required this.nextDate,
    required this.complete,
    required this.owner,
  });

  Task.newTask({
    required this.name,
    required this.repeat,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: BigInt.parse(json["id"]),
      name: json["name"] as String,
      repeat: json["repeat"] as String,
      startDate: DateTime.parse(json["start_date"]),
      nextDate: DateTime.parse(json["next_date"]),
      complete: json["complete"].toString().toLowerCase() == 'true',
      owner: json["goal_id"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id.toString(),
      "name": name,
      "repeat": repeat,
      "start_date": (startDate ?? DateTime.now()).toIso8601String(),
      "next_date": nextDate!.toIso8601String(),
      "complete": complete,
      "owner": owner,
    };
  }

  Map<String, dynamic> toJsonNew() {
    return {
      "name": name,
      "repeat": repeat,
      "owner": owner,
    };
  }

  @override
  bool operator ==(Object other) {
    return other is Task && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    // TODO: implement toString
    return toJsonNew().toString();
  }
}
