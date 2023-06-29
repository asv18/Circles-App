import 'package:circlesapp/components/circle_widget.dart';
import 'package:circlesapp/components/create_button.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:flutter/material.dart';

class CirclesDisp extends StatefulWidget {
  const CirclesDisp({super.key});

  @override
  State<CirclesDisp> createState() => _CirclesDispState();
}

class _CirclesDispState extends State<CirclesDisp> {
  final List<Circle> _circles = [
    Circle(
        name: "circle 1",
        updates: 3,
        userCount: 5,
        image: "https://picsum.photos/400/400?random=1"),
    Circle(
        name: "circle 2",
        updates: 8,
        userCount: 8,
        image: "https://picsum.photos/400/400?random=2"),
    Circle(
        name: "circle 3",
        updates: 10,
        userCount: 3,
        image: "https://picsum.photos/400/400?random=3"),
    Circle(
        name: "circle 4",
        updates: 7,
        userCount: 2,
        image: "https://picsum.photos/400/400?random=4"),
    Circle(
        name: "circle 5",
        updates: 2,
        userCount: 6,
        image: "https://picsum.photos/400/400?random=5"),
    Circle(
        name: "circle 6",
        updates: 6,
        userCount: 10,
        image: "https://picsum.photos/400/400?random=6"),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Column(
        children: [
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CreateButton(
                  onPressed: () {},
                  text: "Join",
                ),
                CreateButton(
                  onPressed: () {},
                  text: "Create",
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _circles.length,
              itemBuilder: (BuildContext context, int index) {
                return CircleWidget(
                  circle: _circles[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
