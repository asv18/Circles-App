import 'package:circlesapp/variable_screens/circlescreen.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircleListWidget extends StatelessWidget {
  const CircleListWidget({
    super.key,
    required this.circle,
  });

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
                  tag: circle.image,
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
          tag: circle.image,
          child: Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: NetworkImage(circle.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DefaultTextStyle(
                    style: GoogleFonts.montserrat(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
                  Row(
                    children: [
                      SizedBox(
                        height: 30.0,
                        width: 75.0,
                        child: Stack(
                          children: List.generate(
                            (circle.userCount <= 3) ? circle.userCount : 3,
                            (index) {
                              return Positioned(
                                left: index * 15,
                                child: Container(
                                  width: 30.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        'https://picsum.photos/200/200?random=$index',
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
                      SizedBox(
                        width: 20.0,
                        child: Visibility(
                          visible: circle.userCount > 3,
                          child: DefaultTextStyle(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
