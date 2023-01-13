import 'package:circlesapp/main/home/circles/circlescreen.dart';
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
        image: "https://source.unsplash.com/random/400x400?sig=1"),
    Circle(
        name: "circle 2",
        updates: 8,
        userCount: 8,
        image: "https://source.unsplash.com/random/400x400?sig=2"),
    Circle(
        name: "circle 3",
        updates: 10,
        userCount: 3,
        image: "https://source.unsplash.com/random/400x400?sig=3"),
    Circle(
        name: "circle 4",
        updates: 7,
        userCount: 2,
        image: "https://source.unsplash.com/random/400x400?sig=4"),
    Circle(
        name: "circle 5",
        updates: 2,
        userCount: 6,
        image: "https://source.unsplash.com/random/400x400?sig=5"),
    Circle(
        name: "circle 6",
        updates: 6,
        userCount: 10,
        image: "https://source.unsplash.com/random/400x400?sig=6"),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              CreateButton(text: "Join"),
              CreateButton(text: "Create"),
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
    );
  }
}

class CreateButton extends StatelessWidget {
  const CreateButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[800],
        borderRadius: BorderRadius.circular(20.0),
      ),
      width: 100.0,
      height: 40.0,
      child: TextButton(
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: Colors.white,
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    Key? key,
    required this.circle,
  }) : super(key: key);

  final Circle circle;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: circle.image,
      child: Material(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 500),
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  return CircleScreen(
                    circle: circle,
                  );
                },
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(10.0),
            height: 175.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  circle.image,
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    circle.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(2.5, 2.5),
                          blurRadius: 10.0,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      "${circle.updates} new updates",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                            offset: const Offset(2.5, 2.5),
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 40.0,
                        width: 120.0,
                        child: Stack(
                          children: List.generate(
                            circle.userCount <= 3 ? circle.userCount : 3,
                            (index) {
                              return Positioned(
                                left: index * 30,
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://source.unsplash.com/random/200x200?sig=${index}',
                                      ),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Visibility(
                        visible: circle.userCount > 3,
                        child: Text(
                          "+${circle.userCount - 3}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                            shadows: [
                              Shadow(
                                offset: const Offset(2.5, 2.5),
                                blurRadius: 10.0,
                                color: Colors.black.withOpacity(0.8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
