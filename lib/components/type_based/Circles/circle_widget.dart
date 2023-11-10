import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/variable_screens/circles/circlescreen.dart';
import 'package:flutter/material.dart';

class CircleWidget extends StatelessWidget {
  const CircleWidget({
    super.key,
    required this.circle,
    required this.showActionsCircleMenu,
    required this.getTapPosition,
  });

  final Circle circle;
  final type = "circle/widget/hero";

  final Function showActionsCircleMenu;
  final Function getTapPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      height: 130.0,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTapDown: (details) => getTapPosition(details),
          onLongPress: () => showActionsCircleMenu(
            context,
            circle,
          ),
          onTap: () {
            mainKeyNav.currentState!.push(
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 400),
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  return CircleScreen(
                    circle: circle,
                    tag: "${circle.id!}$type",
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 12.0,
                ),
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
                    // shadows: [
                    //   Shadow(
                    //     offset: const Offset(2.5, 2.5),
                    //     blurRadius: 10.0,
                    //     color: Colors.black.withOpacity(0.8),
                    //   ),
                    // ],
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
                                                circle.users![index].photoUrl ??
                                                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
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
                tag: "${circle.id!}$type",
                child: Container(
                  width: 130,
                  height: 130,
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
