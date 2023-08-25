import 'dart:convert';

import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:http/http.dart' as http;

class CircleService {
  String link = "http://localhost:3000/api/v1/";

  static Future<List<Circle>>? circles;

  Future<void> fetchCircles() async {
    final response = await http.post(
      Uri.parse(
        '${link}user/circles/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'user_fkey': UserService.dataUser.fKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];

      circles = Future.value(
        body
            .map(
              (dynamic item) => Circle.fromJson(item),
            )
            .toList(),
      );
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load circles');
    }
  }

  Future<List<CirclePost>> fetchCirclePosts(String circleID) async {
    final response = await http.get(
      Uri.parse(
        '${link}circles/$circleID/posts/',
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];

      return body
          .map(
            (dynamic item) => CirclePost.fromJson(item),
          )
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load posts');
    }
  }
}
