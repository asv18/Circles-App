import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GoalsListWidget extends StatelessWidget {
  const GoalsListWidget({
    super.key,
    required this.goal,
  });

  final Goal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Theme.of(context).primaryColorDark,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            child: Text(
              UserService.truncateWithEllipsis(
                15,
                goal.name,
              ),
              style: GoogleFonts.montserrat(
                fontSize: 16.0,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            children: List.generate(
              5,
              (i) {
                if (i < goal.progress!.toInt()) {
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
    );
  }
}
