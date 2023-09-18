import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/components/UI/custom_text_button.dart';
import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/variable_screens/circles/posts/circle_comments_display.dart';
import 'package:circlesapp/variable_screens/circles/posts/circle_post_display.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height / 4.0,
        backgroundColor: Theme.of(context).canvasColor,
        flexibleSpace: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
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
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Circle Details",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Hero(
                      tag: widget.tag,
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        alignment: Alignment.centerLeft,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(
                              widget.circle.image!,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      height: 100.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.circle.name}",
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                              Text(
                                "Admin: ${widget.circle.admin!.name}",
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 40,
                                width: 180,
                                child: CustomTextButton(
                                  text: "Create Post",
                                  onPressed: () async {},
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {},
                                  icon: const FittedBox(
                                    child: Icon(
                                      Icons.person_add_alt_outlined,
                                      color: Colors.white,
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
                const Divider(
                  height: 15.0,
                  thickness: 1,
                  color: Color.fromARGB(255, 212, 212, 212),
                ),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20),
                      child: Text(
                        maxLines: 2,
                        "CIRCLE\nMEMBERS",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: widget.circle.users!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 16),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundImage: CachedNetworkImageProvider(
                                  widget.circle.users![index].photoUrl!,
                                ),
                                child: InkWell(
                                  onTap: () {},
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  height: 15.0,
                  thickness: 1,
                  color: Color.fromARGB(255, 212, 212, 212),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Navigator(
          key: listKeyNav,
          initialRoute: "/",
          onGenerateRoute: (settings) {
            Widget page;

            switch (settings.name) {
              case "/":
                page = CirclePostDisplay(
                  circle: widget.circle,
                );
                break;
              case "/comments":
                page = const CircleCommentsDisplay();
                break;
              default:
                page = CirclePostDisplay(
                  circle: widget.circle,
                );
                break;
            }

            return PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return page;
              },
            );
          },
        ),
      ),
    );
  }
}

/**
 * 
 * CirclePostDisplay(
    circle: widget.circle,
  ),
 */