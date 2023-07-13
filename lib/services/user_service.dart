import 'dart:convert';
import 'dart:math';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'auth_service.dart';

class UserService {
  static User dataUser = User();

  String link = "http://localhost:3000/api/v1/";

  //fetching

  Future<void> fetchUser() async {
    final response = await http.get(
      Uri.parse('${link}user/${dataUser.id}/'),
    );

    if (response.statusCode == 200) {
      dataUser = User.fromJson(
        jsonDecode(response.body)["data"],
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
          "f_key": dataUser.fKey,
          "phone_number": dataUser.phoneNumber,
        },
      );

      await GoalService().fetchGoals();

      UserService.dataUser.exists = true;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> fetchUserFromAuth(String? authID) async {
    final response = await http.get(
      Uri.parse('${link}user/authenticate/$authID/'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      dataUser.id = jsonDecode(response.body)["data"]["id"];

      if (dataUser.id != null) {
        return fetchUser();
      }

      return await createNewUser(UserService.dataUser);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  Future<void> createNewUser(User newUser) async {
    const uuid = Uuid();
    newUser.username = uuid.v4();
    newUser.exists = false;

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

  //other
  static String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }
}
