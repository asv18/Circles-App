import 'package:circlesapp/services/user_service.dart';

class Friendship {
  BigInt? id;
  String? user;
  String? other;
  String? relationship;
  DateTime? dateCreated;
  DateTime? lastInteractedDate;

  Friendship({
    required this.id,
    required this.user,
    required this.other,
    required this.relationship,
    this.dateCreated,
    required this.lastInteractedDate,
  });

  factory Friendship.fromJson(Map<String, dynamic> json) {
    String user;
    String other;

    if (json["user1"] as String == UserService.dataUser.fKey) {
      user = json["user1"] as String;
      other = json["user2"] as String;
    } else {
      other = json["user1"] as String;
      user = json["user2"] as String;
    }

    return Friendship(
      id: BigInt.parse(json["id"]),
      user: user,
      other: other,
      relationship: json["relationship"] as String,
      dateCreated: DateTime.parse(json["date_created"]),
      lastInteractedDate: DateTime.parse(json["last_interacted_date"]),
    );
  }
}
