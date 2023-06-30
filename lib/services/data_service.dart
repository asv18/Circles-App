import 'dart:convert';
import 'dart:math';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class DataService {
  static User dataUser = User.empty();

  static Future<List<Goal>> goals = Future.value(
    List.empty(growable: true),
  );

  String link = "http://localhost:3000/api/v1/";

  //fetching
  Future<void> fetchGoals() async {
    final response = await http.get(
      Uri.parse('${link}user/${dataUser.id}/goals'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> body = jsonDecode(response.body)["data"];

      goals = Future.value(
        body
            .map(
              (dynamic item) => Goal.fromJson(item),
            )
            .toList(),
      );
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load goals');
    }
  }

  Future<void> fetchUser() async {
    final response = await http.get(
      Uri.parse('${link}user/${dataUser.id}'),
    );

    if (response.statusCode == 200) {
      dataUser = User.fromJson(
        jsonDecode(response.body),
      );

      const secureStorage = FlutterSecureStorage();

      dynamic userIDKey = await secureStorage.read(
        key: "idKey",
      );

      if (userIDKey == null) {
        String newKey = generateRandomString(64);

        await secureStorage.write(
          key: "idKey",
          value: newKey,
        );
      }

      userIDKey = await secureStorage.read(
        key: "idKey",
      );

      final openedBox = Hive.box("userBox");

      await openedBox.putAll(
        {
          userIDKey: dataUser.id,
          "first_name": dataUser.firstName,
          "last_name": dataUser.lastName,
          "username": dataUser.username,
          "photo_url": dataUser.photoUrl ?? "null",
          "email": dataUser.email,
        },
      );
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> fetchUserFromAuth(String? authID) async {
    final response = await http.get(
      Uri.parse('${link}user/authenticate/$authID'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      dataUser.id = jsonDecode(response.body)["data"]["id"];

      if (dataUser.id != null) {
        return fetchUser();
      }

      return createNewUser(DataService.dataUser);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Future<List<User>> fetchUserSkeletons() async {
    final response = await http.get(
      Uri.parse('${link}user/'),
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

  Future<http.Response> createGoal(Goal newGoal) {
    String body = "";
    if (newGoal.tasks != null) {
      var tasks = newGoal.tasks!.map((e) {
        return e.toJsonNew();
      }).toList();

      body = json.encode(tasks);
    }

    return http.post(
      Uri.parse(
        '${link}user/${dataUser.id}/goals/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'name': newGoal.name,
          'finish_date': newGoal.endDate.toIso8601String(),
          'description': newGoal.description,
          'tasks': body,
        },
      ),
    );
  }

  void createNewUser(User newUser) async {
    await createUser(newUser);

    fetchUserFromAuth(AuthService().user!.uid);
  }

  Future<http.Response> createUser(User newUser) {
    dataUser = newUser;
    return http.post(
      Uri.parse(
        '${link}user',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "first_name": newUser.firstName,
          "last_name": newUser.lastName,
          "username": newUser.username,
          "email": newUser.email,
          "photo_url": newUser.photoUrl,
          "authID": AuthService().user!.uid,
        },
      ),
    );
  }

  //delete
  Future<http.Response> deleteGoal(String id) async {
    final http.Response response = await http.delete(
      Uri.parse(
        '${link}user/${dataUser.id}/goals/$id',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  Future<http.Response> deleteTask(String goalID, BigInt taskID) async {
    final http.Response response = await http.delete(
      Uri.parse(
        '${link}user/${dataUser.id}/goals/$goalID/tasks/${taskID.toString()}',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  String generateRandomString(int length) {
    final random = Random();
    const availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();

    return randomString;
  }

  //update tasks
  // static Future<http.Response> updateTasks(List<Task> tasks, Goal owner) async {
  //   var body = json.encode({
  //     "tasks": tasks.map((e) => e.toJson()).toList(),
  //   });

  //   final http.Response response = await http.patch(
  //     Uri.parse(
  //       '${link}user/${user.id}/goals/${owner.id}/tasks/',
  //     ),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: body,
  //   );

  //   return response;
  // }

  Future<http.Response> updateTask(Task task) async {
    var body = json.encode(task.toJson());

    final http.Response response = await http.patch(
      Uri.parse(
        '${link}user/${dataUser.id}/goals/${task.owner}/tasks/${task.id}',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    return response;
  }

  //other
  static String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }
}
