import 'package:circlesapp/shared/circle.dart';
import 'package:flutter/material.dart';

class CircleListToggle extends StatefulWidget {
  const CircleListToggle({
    super.key,
    required this.circle,
    required this.toggled,
    required this.index,
  });

  final Circle circle;
  final List<bool> toggled;
  final int index;

  @override
  State<CircleListToggle> createState() => _CircleListToggleState();
}

class _CircleListToggleState extends State<CircleListToggle> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90),
        side: BorderSide(
          color:
              widget.toggled[widget.index] ? Colors.black : Colors.transparent,
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.toggled[widget.index] = !widget.toggled[widget.index];
          });
        },
        child: Container(
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 12.0),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.circle.name!,
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
