import 'dart:convert';

import 'package:circlesapp/components/type_based/Users/user_image_circle_widget.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/shared/circlepostscomments.dart';
import 'package:circlesapp/shared/enums.dart';
import 'package:circlesapp/shared/liked.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class ChildCommentWidget extends StatefulWidget {
  const ChildCommentWidget({
    super.key,
    required this.comment,
    required this.replyFunction,
  });

  final PostComment comment;
  final Function replyFunction;

  @override
  State<ChildCommentWidget> createState() => _ChildCommentWidgetState();
}

class _ChildCommentWidgetState extends State<ChildCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ComponentService.convertWidth(
          MediaQuery.of(context).size.width,
          8,
        ),
        vertical: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          10,
        ),
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 247, 247, 252),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserImageCircleWidget(
                photoUrl: widget.comment.poster!.photoUrl ??
                    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                dimensions: ComponentService.convertWidth(
                  MediaQuery.of(context).size.width,
                  25,
                ),
              ),
              SizedBox(
                width: ComponentService.convertWidth(
                  MediaQuery.of(context).size.width,
                  20,
                ),
              ),
              Text(
                widget.comment.poster!.name!,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                width: ComponentService.convertWidth(
                  MediaQuery.of(context).size.width,
                  10,
                ),
              ),
              Text(
                formatDate(widget.comment.datePosted!),
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(
              vertical: ComponentService.convertHeight(
                MediaQuery.of(context).size.height,
                5,
              ),
            ),
            child: Text(
              widget.comment.contents!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "${widget.comment.likes} likes",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Container(
                    clipBehavior: Clip.none,
                    margin: EdgeInsets.symmetric(
                      horizontal: ComponentService.convertWidth(
                        MediaQuery.of(context).size.width,
                        10,
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () => widget.replyFunction(),
                      child: Transform.flip(
                        flipX: true,
                        child: const Icon(
                          OctIcons.reply_24,
                          size: 20,
                          color: Color.fromARGB(255, 108, 117, 125),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: () async {
                  setState(() {
                    if (widget.comment.liked!.likeStatus != null) {
                      widget.comment.liked!.likeStatus =
                          widget.comment.liked!.likeStatus == LikedStatus.liked
                              ? LikedStatus.notLiked
                              : LikedStatus.liked;
                    } else {
                      widget.comment.liked!.likeStatus = LikedStatus.liked;
                    }

                    widget.comment.likes = widget.comment.likes! +
                        ((widget.comment.liked!.likeStatus == LikedStatus.liked)
                            ? 1
                            : -1);
                  });

                  final response =
                      await CircleService().handleCommentLikeButton(
                    widget.comment.id.toString(),
                    widget.comment.liked!,
                  );

                  setState(() {
                    if (widget.comment.liked!.id == null) {
                      final liked = jsonDecode(response.body)["data"];

                      widget.comment.liked = Liked.fromJson(liked);
                    }
                  });
                },
                child: Icon(
                  widget.comment.liked!.likeStatus == LikedStatus.liked
                      ? OctIcons.heart_fill_24
                      : OctIcons.heart_24,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    if (DateTime.now().difference(date).inDays < 30) {
      if (DateTime.now().difference(date).inMinutes < 1) {
        return "${DateTime.now().difference(date).inSeconds} secs ago";
      } else if (DateTime.now().difference(date).inHours < 1) {
        return "${DateTime.now().difference(date).inMinutes} mins ago";
      } else if (DateTime.now().difference(date).inDays < 1) {
        return "${DateTime.now().difference(date).inHours} hrs ago";
      } else {
        return "${DateTime.now().difference(date).inDays} hrs ago";
      }
    } else {
      var formatterDate = DateFormat("MM/dd/yy");
      var formatterTime = DateFormat("h:mm a");

      return "${formatterDate.format(date)}, ${formatterTime.format(date)}";
    }
  }
}
