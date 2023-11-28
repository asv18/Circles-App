import 'package:circlesapp/components/type_based/Circles/circle_widget.dart';
import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/services/component_service.dart';
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
                  await ComponentService.navigateAndRefreshCreateCircles(
                    context,
                    widget.callback,
                  );

                  setState(() {});
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
                            showActionsCircleMenu: () async {
                              await ComponentService.showActionsCircleMenu(
                                context,
                                snapshot.data![index],
                                _tapPosition,
                              );

                              setState(() {});
                            },
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
