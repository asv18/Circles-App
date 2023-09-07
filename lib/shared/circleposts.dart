import 'package:circlesapp/shared/user.dart';
import 'package:intl/intl.dart';

class CirclePost {
  String? id;
  User? poster;
  String? title;
  String? image;
  String? description;
  String? goalID;
  String? taskID;
  int? likes;
  DateTime? postedAt;
  List<int> comments = [];
  BigInt? connectionID;

  CirclePost({
    this.id,
    this.poster,
    this.title,
    this.image,
    this.description,
    this.goalID,
    this.taskID,
    this.likes,
    this.postedAt,
    this.connectionID,
  });

  factory CirclePost.fromJson(Map<String, dynamic> json) {
    return CirclePost(
      id: json["id"],
      poster: User.fromSkeletonJson(json["poster"]),
      title: json["title"],
      image: json["image"],
      description: json["description"],
      goalID: json["goal_id"],
      taskID: json["task_id"],
      likes: int.parse(json["likes"]),
      postedAt: DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(json["posted_at"], true)
          .toLocal(),
      connectionID: BigInt.parse(json["connection_id"]),
    );
  }
}
