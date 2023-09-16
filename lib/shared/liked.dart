import 'package:circlesapp/shared/enums.dart';

class Liked {
  String? id;
  String? commentID;
  String? postConnectionID;
  String? userFKey;
  LikedStatus? likeStatus;

  Liked({
    this.id,
    this.commentID,
    this.postConnectionID,
    this.userFKey,
    this.likeStatus,
  });

  factory Liked.fromJson(Map<String, dynamic> json) {
    return Liked(
      id: json["id"],
      commentID: json["comment_id"],
      postConnectionID: json["post_connection_id"],
      userFKey: json["user_fkey"],
      likeStatus: json["like_status"] == null
          ? null
          : json["like_status"] == "liked"
              ? LikedStatus.liked
              : LikedStatus.notLiked,
    );
  }
}
