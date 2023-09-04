import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Theme.of(context).primaryColorLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: CachedNetworkImageProvider(
                        widget.post.poster!.photoUrl!,
                      ),
                    ),
                    Column(
                      children: [],
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            thickness: 1,
            height: 1,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          ),
        ],
      ),
    );
  }
}
