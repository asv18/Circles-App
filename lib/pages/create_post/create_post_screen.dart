import 'dart:io';

import 'package:circlesapp/components/type_based/Goals/goal_list_toggle.dart';
import 'package:circlesapp/services/api_services.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/services/goal_service.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:flutter/material.dart';
import 'package:circlesapp/components/UI/custom_text_button.dart';
import 'package:circlesapp/components/UI/custom_text_field.dart';
import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/routes.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';

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

  File? _imageSrc;
  String? _imageURL;

  Future<void> pickImage(ImageSource imageSource) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: imageSource);

    setState(() {
      if (pickedImage != null) {
        _imageSrc = File(pickedImage.path);
      }
    });
  }

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
        toolbarHeight: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          50,
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "CREATE A NEW POST",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
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
                mainKeyNav.currentState!.pop(
                  [
                    "Post Not Created",
                  ],
                );
              },
              icon: FontAwesome.x,
            ),
          ),
          SizedBox(
            width: ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              10,
            ),
          ),
        ],
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(
            ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              16,
            ),
            ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              15,
            ),
            ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              16,
            ),
            ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              40,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                labelText: "Post Title",
                hintText: "Post title",
                controller: _postNameController,
              ),
              SizedBox(
                height: ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  10,
                ),
              ),
              CustomTextField(
                labelText: "Post Description",
                hintText: "What describes your post?",
                controller: _descriptionController,
              ),
              SizedBox(
                height: ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  10,
                ),
              ),
              Text(
                "REFERENCE A GOAL",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                height: ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  10,
                ),
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
                            bottom: (index != snapshot.data!.length - 1)
                                ? ComponentService.convertHeight(
                                    MediaQuery.of(context).size.height,
                                    10,
                                  )
                                : 0,
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
              Container(
                height: 200,
                margin: EdgeInsets.symmetric(
                  vertical: ComponentService.convertHeight(
                    MediaQuery.of(context).size.height,
                    10,
                  ),
                ),
                color: Theme.of(context).primaryColorLight,
                child: InkWell(
                  onTap: () async {
                    await pickImage(ImageSource.gallery);
                  },
                  child: _imageSrc != null
                      ? Center(
                          child: Image.file(
                            _imageSrc!,
                            fit: BoxFit.fill,
                          ),
                        )
                      : Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "This post has no image yet",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                WidgetSpan(
                                  child: SizedBox(
                                    width: ComponentService.convertWidth(
                                      MediaQuery.of(context).size.width,
                                      10,
                                    ),
                                  ),
                                ),
                                const WidgetSpan(
                                  child: Icon(
                                    FontAwesome.pen,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
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

                      await GoalService.goals.then(
                        (value) {
                          for (int i = 0; i < value.length; i++) {
                            if (toggled[i]) {
                              goalID = value[i].id;
                            }
                          }
                        },
                      );

                      if (_imageSrc != null) {
                        _imageURL = await APIServices().uploadImage(_imageSrc!);
                      }

                      CirclePost newCirclePost = CirclePost(
                        title: _postNameController.text,
                        description: _descriptionController.text,
                        goalID: goalID,
                        image: _imageURL,
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
}
