import 'dart:convert';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:http/http.dart' as http;

import 'package:circlesapp/services/user_service.dart';

class GoalService {
  String link = "http://localhost:3000/api/v1/";

  static Future<List<Goal>> goals = Future.value(
    List.empty(growable: true),
  );

  Future<void> fetchGoals() async {
    final response = await http.get(
      Uri.parse('${link}user/${UserService.dataUser.id}/goals/'),
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
        '${link}user/${UserService.dataUser.id}/goals/',
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
  Future<http.Response> deleteGoal(String id) async {
    final http.Response response = await http.delete(
      Uri.parse(
        '${link}user/${UserService.dataUser.id}/goals/$id/',
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
        '${link}user/${UserService.dataUser.id}/goals/$goalID/tasks/${taskID.toString()}/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  Future<http.Response> updateTask(Task task) async {
    var body = json.encode(task.toJson());

    final http.Response response = await http.patch(
      Uri.parse(
        '${link}user/${UserService.dataUser.id}/goals/${task.owner}/tasks/${task.id}/',
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    await fetchGoals();

    return response;
  }
}
