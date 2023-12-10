import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
          width: ComponentService.convertWidth(
            MediaQuery.of(context).size.width,
            45,
          ),
          height: ComponentService.convertWidth(
            MediaQuery.of(context).size.width,
            45,
          ),
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
                    if (DateTime.now().compareTo(v.endDate) != 1) {
                      tasksLength += v.tasks!.length;
                    }
                  }

                  return Text(
                    tasksLength > 99
                        ? "99+"
                        : tasksLength.toString().padLeft(2, '0'),
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  );
                } else {
                  return Text(
                    snapshot.data!.length > 20
                        ? "20+"
                        : snapshot.data!.length.toString().padLeft(2, '0'),
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      color: Colors.black,
                    ),
                  );
                }
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        SizedBox(
          height: ComponentService.convertHeight(
            MediaQuery.of(context).size.height,
            3,
          ),
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
