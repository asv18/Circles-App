import 'package:circlesapp/components/type_based/Circles/circle_widget.dart';
import 'package:circlesapp/components/UI/create_button.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:flutter/material.dart';

class CirclesDisp extends StatefulWidget {
  const CirclesDisp({super.key});

  @override
  State<CirclesDisp> createState() => _CirclesDispState();
}

class _CirclesDispState extends State<CirclesDisp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await CircleService().fetchCircles();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CreateButton(
                    onPressed: () {},
                    text: "Join",
                  ),
                  CreateButton(
                    onPressed: () {},
                    text: "Create",
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Circle>>(
                future: CircleService.circles,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return CircleWidget(
                            circle: snapshot.data![index],
                          );
                        },
                      );
                    } else {
                      return const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "You are not a part of any circles yet...",
                            style: TextStyle(
                              fontSize: 26,
                            ),
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
      ),
    );
  }
}
