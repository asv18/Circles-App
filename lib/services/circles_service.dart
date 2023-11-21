import 'dart:convert';

import 'package:circlesapp/services/link.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:circlesapp/shared/circlepostscomments.dart';
import 'package:circlesapp/shared/enums.dart';
import 'package:circlesapp/shared/liked.dart';
import 'package:http/http.dart' as http;

class CircleService {
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
          'user_id': UserService.dataUser.id,
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

  Future<Circle> fetchCircle(String circleID) async {
    final response = await http.post(
      Uri.parse(
        '${link}circles/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'user_id': UserService.dataUser.id,
          'circle_id': circleID,
        },
      ),
    );

    if (response.statusCode == 200) {
      return Circle.fromJson(
        jsonDecode(response.body)["data"],
      );
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load circles');
    }
  }

  Future<List<CirclePost>> fetchCirclePosts(String circleID, int offset) async {
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
          'offset': offset,
          'user_id': UserService.dataUser.id,
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
            'user_id': UserService.dataUser.id,
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
            'user_id': UserService.dataUser.id,
            'like_status':
                liked.likeStatus == LikedStatus.liked ? "liked" : "not liked",
          },
        ),
      );
    }
  }

  Future<List<PostComment>> fetchComments(
    String postConnectionID,
    int offset,
  ) async {
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
          'user_id': UserService.dataUser.id,
          'offset': offset,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];

      List<PostComment> comments = body
          .map(
            (dynamic item) => PostComment.fromJson(item),
          )
          .toList();

      return comments;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load posts');
    }
  }

  Future<List<PostComment>> fetchChildComments(
    String postConnectionID,
    String parentID,
    int offset,
  ) async {
    final response = await http.post(
      Uri.parse(
        '${link}circles/posts/comments/children/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'post_connection_id': postConnectionID,
          'comment_id': parentID,
          'user_fkey': UserService.dataUser.fKey,
          'user_id': UserService.dataUser.id,
          'offset': offset,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];

      List<PostComment> comments = body
          .map(
            (dynamic item) => PostComment.fromJson(item),
          )
          .toList();

      return comments;
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
            'user_id': UserService.dataUser.id,
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
            'user_id': UserService.dataUser.id,
            'like_status':
                liked.likeStatus == LikedStatus.liked ? "liked" : "not liked",
          },
        ),
      );
    }
  }

  Future<PostComment> postComment(
    String posterFKey,
    String contents,
    String postID,
    String? replyID,
  ) async {
    final response = await http.post(
      Uri.parse(
        '${link}circles/posts/comments/new/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'poster_fkey': posterFKey,
          'contents': contents,
          'post_id': postID,
          'parent_id': replyID,
          'user_id': UserService.dataUser.id,
        },
      ),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body)["data"];

      return PostComment.fromJson(body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load posts');
    }
  }

  Future<List<Circle>> queryCircles(String query, int offset) async {
    final response = await http.post(
      Uri.parse(
        '${link}circles/query/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'query': query,
          'offset': offset,
          'user_fkey': UserService.dataUser.fKey,
          'user_id': UserService.dataUser.id,
        },
      ),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body)["data"];

      return body
          .map(
            (dynamic item) => Circle.fromJson(item),
          )
          .toList();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load circles');
    }
  }

  Future<http.Response> connectUserToCircle(String circleID) async {
    return await http.post(
      Uri.parse(
        '${link}users/circles/connect/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'circle_id': circleID,
          'user_fkey': UserService.dataUser.fKey,
          'user_id': UserService.dataUser.id,
        },
      ),
    );
  }

  Future<http.Response> connectForeignUserToCircle(
    String userID,
    String circleID,
  ) async {
    return await http.post(
      Uri.parse(
        '${link}users/circles/connect/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'circle_id': circleID,
          'user_fkey': userID,
          'user_id': UserService.dataUser.id,
        },
      ),
    );
  }

  Future<http.Response> createCircle(Circle circle) async {
    return await http.post(
      Uri.parse(
        '${link}circles/new/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'circle_name': circle.name,
          'image': circle.image ?? 'https://picsum.photos/570/300',
          'user_creator': UserService.dataUser.fKey,
          'user_id': UserService.dataUser.id,
          'publicity': circle.status,
        },
      ),
    );
  }

  Future<http.Response> createPost(CirclePost post, String circleID) async {
    return await http.post(
      Uri.parse(
        '${link}user/posts/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'title': post.title,
          'description': post.description,
          'image': post.image,
          'user_fkey': UserService.dataUser.fKey,
          'user_id': UserService.dataUser.id,
          'goal_id': post.goalID,
          'circle_ids': [
            circleID,
          ],
        },
      ),
    );
  }

  Future<http.Response> leaveCircle(Circle circle) async {
    return await http.delete(
      Uri.parse(
        '${link}users/circles/disconnect/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'user_id': UserService.dataUser.id,
          'user_fkey': UserService.dataUser.fKey,
          'circle_id': circle.id,
        },
      ),
    );
  }

  Future<http.Response> deleteCircle(Circle circle) async {
    return await http.delete(
      Uri.parse(
        '${link}circles/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'user_id': UserService.dataUser.id,
          'user_fkey': UserService.dataUser.fKey,
          'circle_id': circle.id,
        },
      ),
    );
  }
}
