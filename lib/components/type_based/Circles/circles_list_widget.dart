import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/components/type_based/Users/user_image_circle_widget.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:flutter/material.dart';

class CircleListWidget extends StatelessWidget {
  const CircleListWidget({
    super.key,
    required this.circle,
    required this.navigate,
    required this.tag,
    this.showActionsCircleMenu,
    this.getTapPosition,
  });

  final Circle circle;
  final Function navigate;
  final String tag;

  final Function? showActionsCircleMenu;
  final Function? getTapPosition;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          5,
        ),
      ),
      height: ComponentService.convertWidth(
        MediaQuery.of(context).size.width,
        100,
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: () {
            navigate();
          },
          onTapDown: (details) {
            if (getTapPosition != null) {
              getTapPosition!(details);
            }
          },
          onLongPress: () {
            if (showActionsCircleMenu != null) {
              showActionsCircleMenu!();
            }
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
                  vertical: ComponentService.convertWidth(
                    MediaQuery.of(context).size.width,
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
                          height: ComponentService.convertWidth(
                            MediaQuery.of(context).size.width,
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
                                  left: index * 15,
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
                tag: tag,
                child: Container(
                  width: ComponentService.convertWidth(
                    MediaQuery.of(context).size.width,
                    100,
                  ),
                  height: ComponentService.convertWidth(
                    MediaQuery.of(context).size.width,
                    100,
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
