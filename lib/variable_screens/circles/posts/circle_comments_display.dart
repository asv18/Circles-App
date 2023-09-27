import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/components/type_based/Circles/Posts/Comments/comment_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:circlesapp/shared/circlepostscomments.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CircleCommentsDisplay extends StatefulWidget {
  const CircleCommentsDisplay({
    super.key,
    required this.post,
  });

  final CirclePost post;

  @override
  State<CircleCommentsDisplay> createState() => _CircleCommentsDisplayState();
}

class _CircleCommentsDisplayState extends State<CircleCommentsDisplay> {
  late Future<List<PostComment>> comments;
  final TextEditingController _commentTextController = TextEditingController();
  BigInt? replyID;

  @override
  void initState() {
    super.initState();

    comments =
        CircleService().fetchComments(widget.post.connectionID.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ExitButton(
              onPressed: () {
                listKeyNav.currentState!.pop();
              },
              icon: FontAwesome.x,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
        ],
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          comments = CircleService()
              .fetchComments(widget.post.connectionID.toString());
        },
        backgroundColor: Theme.of(context).primaryColorLight,
        color: Theme.of(context).primaryColor,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List<PostComment>>(
            future: comments,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CommentWidget(
                          comment: snapshot.data![index],
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    );
                  },
                );
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 3,
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            width: double.infinity,
            color: Colors.white,
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    cursorColor: Theme.of(context).primaryColor,
                    controller: _commentTextController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 247, 247, 252),
                      focusColor: const Color.fromARGB(255, 247, 247, 252),
                      hintText: "Write a comment...",
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: InputBorder.none,
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                IconButton(
                  alignment: Alignment.center,
                  onPressed: () async {
                    await CircleService().postComment(
                      UserService.dataUser.fKey!,
                      _commentTextController.text,
                      widget.post.id!,
                      replyID,
                    );
                  },
                  icon: Icon(
                    Bootstrap.send_fill,
                    color: Theme.of(context).primaryColor,
                    size: 17.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
