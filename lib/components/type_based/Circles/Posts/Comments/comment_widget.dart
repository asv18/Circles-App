import 'dart:convert';

import 'package:circlesapp/components/type_based/Circles/Posts/Comments/child_comment_widget.dart';
import 'package:circlesapp/components/type_based/Users/user_image_circle_widget.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/shared/circlepostscomments.dart';
import 'package:circlesapp/shared/enums.dart';
import 'package:circlesapp/shared/liked.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class CommentWidget extends StatefulWidget {
  const CommentWidget({
    super.key,
    required this.comment,
    required this.replyFunction,
  });

  final PostComment comment;
  final Function replyFunction;

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
              photoUrl: widget.comment.poster!.photoUrl ??
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
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
              width: 10,
            ),
            Text(
              formatDate(widget.comment.datePosted!),
              style: Theme.of(context).textTheme.labelMedium,
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
                Container(
                  clipBehavior: Clip.none,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
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
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  widget.comment.liked!.likeStatus == LikedStatus.liked
                      ? OctIcons.heart_fill_24
                      : OctIcons.heart_24,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: (widget.comment.children!.isNotEmpty) ? 30 : 0,
          child: const VerticalDivider(
            width: 0,
            thickness: 1,
            color: Color.fromARGB(255, 108, 117, 125),
          ),
        ),
        ListView.builder(
          itemCount: widget.comment.children!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      const VerticalDivider(
                        width: 0,
                        thickness: 1,
                        color: Color.fromARGB(255, 108, 117, 125),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ChildCommentWidget(
                          comment: widget.comment.children![index],
                          replyFunction: widget.replyFunction,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.comment.children!.length > 1 &&
                    widget.comment.children!.length - 1 != index)
                  const SizedBox(
                    height: 10,
                    child: VerticalDivider(
                      width: 0,
                      thickness: 1,
                      color: Color.fromARGB(255, 108, 117, 125),
                    ),
                  ),
              ],
            );
          },
        ),
        Visibility(
          visible:
              widget.comment.children!.length != widget.comment.childrenCount,
          child: TextButton(
            onPressed: () async {
              List<PostComment> newChildren =
                  await CircleService().fetchChildComments(
                widget.comment.postId!.toString(),
                widget.comment.id!.toString(),
                widget.comment.children!.length,
              );

              setState(() {
                widget.comment.children!.addAll(newChildren);
              });
            },
            child: Text(
              "load more",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ),
      ],
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
