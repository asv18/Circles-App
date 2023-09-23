import 'dart:convert';

import 'package:circlesapp/components/type_based/Circles/Posts/Comments/child_comment_widget.dart';
import 'package:circlesapp/components/type_based/Users/user_image_circle_widget.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/shared/circlepostscomments.dart';
import 'package:circlesapp/shared/enums.dart';
import 'package:circlesapp/shared/liked.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.comment,
  });

  final PostComment comment;

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
            style: Theme.of(context).textTheme.bodyMedium,
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
                IconButton(
                  onPressed: () async {
                    //TODO: implement replies
                  },
                  icon: Transform.flip(
                    flipX: true,
                    child: const Icon(
                      OctIcons.reply_24,
                      size: 20,
                      color: Color.fromARGB(255, 108, 117, 125),
                    ),
                  ),
                ),
                Text(
                  "Reply",
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
            IconButton(
              onPressed: () async {
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

                final response = await CircleService().handleCommentLikeButton(
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
              icon: Icon(
                widget.comment.liked!.likeStatus == LikedStatus.liked
                    ? OctIcons.heart_fill_24
                    : OctIcons.heart_24,
                size: 20,
                color: Colors.red,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 9,
              child: ListView.builder(
                itemCount: widget.comment.children!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return IntrinsicHeight(
                    child: Row(
                      children: [
                        const VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 108, 117, 125),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: ChildCommentWidget(
                            comment: widget.comment.children![index],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
