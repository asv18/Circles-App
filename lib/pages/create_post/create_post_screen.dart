import 'package:circlesapp/components/type_based/Goals/goal_list_toggle.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';
import 'package:circlesapp/components/UI/custom_text_button.dart';
import 'package:circlesapp/components/UI/custom_text_field.dart';
import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:icons_plus/icons_plus.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({
    super.key,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _postNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<bool> toggled = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "CREATE A NEW POST",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ExitButton(
              onPressed: () {
                mainKeyNav.currentState!.pop(
                  [
                    "Post Not Created",
                  ],
                );
              },
              icon: FontAwesome.x,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
        ],
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                labelText: "Post Title",
                hintText: "Post title",
                controller: _postNameController,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomTextField(
                labelText: "Post Description",
                hintText: "What describes your post?",
                controller: _descriptionController,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "REFERENCE A GOAL",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 10.0,
              ),
              FutureBuilder<List<Goal>>(
                future: GoalService.goals,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    toggled = List.generate(
                      snapshot.data!.length,
                      (int index) => false,
                      growable: false,
                    );

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(
                            bottom:
                                (index != snapshot.data!.length - 1) ? 10 : 0,
                          ),
                          child: GoalListToggle(
                            goal: snapshot.data![index],
                            toggled: toggled,
                            index: index,
                          ),
                        );
                      },
                    );
                  }

                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: CustomTextButton(
                  onPressed: () async {
                    if (_postNameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Please give your post a title",
                          textAlign: TextAlign.center,
                        ),
                        duration: Duration(seconds: 5),
                      ));
                    } else {
                      String? goalID;

                      GoalService.goals.then(
                        (value) {
                          for (int i = 0; i < value.length; i++) {
                            if (toggled[i]) {
                              goalID = value[i].id;
                            }
                          }
                        },
                      );

                      CirclePost newCirclePost = CirclePost(
                        title: _postNameController.text,
                        description: _descriptionController.text,
                        goalID: goalID,
                      );

                      await CircleService().createPost(
                        newCirclePost,
                        args["circle_id"],
                      );

                      if (mainKeyNav.currentState!.mounted) {
                        mainKeyNav.currentState!.pop(
                          [
                            "Post Created",
                            newCirclePost,
                          ],
                        );
                      }
                    }
                  },
                  text: "Create New Post",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool anyNull(List<Task> tasks) {
    for (Task task in tasks) {
      if (task.name == "") {
        return true;
      }
    }
    return false;
  }
}
