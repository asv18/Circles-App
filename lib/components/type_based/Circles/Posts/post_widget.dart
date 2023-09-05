import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    super.key,
    required this.post,
  });

  final CirclePost post;

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
                        widget.post.poster!.photoUrl!,
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
                        fit: BoxFit.fitWidth),
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
                    const Icon(
                      OctIcons.heart_24,
                      color: Colors.red,
                      size: 22,
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
                    Icon(
                      OctIcons.comment_24,
                      color: Theme.of(context).primaryColor,
                      size: 22,
                    ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "${widget.post.comments.length} comments",
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
