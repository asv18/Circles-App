import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class GoalsListWidget extends StatelessWidget {
  const GoalsListWidget({
    super.key,
    required this.goal,
    required this.showActionsGoalMenu,
    required this.getTapPosition,
  });

  final Goal goal;
  final Function showActionsGoalMenu;
  final Function getTapPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          10,
        ),
      ),
      height: ComponentService.convertWidth(
        MediaQuery.of(context).size.width,
        100,
      ),
      width: ComponentService.convertWidth(
        MediaQuery.of(context).size.width,
        330,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: goal.progress! > 100
            ? const Color.fromARGB(255, 240, 255, 242)
            : Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTapDown: (details) => getTapPosition(details),
          onLongPress: () => showActionsGoalMenu(
            context,
            goal,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ComponentService.convertWidth(
                MediaQuery.of(context).size.width,
                10,
              ),
              vertical: ComponentService.convertHeight(
                MediaQuery.of(context).size.height,
                12,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ComponentService.convertWidth(
                        MediaQuery.of(context).size.width,
                        200,
                      ),
                      child: Text(
                        goal.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    SizedBox(
                      height: ComponentService.convertHeight(
                        MediaQuery.of(context).size.height,
                        4,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Bootstrap.clock,
                          color: Colors.red,
                          size: 15,
                        ),
                        SizedBox(
                          width: ComponentService.convertWidth(
                            MediaQuery.of(context).size.width,
                            4,
                          ),
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
                  radius: ComponentService.convertWidth(
                    MediaQuery.of(context).size.width,
                    25,
                  ),
                  percent:
                      (goal.progress! / 100.0 > 1) ? 1 : goal.progress! / 100.0,
                  center: Text(
                    "${(goal.progress! / 100.0 > 1) ? 100 : goal.progress!}%",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  progressColor: Theme.of(context).indicatorColor,
                  backgroundColor: Colors.white,
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
