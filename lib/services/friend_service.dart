import 'dart:convert';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/friendship.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:http/http.dart' as http;

class FriendService {
  String link = "http://localhost:3000/api/v1/";

  Future<List<Friendship>> fetchFriends() async {
    final response = await http.get(
      Uri.parse('${link}user/${UserService.dataUser.fKey!}/friendships/'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];

      return body
          .map(
            (dynamic item) => Friendship.fromJson(item),
          )
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load users');
    }
  }

  Future<List<User>> fetchFriendSkeletons() async {
    final response = await http.get(
      Uri.parse('${link}user/friendships/${UserService.dataUser.fKey}/'),
    );

    print(response.body);

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
}
