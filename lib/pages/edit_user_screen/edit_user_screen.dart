import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/components/UI/custom_text_button.dart';
import 'package:circlesapp/components/UI/custom_text_field.dart';
import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/components/type_based/Users/user_image_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/api_services.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:image_picker/image_picker.dart';

class EditUserScreen extends StatefulWidget {
  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  String genTag = "/profile/image";
  String userTag = "/user/image/${UserService.dataUser.photoUrl}";

  late TextEditingController _nameController;
  late TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: UserService.dataUser.name);
    _usernameController =
        TextEditingController(text: UserService.dataUser.username);
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: MediaQuery.of(context).size.height / 7.5,
        flexibleSpace: Hero(
          tag: genTag,
          child: const Image(
            image: CachedNetworkImageProvider(
              'https://picsum.photos/600/600',
            ),
            fit: BoxFit.cover,
          ),
        ),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: ExitButton(
          onPressed: () {
            mainKeyNav.currentState!.pop(
              [
                "User Not Edited",
              ],
            );
          },
          icon: FontAwesome.x_solid,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              150,
            ),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ComponentService.convertWidth(
                MediaQuery.of(context).size.width,
                20,
              ),
            ),
            child: Transform.translate(
              offset: Offset(
                0,
                ComponentService.convertHeight(
                  MediaQuery.of(context).size.height,
                  75,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      await pickImage(ImageSource.gallery);
                    },
                    child: Stack(
                      children: [
                        Hero(
                          tag: userTag,
                          child: _imageSrc == null
                              ? UserImageWidget(
                                  photoUrl: UserService.dataUser.photoUrl ??
                                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                                  dimensions: ComponentService.convertWidth(
                                    MediaQuery.of(context).size.width,
                                    150,
                                  ),
                                )
                              : UserImageWidget(
                                  imgSrc: _imageSrc,
                                  useCachedNetwork: false,
                                  dimensions: ComponentService.convertWidth(
                                    MediaQuery.of(context).size.width,
                                    150,
                                  ),
                                ),
                        ),
                        Positioned(
                          left: ComponentService.convertWidth(
                            MediaQuery.of(context).size.width,
                            120,
                          ),
                          top: ComponentService.convertWidth(
                            MediaQuery.of(context).size.width,
                            120,
                          ),
                          child: Container(
                            width: ComponentService.convertWidth(
                              MediaQuery.of(context).size.width,
                              20,
                            ),
                            height: ComponentService.convertWidth(
                              MediaQuery.of(context).size.width,
                              20,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).primaryColorLight,
                            ),
                            child: const Icon(
                              FontAwesome.pencil_solid,
                              color: Colors.black,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  DefaultTextStyle(
                    style: Theme.of(context).textTheme.displayLarge!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    child: Text(
                      UserService.dataUser.name!,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10, top: 100),
          child: Column(
            children: [
              CustomTextField(
                labelText: "Full Name",
                hintText: "Your full name",
                controller: _nameController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                labelText: "Username",
                hintText: "Your username",
                controller: _usernameController,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTextField(
                labelText: "Email",
                hintText: "Your email",
                controller: TextEditingController(
                  text: UserService.dataUser.email,
                ),
                readOnly: true,
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextButton(
                text: "Save",
                onPressed: () async {
                  if (_nameController.text.isNotEmpty &&
                      _usernameController.text.isNotEmpty) {
                    UserService.dataUser.name = _nameController.text;
                    UserService.dataUser.username = _usernameController.text;
                  }

                  if (_imageSrc != null) {
                    _imageURL = await APIServices().uploadImage(
                      _imageSrc!,
                    );
                  }

                  if (_imageURL != null) {
                    UserService.dataUser.photoUrl = _imageURL;
                  }

                  await UserService().putUserInBox();
                  await UserService().updateUser();

                  mainKeyNav.currentState!.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
