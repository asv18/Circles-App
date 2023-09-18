import 'package:circlesapp/components/type_based/Circles/Posts/post_widget.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:flutter/material.dart';

class CirclePostDisplay extends StatefulWidget {
  const CirclePostDisplay({
    super.key,
    required this.circle,
  });

  final Circle circle;

  @override
  State<CirclePostDisplay> createState() => _CirclePostDisplayState();
}

class _CirclePostDisplayState extends State<CirclePostDisplay> {
  Future<List<CirclePost>>? posts;

  @override
  void initState() {
    super.initState();

    posts = CircleService().fetchCirclePosts(widget.circle.id!);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CirclePost>>(
      future: posts,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("err!");
        } else if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: () async {
              await CircleService().fetchCirclePosts(widget.circle.id!);
            },
            backgroundColor: Theme.of(context).primaryColorLight,
            color: Theme.of(context).primaryColor,
            child: SafeArea(
              child: ListView.builder(
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
    );
  }
}
