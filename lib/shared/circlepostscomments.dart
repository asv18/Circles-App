import 'package:circlesapp/shared/liked.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:intl/intl.dart';

class PostComment {
  BigInt? id;
  User? poster;
  String? contents;
  DateTime? datePosted;
  BigInt? postId;
  BigInt? parentId;
  int? likes;
  Liked? liked;
  List<PostComment>? children;

  PostComment({
    this.id,
    this.poster,
    this.contents,
    this.datePosted,
    this.postId,
    this.parentId,
    this.likes,
    this.liked,
    this.children,
  });

  factory PostComment.fromJson(Map<String, dynamic> json) {
    List<PostComment> comments = [];
    for (var v in json["children"] ?? []) {
      comments.add(PostComment.fromJson(v));
    }

    return PostComment(
      id: BigInt.parse(json["id"]),
      poster: User.fromSkeletonJson(json["poster"]),
      contents: json["contents"],
      datePosted: DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(json["time_posted"], true)
          .toLocal(),
      postId: BigInt.parse(json["post_id"]),
      parentId:
          json["parent_id"] == null ? null : BigInt.parse(json["parent_id"]),
      likes: int.parse(json["likes"]),
      liked: Liked.fromJson(json["liked"]),
      children: comments,
    );
  }
}
