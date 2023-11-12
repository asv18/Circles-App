import 'dart:convert';
import 'package:circlesapp/services/link.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/friendship.dart';
import 'package:circlesapp/shared/message.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:http/http.dart' as http;

class FriendService {
  Future<Friendship> fetchFriendship(String friendFKey) async {
    ///api/v1/user/:userKey1/friendships/:userKey2/
    final response = await http.post(
      Uri.parse(
        '${link}user/friendships/individual/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'user_fkey_1': UserService.dataUser.fKey,
          'user_fkey_2': friendFKey,
          'user_id': UserService.dataUser.id,
        },
      ),
    );

    if (response.statusCode == 200) {
      Friendship friendship = Friendship.fromJson(
        jsonDecode(response.body)["data"],
      );

      return friendship;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load friendship');
    }
  }

  Future<List<User>> fetchFriendSkeletons() async {
    final response = await http.post(
      Uri.parse('${link}user/friendships/skeletons/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'user_fkey': UserService.dataUser.fKey,
          'user_id': UserService.dataUser.id,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];

      return body
          .map(
            (dynamic item) => User.fromSkeletonJson(item),
          )
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load users');
    }
  }

  Future<List<Message>> fetchMessages(
    BigInt friendshipID,
    BigInt offset,
  ) async {
    final response = await http.post(
      Uri.parse(
        '${link}messages/$offset/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'friendship_id': friendshipID.toString(),
          'user_id': UserService.dataUser.id,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];

      return body
          .map(
            (dynamic item) => Message.fromJson(item),
          )
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load users');
    }
  }

  Future<http.Response> createMessage(Map<String, dynamic> message) {
    return http.post(
      Uri.parse(
        '${link}messages/${message["friendship_id"]}/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'contents': message["contents"],
          'friendship_id': message["friendship_id"],
          'user_fkey': message["user_fkey"],
          'user_id': UserService.dataUser.id,
          'reply_fkey': message["reply_fkey"],
        },
      ),
    );
  }
}
