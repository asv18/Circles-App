import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';

class GoalListToggle extends StatefulWidget {
  const GoalListToggle({
    super.key,
    required this.goal,
    required this.toggled,
    required this.index,
  });

  final Goal goal;
  final List<bool> toggled;
  final int index;

  @override
  State<GoalListToggle> createState() => _GoalListToggleState();
}

class _GoalListToggleState extends State<GoalListToggle> {
  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).primaryColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90),
        side: BorderSide(
          color:
              widget.toggled[widget.index] ? Colors.black : Colors.transparent,
          width: ComponentService.convertWidth(
            MediaQuery.of(context).size.width,
            1,
          ),
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.toggled[widget.index] = !widget.toggled[widget.index];
          });
        },
        child: Container(
          height: ComponentService.convertHeight(
            MediaQuery.of(context).size.height,
            40,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              12,
            ),
          ),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.goal.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Icon(
                Icons.check,
                size: 18,
                color: widget.toggled[widget.index]
                    ? Colors.black
                    : Colors.transparent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
