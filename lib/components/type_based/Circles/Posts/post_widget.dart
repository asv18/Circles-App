import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:circlesapp/shared/enums.dart';
import 'package:circlesapp/shared/liked.dart';
import 'package:circlesapp/variable_screens/circles/posts/circle_comments_display.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    super.key,
    required this.post,
    required this.circle,
  });

  final CirclePost post;
  final Circle circle;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  String formatDate(DateTime date) {
    var formatterDate = DateFormat("MM/dd/yy");
    var formatterDay = DateFormat("EEE");
    var formatterTime = DateFormat("h:mm a");

    if (date.difference(DateTime.now()).inDays == 0) {
      return "Today, ${formatterTime.format(date)}";
    } else if (date.difference(DateTime.now()).inDays >= -7) {
      return "${formatterDay.format(date)}, ${formatterTime.format(date)}";
    }

    return "${formatterDate.format(date)}, ${formatterTime.format(date)}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).primaryColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.post.poster!.photoUrl ??
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.post.poster!.name!,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          formatDate(
                            widget.post.postedAt!,
                          ),
                          style: Theme.of(context).textTheme.displaySmall,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
                (widget.post.taskID != null)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            IonIcons.checkmark_circle,
                            color: Theme.of(context).indicatorColor,
                            size: 20,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.post.title!,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Text(
                        widget.post.title!,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
              ],
            ),
          ),
          (widget.post.image == null)
              ? const Divider(
                  thickness: 1,
                  height: 1,
                )
              : Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.post.image!,
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onTap: () async {
                        setState(() {
                          widget.post.liked!.likeStatus =
                              widget.post.liked!.likeStatus == null
                                  ? LikedStatus.liked
                                  : widget.post.liked!.likeStatus ==
                                          LikedStatus.liked
                                      ? LikedStatus.notLiked
                                      : LikedStatus.liked;

                          widget.post.likes = widget.post.likes! +
                              ((widget.post.liked!.likeStatus ==
                                      LikedStatus.liked)
                                  ? 1
                                  : -1);
                        });

                        final response =
                            await CircleService().handlePostLikeButton(
                          widget.post.connectionID.toString(),
                          widget.post.liked!,
                        );

                        setState(() {
                          if (widget.post.liked!.id == null) {
                            final liked = jsonDecode(response.body)["data"];

                            widget.post.liked = Liked.fromJson(liked);
                          }
                        });
                      },
                      child: Icon(
                        (widget.post.liked!.likeStatus == LikedStatus.liked)
                            ? OctIcons.heart_fill_24
                            : OctIcons.heart_24,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "${widget.post.likes} likes",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
                Row(
                  children: [
                    InkWell(
                      splashFactory: NoSplash.splashFactory,
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onTap: () {
                        listKeyNav.currentState!.push(
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return CircleCommentsDisplay(
                                post: widget.post,
                                postWidgetCallback: () {
                                  setState(() {
                                    widget.post.comments =
                                        widget.post.comments! + 1;
                                  });
                                },
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
                      child: Icon(
                        OctIcons.comment_24,
                        color: Theme.of(context).primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "${widget.post.comments} comments",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
