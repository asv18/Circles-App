import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/components/type_based/Circles/Posts/Comments/comment_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:circlesapp/shared/circlepostscomments.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CircleCommentsDisplay extends StatefulWidget {
  const CircleCommentsDisplay({
    super.key,
    required this.post,
    required this.postWidgetCallback,
  });

  final CirclePost post;
  final Function postWidgetCallback;

  @override
  State<CircleCommentsDisplay> createState() => _CircleCommentsDisplayState();
}

class _CircleCommentsDisplayState extends State<CircleCommentsDisplay> {
  late Future<List<PostComment>> comments;
  final TextEditingController _commentTextController = TextEditingController();
  BigInt? replyID;
  int offset = 0;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    comments = CircleService().fetchComments(
      widget.post.connectionID.toString(),
      offset,
    );

    _scrollController.addListener(() async {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;

        await comments.then((value) => offset = value.length);

        if (!isTop) {
          if (widget.post.comments != offset) {
            List<PostComment> newComments = await CircleService().fetchComments(
              widget.post.connectionID.toString(),
              offset,
            );

            setState(() {
              comments.then(
                (value) => value.addAll(newComments),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          60,
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: ComponentService.convertHeight(
                MediaQuery.of(context).size.height,
                5,
              ),
            ),
            child: ExitButton(
              onPressed: () {
                listKeyNav.currentState!.pop();
              },
              icon: FontAwesome.x,
            ),
          ),
          SizedBox(
            width: ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              16,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            offset = 0;
          });

          comments = CircleService().fetchComments(
            widget.post.connectionID.toString(),
            offset,
          );
        },
        backgroundColor: Theme.of(context).primaryColorLight,
        color: Theme.of(context).primaryColor,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              16,
            ),
          ),
          child: FutureBuilder<List<PostComment>>(
            future: comments,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (snapshot.hasData) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        CommentWidget(
                          comment: snapshot.data![index],
                          replyFunction: () {
                            setState(() {
                              replyID = snapshot.data![index].id;
                            });
                          },
                        ),
                        SizedBox(
                          height: ComponentService.convertHeight(
                            MediaQuery.of(context).size.height,
                            20,
                          ),
                        )
                      ],
                    );
                  },
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        color: Colors.white,
        height: replyID == null
            ? ComponentService.convertWidth(
                MediaQuery.of(context).size.width,
                80,
              )
            : ComponentService.convertWidth(
                MediaQuery.of(context).size.width,
                110,
              ),
        child: Container(
          height: ComponentService.convertWidth(
            MediaQuery.of(context).size.width,
            80,
          ),
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Visibility(
                      visible: replyID != null,
                      child: Column(
                        children: [
                          const Divider(
                            height: 0,
                            thickness: 1,
                            color: Color.fromARGB(255, 237, 237, 237),
                          ),
                          SizedBox(
                            height: ComponentService.convertHeight(
                              MediaQuery.of(context).size.height,
                              5,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: ComponentService.convertWidth(
                                MediaQuery.of(context).size.width,
                                10,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FutureBuilder(
                                  future: comments,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      for (var comment in snapshot.data!) {
                                        if (comment.id == replyID) {
                                          return Text(
                                            "replying to ${comment.poster!.name}'s comment",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          );
                                        }
                                      }
                                    }

                                    return const CircularProgressIndicator();
                                  },
                                ),
                                SizedBox(
                                  width: ComponentService.convertWidth(
                                    MediaQuery.of(context).size.width,
                                    24,
                                  ),
                                  height: ComponentService.convertWidth(
                                    MediaQuery.of(context).size.width,
                                    24,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        replyID = null;
                                      });
                                    },
                                    icon: const Icon(
                                      FontAwesome.x,
                                      size: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  const Divider(
                    height: 10,
                    thickness: 1,
                    color: Color.fromARGB(255, 237, 237, 237),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            cursorColor: Theme.of(context).primaryColor,
                            controller: _commentTextController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 247, 247, 252),
                              focusColor:
                                  const Color.fromARGB(255, 247, 247, 252),
                              hintText: "Write a comment...",
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                              border: InputBorder.none,
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Material(
                          child: Ink(
                            width: 50,
                            height: 40,
                            child: IconButton(
                              onPressed: () async {
                                if (_commentTextController.value !=
                                        TextEditingValue.empty &&
                                    _commentTextController.text
                                            .replaceAll(" ", "") !=
                                        "") {
                                  PostComment comment =
                                      await CircleService().postComment(
                                    UserService.dataUser.fKey!,
                                    _commentTextController.text,
                                    widget.post.connectionID.toString(),
                                    replyID.toString(),
                                  );

                                  _commentTextController.clear();

                                  setState(() {
                                    replyID = null;

                                    comments.then(
                                      (value) {
                                        if (comment.parentId == null) {
                                          value.insert(0, comment);
                                        } else {
                                          for (var element in value) {
                                            if (element.id.toString() ==
                                                comment.parentId.toString()) {
                                              element.children!.insert(
                                                0,
                                                comment,
                                              );

                                              element.childrenCount =
                                                  element.childrenCount! + 1;
                                            }
                                          }
                                        }
                                      },
                                    );
                                  });

                                  widget.postWidgetCallback();
                                }
                              },
                              icon: Icon(
                                Bootstrap.send_fill,
                                color: Theme.of(context).primaryColor,
                                size: 17.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
