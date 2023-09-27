import 'dart:convert';

import 'package:circlesapp/components/type_based/Users/user_image_circle_widget.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/shared/circlepostscomments.dart';
import 'package:circlesapp/shared/enums.dart';
import 'package:circlesapp/shared/liked.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class ChildCommentWidget extends StatefulWidget {
  const ChildCommentWidget({
    super.key,
    required this.comment,
  });

  final PostComment comment;

  @override
  State<ChildCommentWidget> createState() => _ChildCommentWidgetState();
}

class _ChildCommentWidgetState extends State<ChildCommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
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
                photoUrl: widget.comment.poster!.photoUrl,
                dimensions: 25,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                widget.comment.poster!.name!,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
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
                  InkWell(
                    splashFactory: NoSplash.splashFactory,
                    onTap: () async {
                      //TODO: implement replies
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
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
                  Text(
                    "Reply",
                    style: Theme.of(context).textTheme.labelLarge,
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
}
