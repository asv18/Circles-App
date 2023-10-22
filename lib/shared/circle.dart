import 'package:circlesapp/shared/user.dart';
import 'package:intl/intl.dart';

class Circle {
  String? id;
  DateTime? lastInteractedDate;
  String? name;
  String? image;
  User? admin;
  List<User>? users;
  int? postCount;
  String? status;

  Circle({
    this.id,
    this.lastInteractedDate,
    this.name,
    this.image,
    this.admin,
    this.users,
    this.postCount,
    this.status,
  });

  factory Circle.fromJson(Map<String, dynamic> json) {
    List<dynamic> rawUsers = json["users"];

    List<User> users = List.empty(growable: true);

    for (var e in rawUsers) {
      User user = User.fromSkeletonJson(e);

      users.add(user);
    }

    return Circle(
      id: json["id"] as String,
      lastInteractedDate: (json["last_interacted_date"] == null)
          ? null
          : DateFormat("yyyy-MM-dd HH:mm:ss")
              .parse(json["last_interacted_date"], true)
              .toLocal(),
      name: json["circle_name"] as String,
      image: json["image"] as String,
      admin: User.fromSkeletonJsonAdmin(json["admin"]),
      users: users,
      postCount:
          json["post_count"] == null ? null : int.parse(json["post_count"]),
      status: json["publicity"],
    );
  }
}

/*
export default class Circle {
    id?: string;
    created_at?: string;
    last_interacted_date?: string;
    circle_name?: string;
    image?: string;
    created_by?: string;
    admin?: string;
}
*/