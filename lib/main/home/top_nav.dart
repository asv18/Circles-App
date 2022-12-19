import 'package:circlesapp/main/circles/circlesdisplay.dart';
import 'package:circlesapp/main/goals/goalsdisplay.dart';
import 'package:flutter/material.dart';

class TopNav extends StatefulWidget {
  const TopNav({super.key});

  @override
  State<TopNav> createState() => _TopNavState();
}

class _TopNavState extends State<TopNav> {
  @override
  final _pages = [CirclesDisp(), GoalsDisp()];

  int? _index;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _index = 0;
                });
              },
              child: const Text(
                "Circles",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          const VerticalDivider(
            thickness: 1.0,
            indent: 5.0,
            endIndent: 5.0,
            color: Colors.black,
          ),
          Expanded(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _index = 1;
                });
              },
              child: const Text(
                "Goals",
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
