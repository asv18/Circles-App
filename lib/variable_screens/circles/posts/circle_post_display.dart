import 'package:circlesapp/components/type_based/Circles/Posts/post_widget.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CirclePostDisplay extends StatefulWidget {
  CirclePostDisplay({
    super.key,
    required this.circle,
    required this.posts,
  });

  final Circle circle;
  Future<List<CirclePost>> posts;

  @override
  State<CirclePostDisplay> createState() => _CirclePostDisplayState();
}

class _CirclePostDisplayState extends State<CirclePostDisplay> {
  final _scrollController = ScrollController();
  int offset = 0;

  @override
  void initState() {
    super.initState();

    widget.posts = CircleService().fetchCirclePosts(widget.circle.id!, offset);

    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;

        await widget.posts.then((value) => offset = value.length);

        if (!isTop) {
          if (widget.circle.postCount != offset) {
            List<CirclePost> newPosts = await CircleService().fetchCirclePosts(
              widget.circle.id.toString(),
              offset,
            );

            setState(() {
              widget.posts.then(
                (value) => value.addAll(newPosts),
              );
            });
          }

          print('At the bottom: $offset');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<List<CirclePost>>(
        future: widget.posts,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("err!");
          } else if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  offset = 0;
                });

                widget.posts = CircleService().fetchCirclePosts(
                  widget.circle.id!,
                  offset,
                );
              },
              backgroundColor: Theme.of(context).primaryColorLight,
              color: Theme.of(context).primaryColor,
              child: SafeArea(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return PostWidget(
                      post: snapshot.data![index],
                      circle: widget.circle,
                    );
                  },
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
