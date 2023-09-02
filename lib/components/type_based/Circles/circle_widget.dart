import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/variable_screens/circlescreen.dart';
import 'package:flutter/material.dart';

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
                  tag: circle.name!,
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
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          height: 120.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Theme.of(context).primaryColorLight,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(15.0, 10.0, 0, 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: Theme.of(context).textTheme.headlineMedium!,
                      child: Text(
                        circle.name!,
                      ),
                    ),
                    // Container(
                    // margin: const EdgeInsets.symmetric(vertical: 20.0),
                    // child: DefaultTextStyle(
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.w400,
                    //     shadows: [
                    //       Shadow(
                    //         offset: const Offset(2.5, 2.5),
                    //         blurRadius: 10.0,
                    //         color: Colors.black.withOpacity(0.8),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Text(
                    //     "${circle.updates} new updates",
                    //   ),
                    // ),
                    // ),
                    Row(
                      children: [
                        SizedBox(
                          height: 30.0,
                          width: 120.0,
                          child: Stack(
                            children: List.generate(
                              circle.users!.length <= 3
                                  ? circle.users!.length
                                  : 4,
                              (index) {
                                return Positioned(
                                  left: index * 15,
                                  child: (index == 4)
                                      ? Container(
                                          width: 30.0,
                                          height: 30.0,
                                          color: const Color.fromARGB(
                                            255,
                                            214,
                                            226,
                                            255,
                                          ),
                                          child: Text(
                                            "+${circle.users!.length - 3}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                          ),
                                        )
                                      : Container(
                                          width: 30.0,
                                          height: 30.0,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: CachedNetworkImageProvider(
                                                circle.users![index].photoUrl!,
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
                      ],
                    ),
                  ],
                ),
              ),
              Hero(
                tag: circle.name!,
                child: Container(
                  width: 121,
                  height: 121,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        circle.image!,
                      ),
                    ),
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
