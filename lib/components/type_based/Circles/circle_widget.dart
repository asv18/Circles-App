import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/components/type_based/Users/user_image_circle_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/component_service.dart';
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
      margin: EdgeInsets.only(
        bottom: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          5,
        ),
      ),
      height: ComponentService.convertHeight(
        MediaQuery.of(context).size.height,
        130,
      ),
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
                margin: EdgeInsets.symmetric(
                  horizontal: ComponentService.convertWidth(
                    MediaQuery.of(context).size.width,
                    10,
                  ),
                  vertical: ComponentService.convertHeight(
                    MediaQuery.of(context).size.height,
                    12,
                  ),
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
                    Row(
                      children: [
                        SizedBox(
                          height: ComponentService.convertHeight(
                            MediaQuery.of(context).size.height,
                            30,
                          ),
                          width: ComponentService.convertWidth(
                            MediaQuery.of(context).size.width,
                            120,
                          ),
                          child: Stack(
                            children: List.generate(
                              circle.users!.length <= 3
                                  ? circle.users!.length
                                  : 4,
                              (index) {
                                return Positioned(
                                  left: index *
                                      ComponentService.convertWidth(
                                        MediaQuery.of(context).size.width,
                                        15,
                                      ),
                                  child: (index == 4)
                                      ? Container(
                                          width: ComponentService.convertWidth(
                                            MediaQuery.of(context).size.width,
                                            30,
                                          ),
                                          height: ComponentService.convertWidth(
                                            MediaQuery.of(context).size.width,
                                            30,
                                          ),
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
                                      : UserImageCircleWidget(
                                          photoUrl: circle
                                                  .users![index].photoUrl ??
                                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                                          dimensions:
                                              ComponentService.convertWidth(
                                            MediaQuery.of(context).size.width,
                                            15,
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
                  width: ComponentService.convertWidth(
                    MediaQuery.of(context).size.width,
                    130,
                  ),
                  height: ComponentService.convertHeight(
                    MediaQuery.of(context).size.height,
                    130,
                  ),
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
