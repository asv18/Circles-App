import 'dart:convert';
import 'package:circlesapp/services/link.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:http/http.dart' as http;

import 'package:circlesapp/services/user_service.dart';

class GoalService {
  static Future<List<Goal>> goals = Future.value(
    List.empty(growable: true),
  );

  Future<void> fetchGoals() async {
    final response = await http.post(
      Uri.parse('${link}user/goals/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "id": UserService.dataUser.id,
        },
      ),
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
        '${link}user/goals/new/',
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
          'user_id': UserService.dataUser.id,
        },
      ),
    );
  }

  //delete
  Future<http.Response> deleteGoal(String id) async {
    final http.Response response = await http.delete(
      Uri.parse(
        '${link}user/goals/$id/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'user_id': UserService.dataUser.id,
        },
      ),
    );

    return response;
  }

  Future<http.Response> deleteTask(String goalID, BigInt taskID) async {
    final http.Response response = await http.delete(
      Uri.parse(
        '${link}user/goals/$goalID/tasks/${taskID.toString()}/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          'user_id': UserService.dataUser.id,
        },
      ),
    );

    return response;
  }

  Future<http.Response> updateTask(Task task) async {
    var body = task.toJson();

    body['user_id'] = UserService.dataUser.id;

    final http.Response response = await http.patch(
      Uri.parse(
        '${link}user/goals/${task.owner}/tasks/${task.id}/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        body,
      ),
    );

    await fetchGoals();

    return response;
  }
}
