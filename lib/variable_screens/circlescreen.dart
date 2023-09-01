import 'package:cached_network_image/cached_network_image.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/circles_service.dart';
import '../shared/circleposts.dart';

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
  Future<List<CirclePost>>? posts;
  @override
  void initState() {
    super.initState();

    posts = CircleService().fetchCirclePosts(widget.circle.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: (MediaQuery.of(context).size.height / 4.6),
        elevation: 2,
        backgroundColor: Colors.transparent,
        flexibleSpace: Hero(
          tag: widget.tag,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.topCenter,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  widget.circle.image!,
                ),
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned(
                    left: MediaQuery.of(context).size.width / 50,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: MediaQuery.of(context).size.width / 86,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: DefaultTextStyle(
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(2.5, 2.5),
                              blurRadius: 10.0,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ],
                        ),
                        child: Text(
                          widget.circle.name!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<CirclePost>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("err!");
          } else if (snapshot.hasData) {
            return Text("${snapshot.data!.length}");
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
