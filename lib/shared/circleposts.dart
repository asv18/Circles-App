import 'package:intl/intl.dart';

class CirclePost {
  String? id;
  String? posterFKey;
  String? title;
  String? image;
  String? description;
  String? goalID;
  String? taskID;
  int? likes;
  DateTime? postedAt;

  CirclePost({
    this.id,
    this.posterFKey,
    this.title,
    this.image,
    this.description,
    this.goalID,
    this.taskID,
    this.likes,
    this.postedAt,
  });

  factory CirclePost.fromJson(Map<String, dynamic> json) {
    return CirclePost(
      id: json["id"],
      posterFKey: json["poster_fkey"],
      title: json["title"],
      image: json["image"],
      description: json["description"],
      goalID: json["goal_id"],
      taskID: json["task_id"],
      likes: int.parse(json["likes"]),
      postedAt: DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(json["posted_at"], true)
          .toLocal(),
    );
  }
}
