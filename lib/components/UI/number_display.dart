import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NumberDisplay extends StatelessWidget {
  final Future<dynamic> future;
  final String text;

  const NumberDisplay({
    super.key,
    required this.future,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColorLight,
          ),
          alignment: Alignment.center,
          child: FutureBuilder(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (text == "Tasks") {
                  int tasksLength = 0;
                  for (Goal v in snapshot.data!) {
                    tasksLength += v.tasks!.length;
                  }

                  return Text(
                    tasksLength > 20
                        ? "20+"
                        : tasksLength.toString().padLeft(2, '0'),
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                    ),
                  );
                } else {
                  return Text(
                    snapshot.data!.length > 20
                        ? "20+"
                        : snapshot.data!.length.toString().padLeft(2, '0'),
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                    ),
                  );
                }
              } else {
                return Container();
              }
            },
          ),
        ),
        const SizedBox(
          height: 3,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
