import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/extraneous_screens/circlescreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    Key? key,
    required this.circle,
  }) : super(key: key);

  final Circle circle;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return CircleScreen(
                  circle: circle,
                  tag: circle.name,
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
        child: Hero(
          tag: circle.name,
          child: Container(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                  DefaultTextStyle(
                    style: GoogleFonts.montserrat(
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
                    child: Text(
                      circle.name,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    child: DefaultTextStyle(
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
                      child: Text(
                        "${circle.updates} new updates",
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
                                        'https://picsum.photos/200/200?random=${index}',
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
                        child: DefaultTextStyle(
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
                          child: Text(
                            "+${circle.userCount - 3}",
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
