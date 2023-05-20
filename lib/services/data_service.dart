import 'dart:convert';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:http/http.dart' as http;

class DataService {
  static String? userID;
  static String link = "http://localhost:3000/api/v1/";

  //fetching
  static Future<List<Goal>> fetchGoals() async {
    final response = await http.get(
      Uri.parse('${link}user/$userID/goals'),
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

  static Future<User> fetchUser() async {
    final response = await http.get(
      Uri.parse('${link}user/$userID'),
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
      Uri.parse('${link}user/authenticate/$authID'),
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
    String body = "";
    if (newGoal.tasks != null) {
      var tasks = newGoal.tasks!.map((e) {
        return e.toJsonNew();
      }).toList();

      body = json.encode(tasks);
    }

    return http.post(
      Uri.parse(
        '${link}user/$userID/goals/',
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

  //delete
  static Future<http.Response> deleteGoal(String id) async {
    final http.Response response = await http.delete(
      Uri.parse(
        '${link}user/$userID/goals/$id',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  static Future<http.Response> deleteTask(String goalID, BigInt taskID) async {
    final http.Response response = await http.delete(
      Uri.parse(
        '${link}user/$userID/goals/$goalID/tasks/${taskID.toString()}',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  //update tasks
  // static Future<http.Response> updateTasks(List<Task> tasks, Goal owner) async {
  //   var body = json.encode({
  //     "tasks": tasks.map((e) => e.toJson()).toList(),
  //   });

  //   final http.Response response = await http.patch(
  //     Uri.parse(
  //       '${link}user/$userID/goals/${owner.id}/tasks/',
  //     ),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: body,
  //   );

  //   return response;
  // }

  static Future<http.Response> updateTask(Task task) async {
    var body = json.encode(task.toJson());

    final http.Response response = await http.patch(
      Uri.parse(
        '${link}user/$userID/goals/${task.owner}/tasks/${task.id}',
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
