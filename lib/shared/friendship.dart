import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/enums.dart';
import 'package:intl/intl.dart';

class Friendship {
  BigInt? id;
  String? user;
  String? other;
  RelationshipStatus? relationship;
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
      relationship: json["relationship"] == null
          ? null
          : json["relationship"] == "friends"
              ? RelationshipStatus.friends
              : RelationshipStatus.request,
      dateCreated: DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(json["date_created"], true)
          .toLocal(),
      lastInteractedDate: DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(json["last_interacted_date"], true)
          .toLocal(),
    );
  }
}
