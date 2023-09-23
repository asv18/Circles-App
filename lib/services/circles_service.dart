import 'dart:convert';

import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:circlesapp/shared/circlepostscomments.dart';
import 'package:circlesapp/shared/enums.dart';
import 'package:circlesapp/shared/liked.dart';
import 'package:http/http.dart' as http;

class CircleService {
  String link = "http://localhost:3000/api/v1/";

  static Future<List<Circle>> circles = Future.value(
    List.empty(growable: true),
  );

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
    final response = await http.post(
      Uri.parse(
        '${link}circles/posts/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'circle_id': circleID,
          'user_fkey': UserService.dataUser.fKey,
        },
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

  Future<http.Response> handlePostLikeButton(
    String connectionID,
    Liked liked,
  ) async {
    if (liked.id == null) {
      return await http.post(
        Uri.parse(
          '${link}circles/posts/likepost/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'connection_id': connectionID,
            'user_fkey': UserService.dataUser.fKey,
          },
        ),
      );
    } else {
      return await http.post(
        Uri.parse(
          '${link}circles/posts/likepost/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'connection_id': connectionID,
            'like_id': liked.id,
            'user_fkey': UserService.dataUser.fKey,
            'like_status':
                liked.likeStatus == LikedStatus.liked ? "liked" : "not liked",
          },
        ),
      );
    }
  }

  Future<List<PostComment>> fetchComments(String postConnectionID) async {
    final response = await http.post(
      Uri.parse(
        '${link}circles/posts/comments/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'post_connection_id': postConnectionID,
          'user_fkey': UserService.dataUser.fKey,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];

      return body
          .map(
            (dynamic item) => PostComment.fromJson(item),
          )
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load posts');
    }
  }

  Future<http.Response> handleCommentLikeButton(
    String commentID,
    Liked liked,
  ) async {
    if (liked.id == null) {
      return await http.post(
        Uri.parse(
          '${link}circles/posts/comments/likecomment/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'comment_id': commentID,
            'user_fkey': UserService.dataUser.fKey,
          },
        ),
      );
    } else {
      return await http.post(
        Uri.parse(
          '${link}circles/posts/comments/likecomment/',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, dynamic>{
            'comment_id': commentID,
            'like_id': liked.id,
            'user_fkey': UserService.dataUser.fKey,
            'like_status':
                liked.likeStatus == LikedStatus.liked ? "liked" : "not liked",
          },
        ),
      );
    }
  }
}
