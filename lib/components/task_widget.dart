import 'package:auto_size_text/auto_size_text.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late Task task;
  @override
  void initState() {
    super.initState();

    task = widget.task;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170.0,
      child: Container(
        width: 225.0,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: (task.complete!)
              ? Colors.green[400]
              : (task.repeat != "Never")
                  ? (task.nextDate!.compareTo(
                            DateTime.now(),
                          ) <
                          0)
                      ? Colors.red[400]
                      : Theme.of(context).primaryColor
                  : Theme.of(context).primaryColor,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(
                      bottom: 10.0,
                    ),
                    child: AutoSizeText(
                      maxLines: 1,
                      maxFontSize: 32,
                      minFontSize: 18,
                      wrapWords: false,
                      overflow: TextOverflow.visible,
                      softWrap: false,
                      textAlign: TextAlign.center,
                      task.name,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    (task.repeat == "Never") ? "Not Recurring" : task.repeat,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Transform.scale(
                scale: 1.5,
                child: Checkbox(
                  checkColor: Colors.green[400],
                  fillColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.white,
                  ),
                  value: task.complete,
                  onChanged: (bool? value) {
                    setState(() {
                      task.complete = value!;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
