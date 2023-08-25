import 'package:circlesapp/variable_screens/goalscreen.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalWidget extends StatelessWidget {
  const GoalWidget({
    Key? key,
    required this.goals,
    required this.index,
    required this.showActionsGoalMenu,
    required this.getTapPosition,
  }) : super(key: key);

  final List<Goal> goals;
  final int index;
  final Function showActionsGoalMenu;
  final Function getTapPosition;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (details) => getTapPosition(details),
      onLongPress: () => showActionsGoalMenu(
        context,
        goals[index],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GoalScreen(
              goal: goals[index],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        height: 175.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).primaryColorDark,
        ),
        child: Container(
          margin: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    UserService.truncateWithEllipsis(8, goals[index].name),
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (i) {
                        if (i < goals[index].progress!.toInt()) {
                          return Container(
                            margin: const EdgeInsets.only(right: 5.0),
                            child: Icon(
                              Icons.circle,
                              color: Colors.green[500],
                            ),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.only(right: 5.0),
                            child: Icon(
                              Icons.circle_outlined,
                              color: Colors.green[500],
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Time Left: ${timeLeft(goals[index].endDate)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                UserService.truncateWithEllipsis(
                  20,
                  (goals[index].description != "null")
                      ? goals[index].description!
                      : "",
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
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
      return "$years years";
    } else {
      return "$years year";
    }
  } else if (months != 0) {
    if (months > 1) {
      return "$months months";
    } else {
      return "$months month";
    }
  } else if (days != 0) {
    if (days > 1) {
      return "$days days";
    } else {
      return "$days day";
    }
  } else {
    if (hours > 1) {
      return "$hours hours";
    } else {
      return "$hours hour";
    }
  }
}
