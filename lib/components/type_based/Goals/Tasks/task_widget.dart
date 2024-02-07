import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.task,
    required this.onChanged,
    required this.showActionsTaskMenu,
    required this.getTapPosition,
  });

  final Task task;
  final Function onChanged;

  final Function showActionsTaskMenu;
  final Function getTapPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ComponentService.convertWidth(
        MediaQuery.of(context).size.width,
        330,
      ),
      margin: EdgeInsets.only(
        right: ComponentService.convertWidth(
          MediaQuery.of(context).size.width,
          2.5,
        ),
        top: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          10,
        ),
        bottom: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          10,
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Theme.of(context).primaryColorLight,
        child: InkWell(
          onTapDown: (details) => getTapPosition(
            details,
          ),
          onLongPress: () => showActionsTaskMenu(
            context,
            task,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.all(
                    ComponentService.convertWidth(
                      MediaQuery.of(context).size.width,
                      10,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        textAlign: TextAlign.start,
                        task.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Text(
                        (task.repeat == "Never")
                            ? "Not Recurring"
                            : task.repeat,
                        style: Theme.of(context).textTheme.displaySmall,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  height: double.infinity,
                  color: (task.complete!)
                      ? Theme.of(context).indicatorColor
                      : (task.repeat != "Never")
                          ? (task.nextDate!.compareTo(
                                    DateTime.now(),
                                  ) <
                                  0)
                              ? Colors.red[400]
                              : Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColorDark,
                  padding: EdgeInsets.symmetric(
                    vertical: ComponentService.convertWidth(
                      MediaQuery.of(context).size.width,
                      10,
                    ),
                    horizontal: ComponentService.convertWidth(
                      MediaQuery.of(context).size.width,
                      7.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Complete",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                      SizedBox(
                        height: ComponentService.convertWidth(
                          MediaQuery.of(context).size.width,
                          24,
                        ),
                        width: ComponentService.convertWidth(
                          MediaQuery.of(context).size.width,
                          24,
                        ),
                        child: Checkbox(
                          checkColor: Theme.of(context).indicatorColor,
                          fillColor: MaterialStateProperty.resolveWith(
                            (states) => Theme.of(context).canvasColor,
                          ),
                          value: task.complete,
                          side: BorderSide.none,
                          onChanged: (value) => onChanged(value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
