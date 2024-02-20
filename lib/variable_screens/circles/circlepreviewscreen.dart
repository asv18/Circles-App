import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/components/UI/custom_text_button.dart';
import 'package:circlesapp/components/UI/custom_icon_button.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CirclePreviewScreen extends StatefulWidget {
  const CirclePreviewScreen({
    super.key,
    required this.circle,
    required this.tag,
  });

  final Circle circle;
  final String tag;

  @override
  State<CirclePreviewScreen> createState() => _CirclePreviewScreenState();
}

class _CirclePreviewScreenState extends State<CirclePreviewScreen> {
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
                    CustomIconButton(
                      icon: IonIcons.caret_back,
                      onPressed: () {
                        mainKeyNav.currentState!.pop(
                          ["Not Joined"],
                        );
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
                              widget.circle.image!,
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
                                widget.circle.name!,
                                style: GoogleFonts.poppins(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
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
                                height: ComponentService.convertWidth(
                                  MediaQuery.of(context).size.width,
                                  40,
                                ),
                                width: ComponentService.convertWidth(
                                  MediaQuery.of(context).size.width,
                                  180,
                                ),
                                child: CustomTextButton(
                                  text: "Join Circle",
                                  onPressed: () async {
                                    await CircleService().connectUserToCircle(
                                      widget.circle.id!,
                                    );

                                    mainKeyNav.currentState!.pop(
                                      ["Joined"],
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: ComponentService.convertWidth(
                                  MediaQuery.of(context).size.width,
                                  20,
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
                          itemCount: widget.circle.users!.length,
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
                                    widget.circle.users![index].photoUrl ??
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
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          color: Theme.of(context).primaryColorLight,
          child: Center(
            child: Text(
              "JOIN THIS CIRCLE TO SEE THE FEED!",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
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