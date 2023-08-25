import 'package:intl/intl.dart';

class Message {
  BigInt? id;
  String? message;
  String? userFKey;
  BigInt? replyID;
  BigInt? friendshipID;
  DateTime? dateSent;

  Message({
    this.message,
    this.userFKey,
    this.id,
    this.friendshipID,
    this.dateSent,
    this.replyID,
  });

  /*
  
    "id": message.id.toString(),
    "contents": message.contents,
    "friendship_id": message.friendship_id.toString(),
    "date_sent": message.date_sent,
    "reply_fkey": message.reply_fkey,
    "user_fkey": message.user_fkey,
  
  */

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: BigInt.parse(json["id"]),
      message: json["contents"],
      friendshipID: BigInt.parse(json["friendship_id"]),
      dateSent: DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(json["date_sent"], true)
          .toLocal(),
      replyID: json["reply_id"] == "null" || json["reply_id"] == null
          ? null
          : BigInt.parse(
              json["reply_id"],
            ),
      userFKey: json["user_fkey"],
    );
  }
}
