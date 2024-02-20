import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/pages/edit_goal_screen.dart/edit_goal_screen.dart';
import 'package:flutter/material.dart';

class ComponentService {
  /**
   * proMaxWidth = 430.0
   * proMaxHeight = 932.0
   */

  //desired sizes based on iPhone 14 Pro Max size

  //TODO: ADD NAVIGATE/REFRESH AND SHOW ACTIONS MENUS TO COMPONENT SERVICE

  static double convertWidth(double mdWidth, double desiredWidth) {
    double conversion = 430.0 / desiredWidth;

    return mdWidth / conversion;
  }

  static double convertHeight(double mdHeight, double desiredHeight) {
    double conversion = 932.0 / desiredHeight;

    return mdHeight / conversion;
  }

  static Future<void> navigateAndRefreshCreateCircles(
    BuildContext context,
    Function? callback,
  ) async {
    final response = (await mainKeyNav.currentState!.pushNamed(
      '/createorjoincircle',
    )) as List;

    if (!mainKeyNav.currentState!.mounted) return;

    if (response[0] == "Circle Created" || response[0] == "Circle Joined") {
      await CircleService().fetchCircles();

      if (callback != null) {
        callback();
      }
    }
  }

  static Future<void> showActionsCircleMenu(
    BuildContext context,
    Circle circle,
    Offset tapPosition,
  ) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 100, 100),
        Rect.fromLTWH(
          0,
          0,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      items: [
        PopupMenuItem(
          value: (circle.admin!.fKey == UserService.dataUser.fKey)
              ? "Delete Circle"
              : "Leave Circle",
          child: Text(
            (circle.admin!.fKey == UserService.dataUser.fKey)
                ? "Delete Circle"
                : "Leave Circle",
          ),
        ),
        // if (circle.admin!.fKey == UserService.dataUser.fKey)
        //   const PopupMenuItem(
        //     value: "Edit Circle",
        //     child: Text("Edit Circle"),
        //   ),
      ],
    );

    if (result == "Leave Circle") {
      await CircleService().leaveCircle(circle);
      await CircleService().fetchCircles();
    } else if (result == "Delete Circle") {
      await CircleService().deleteCircle(circle);
      await CircleService().fetchCircles();
    } else if (result == "Edit Circle") {
      //TODO: implement edit circle screen
    }
  }

  static Future<void> navigateAndRefreshCreateGoal(
    BuildContext context,
    Function? callback,
  ) async {
    final response = (await mainKeyNav.currentState!.pushNamed(
      '/creategoal',
    )) as List;

    if (!mainKeyNav.currentState!.mounted) return;

    if (response[0] == "Goal Created") {
      await GoalService().fetchGoals();

      if (callback != null) {
        callback();
      }
    }
  }

  static Future<void> showActionsGoalMenu(
    BuildContext context,
    Goal goal,
    Offset tapPosition,
  ) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(tapPosition.dx, tapPosition.dy, 100, 100),
        Rect.fromLTWH(
          0,
          0,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      items: [
        PopupMenuItem(
          value: "Edit Goal",
          child: Text("Edit ${goal.name}"),
        ),
        PopupMenuItem(
          value: "Delete Goal",
          child: Text("Delete ${goal.name}"),
        ),
      ],
    );

    if (result == "Edit Goal") {
      if (mainKeyNav.currentState!.mounted) {
        final result = (await mainKeyNav.currentState!.push(
          MaterialPageRoute(
            builder: (context) => GoalScreen(
              goal: goal,
            ),
          ),
        )) as List;

        if (result[0] == "Updated Goal") {
          await GoalService().fetchGoals();
        }
      }
    } else if (result == "Delete Goal") {
      await GoalService().deleteGoal(goal.id!);
    }
  }
}
