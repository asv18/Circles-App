import 'package:circlesapp/components/type_based/Circles/circle_widget.dart';
import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/services/user_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:flutter/material.dart';

class CirclesDisp extends StatefulWidget {
  const CirclesDisp({
    super.key,
    required this.callback,
  });

  final Function callback;

  @override
  State<CirclesDisp> createState() => _CirclesDispState();
}

class _CirclesDispState extends State<CirclesDisp> {
  Offset _tapPosition = Offset.zero;

  void _getTapPosition(TapDownDetails details) {
    setState(() {
      _tapPosition = details.globalPosition;
    });
  }

  void _showActionsCircleMenu(BuildContext context, Circle circle) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 100, 100),
        Rect.fromLTWH(
          0,
          0,
          overlay!.paintBounds.size.width,
          overlay.paintBounds.size.height,
        ),
      ),
      items: [
        PopupMenuItem(
          value: (circle.admin!.fKey == UserService.dataUser.fKey)
              ? "Delete Circle"
              : "Leave Circle",
          child: Text(
            (circle.admin!.fKey == UserService.dataUser.fKey)
                ? "Delete Circle"
                : "Leave Circle",
          ),
        ),
        // if (circle.admin!.fKey == UserService.dataUser.fKey)
        //   const PopupMenuItem(
        //     value: "Edit Circle",
        //     child: Text("Edit Circle"),
        //   ),
      ],
    );

    if (result == "Leave Circle") {
      await CircleService().leaveCircle(circle);
      await CircleService().fetchCircles();
    } else if (result == "Delete Circle") {
      await CircleService().deleteCircle(circle);
      await CircleService().fetchCircles();
    } else if (result == "Edit Circle") {
      //TODO: implement edit circle screen
    }

    setState(() {});
  }

  Future<void> _navigateAndRefresh(BuildContext context) async {
    final response = (await mainKeyNav.currentState!.pushNamed(
      '/createorjoincircle',
    )) as List;

    if (!mainKeyNav.currentState!.mounted) return;

    if (response[0] == "Circle Created" || response[0] == "Circle Joined") {
      await CircleService().fetchCircles();

      widget.callback();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await CircleService().fetchCircles();
      },
      backgroundColor: Theme.of(context).primaryColorLight,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "CIRCLES",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              CreateButton(
                onPressed: () async {
                  _navigateAndRefresh(context);
                },
                text: "Create or Join Circle",
              ),
            ],
          ),
          SizedBox(
            height: ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              10,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Circle>>(
              future: CircleService.circles,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data!.isNotEmpty) {
                    return SafeArea(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CircleWidget(
                            circle: snapshot.data![index],
                            getTapPosition: _getTapPosition,
                            showActionsCircleMenu: _showActionsCircleMenu,
                          );
                        },
                      ),
                    );
                  } else {
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                        vertical: ComponentService.convertHeight(
                          MediaQuery.of(context).size.height,
                          10,
                        ),
                      ),
                      color: Theme.of(context).primaryColorLight,
                      child: Center(
                        child: Text(
                          "You are not a part of any circles yet",
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
