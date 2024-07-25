import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/components/UI/custom_text_button.dart';
import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/pages/add_user_screen/add_user_screen.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/shared/circleposts.dart';
import 'package:circlesapp/variable_screens/circles/posts/circle_post_display.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class CircleScreen extends StatefulWidget {
  const CircleScreen({
    super.key,
    required this.circle,
    required this.tag,
  });

  final Circle circle;
  final String tag;

  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  late Future<List<CirclePost>> posts;
  late Circle circle;

  @override
  void initState() {
    super.initState();

    circle = widget.circle;

    posts = CircleService().fetchCirclePosts(circle.id!, 0);
  }

  Future<void> _navigateAndRefreshPost(BuildContext context) async {
    final response = (await mainKeyNav.currentState!.pushNamed(
      '/createpost',
      arguments: {
        "circle_id": circle.id,
      },
    )) as List;

    if (!mainKeyNav.currentState!.mounted) return;

    if (response[0] == "Post Created") {
      posts = CircleService().fetchCirclePosts(circle.id!, 0);

      setState(() {});
    }
  }

  Future<void> _navigateAndRefreshUsers(
    BuildContext context,
  ) async {
    final response = (await mainKeyNav.currentState!.push(
      MaterialPageRoute(
        builder: (context) {
          return AddUserScreen(
            circle: circle,
          );
        },
      ),
    )) as List;

    if (!mainKeyNav.currentState!.mounted) return;

    if (response[0] == "User Added") {
      circle = await CircleService().fetchCircle(circle.id!);

      CircleService().fetchCircles();

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: ComponentService.convertWidth(
          MediaQuery.of(context).size.width,
          260,
        ),
        backgroundColor: Theme.of(context).canvasColor,
        flexibleSpace: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: ComponentService.convertWidth(
                MediaQuery.of(context).size.width,
                16,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ExitButton(
                      icon: IonIcons.caret_back,
                      onPressed: () {
                        mainKeyNav.currentState!.pop();
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: ComponentService.convertHeight(
                    MediaQuery.of(context).size.height,
                    10,
                  ),
                ),
                Row(
                  children: [
                    Hero(
                      tag: widget.tag,
                      child: Container(
                        width: ComponentService.convertWidth(
                          MediaQuery.of(context).size.width,
                          125,
                        ),
                        height: ComponentService.convertWidth(
                          MediaQuery.of(context).size.width,
                          125,
                        ),
                        alignment: Alignment.centerLeft,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              circle.image!,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ComponentService.convertWidth(
                        MediaQuery.of(context).size.width,
                        10,
                      ),
                    ),
                    SizedBox(
                      height: ComponentService.convertWidth(
                        MediaQuery.of(context).size.width,
                        125,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                circle.name!,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "Admin: ${circle.admin!.name}",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: ComponentService.convertWidth(
                                  MediaQuery.of(context).size.width,
                                  40,
                                ),
                                width: ComponentService.convertWidth(
                                  MediaQuery.of(context).size.width,
                                  180,
                                ),
                                child: CustomTextButton(
                                  text: "Create Post",
                                  onPressed: () async {
                                    _navigateAndRefreshPost(context);
                                  },
                                ),
                              ),
                              SizedBox(
                                width: ComponentService.convertWidth(
                                  MediaQuery.of(context).size.width,
                                  20,
                                ),
                              ),
                              Container(
                                height: ComponentService.convertWidth(
                                  MediaQuery.of(context).size.width,
                                  40,
                                ),
                                width: ComponentService.convertWidth(
                                  MediaQuery.of(context).size.width,
                                  40,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    _navigateAndRefreshUsers(context);
                                  },
                                  child: FittedBox(
                                    child: Icon(
                                      Icons.person_add_alt_outlined,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: ComponentService.convertWidth(
                    MediaQuery.of(context).size.width,
                    15,
                  ),
                  thickness: 1,
                  color: const Color.fromARGB(255, 212, 212, 212),
                ),
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        right: ComponentService.convertWidth(
                          MediaQuery.of(context).size.width,
                          20,
                        ),
                      ),
                      child: Text(
                        maxLines: 2,
                        "CIRCLE\nMEMBERS",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: ComponentService.convertHeight(
                          MediaQuery.of(context).size.height,
                          50,
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: circle.users!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(
                                right: 5,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // TODO: view profile of user
                                },
                                padding: const EdgeInsets.all(0),
                                icon: CircleAvatar(
                                  radius: ComponentService.convertWidth(
                                    MediaQuery.of(context).size.width,
                                    25,
                                  ),
                                  backgroundImage: CachedNetworkImageProvider(
                                    circle.users![index].photoUrl ??
                                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: ComponentService.convertHeight(
                    MediaQuery.of(context).size.height,
                    15,
                  ),
                  thickness: 1,
                  color: const Color.fromARGB(255, 212, 212, 212),
                ),
              ],
            ),
          ),
        ),
      ),
      body: MaterialApp(
        navigatorKey: listKeyNav,
        routes: {
          "/": (context) => CirclePostDisplay(
                circle: circle,
                posts: posts,
              ),
        },
        theme: Theme.of(context),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
