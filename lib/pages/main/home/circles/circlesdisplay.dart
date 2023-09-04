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
                onPressed: () {},
                text: "Join or Create Circle",
              ),
            ],
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
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      color: Theme.of(context).primaryColorLight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "You are not a part of any circles yet",
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
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
