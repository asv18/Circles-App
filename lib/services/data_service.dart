import 'dart:convert';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:http/http.dart' as http;

class DataService {
  static String? userID;
  static Future<List<Goal>> fetchGoals() async {
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/v1/user/$userID/goals'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      List<dynamic> body = jsonDecode(response.body)["data"];

      List<Goal> goals = body
          .map(
            (dynamic item) => Goal.fromJson(item),
          )
          .toList();

      return goals;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load goals');
    }
  }

  static String truncateWithEllipsis(int cutoff, String myString) {
    return (myString.length <= cutoff)
        ? myString
        : '${myString.substring(0, cutoff)}...';
  }

  static Future<User> fetchUser() async {
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/v1/user/$userID'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return User.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  static Future<User> fetchUserFromAuth(String? authID) async {
    final response = await http.get(
      Uri.parse('http://localhost:8000/api/v1/user/authenticate/$authID'),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      userID = jsonDecode(response.body)["data"]["id"];
      return fetchUser();
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load user');
    }
  }

  static Future<http.Response> createGoal(Goal newGoal) {
    return http.post(
      Uri.parse(
        'http://localhost:8000/api/v1/user/$userID/goals/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': newGoal.name,
        'finish_date': newGoal.endDate.toIso8601String(),
        'description': newGoal.description,
      }),
    );
  }

  static Future<http.Response> deleteGoal(String id) async {
    final http.Response response = await http.delete(
      Uri.parse(
        'http://localhost:8000/api/v1/user/$userID/goals/$id',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }
}
