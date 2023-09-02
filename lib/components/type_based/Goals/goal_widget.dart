import 'package:circlesapp/variable_screens/goalscreen.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GoalWidget extends StatelessWidget {
  const GoalWidget({
    Key? key,
    required this.goal,
    required this.showActionsGoalMenu,
    required this.getTapPosition,
  }) : super(key: key);

  final Goal goal;
  final Function showActionsGoalMenu;
  final Function getTapPosition;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (details) => getTapPosition(details),
      onLongPress: () => showActionsGoalMenu(
        context,
        goal,
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GoalScreen(
              goal: goal,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        height: 130.0,
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: Theme.of(context).primaryColorLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 12.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserService.truncateWithEllipsis(
                            30,
                            goal.name,
                          ),
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Bootstrap.clock,
                              color: Colors.red,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              // "Time Left: ${timeLeft(goals[index].endDate)}",
                              "${formatDate(goal.startDate!)} - ${formatDate(goal.endDate)}",
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    CircularPercentIndicator(
                      radius: 25,
                      percent: goal.progress! / 100.0,
                      center: Text(
                        "${goal.progress}%",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      progressColor: Theme.of(context).indicatorColor,
                      backgroundColor: Colors.white,
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 125),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time Left",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            timeLeft(
                              goal.endDate,
                            ),
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Tasks",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            "${goal.tasks!.length.toString().padLeft(2, '0')} Tasks",
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String timeLeft(DateTime date) {
  int years = (date.difference(DateTime.now()).inHours / 8760).round();
  int months = (date.difference(DateTime.now()).inHours / 730).round();
  int days = (date.difference(DateTime.now()).inHours / 24).round();
  int hours = (date.difference(DateTime.now()).inHours).round();

  if (years != 0) {
    if (years > 1) {
      return "${years.toString().padLeft(2, '0')} years";
    } else {
      return "${years.toString().padLeft(2, '0')} year";
    }
  } else if (months != 0) {
    if (months > 1) {
      return "${months.toString().padLeft(2, '0')} months";
    } else {
      return "${months.toString().padLeft(2, '0')} month";
    }
  } else if (days != 0) {
    if (days > 1) {
      return "${days.toString().padLeft(2, '0')} days";
    } else {
      return "${days.toString().padLeft(2, '0')} day";
    }
  } else {
    if (hours > 1) {
      return "${hours.toString().padLeft(2, '0')} hours";
    } else {
      return "<${hours.toString().padLeft(2, '0')} hour";
    }
  }
}

String formatDate(DateTime date) {
  var formatter = DateFormat('d MMM yyyy');

  return formatter.format(date);
}
