import 'package:circlesapp/components/UI/custom_text_button.dart';
import 'package:circlesapp/components/UI/custom_text_field.dart';
import 'package:circlesapp/components/UI/exit_button.dart';
import 'package:circlesapp/components/UI/search_appbar.dart';
import 'package:circlesapp/components/type_based/Circles/circles_list_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/circles_service.dart';
import 'package:circlesapp/shared/circle.dart';
import 'package:circlesapp/variable_screens/circles/circlepreviewscreen.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CreateOrJoinCircleScreen extends StatefulWidget {
  const CreateOrJoinCircleScreen({super.key});

  @override
  State<CreateOrJoinCircleScreen> createState() =>
      _CreateOrJoinCircleScreenState();
}

class _CreateOrJoinCircleScreenState extends State<CreateOrJoinCircleScreen> {
  final _circleNameController = TextEditingController();
  List<String> spinnerItems = ["Public", /*"Friends Only",*/ "Private"];
  String value = "Public";

  final _queryController = TextEditingController();
  String searchTerm = "";

  String type = "/createorjoin/circle/tag";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "CREATE OR JOIN A CIRCLE",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: ExitButton(
              onPressed: () {
                mainKeyNav.currentState!.pop(
                  [
                    "Goal Not Created",
                  ],
                );
              },
              icon: FontAwesome.x,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
        ],
        backgroundColor: Theme.of(context).canvasColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Create a Circle",
                maxLines: 2,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomTextField(
                labelText: "Circle Name",
                hintText: "What do want the goal of this circle to be?",
                controller: _circleNameController,
              ),
              const SizedBox(
                height: 10.0,
              ),
              CustomDropDownButton(
                  spinnerItems: spinnerItems,
                  value: value,
                  onChanged: (String? val) {
                    setState(() {
                      value = val ?? "Public";
                    });
                  }),
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 200,
                  child: CustomTextButton(
                    onPressed: () async {
                      if (_circleNameController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            "Please give a valid name to your circle",
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 5),
                        ));
                      } else {
                        Circle newCircle = Circle(
                          name: _circleNameController.text,
                          status: value,
                        );

                        await CircleService().createCircle(newCircle);

                        if (mainKeyNav.currentState!.mounted) {
                          mainKeyNav.currentState!.pop(
                            [
                              "Circle Created",
                              newCircle,
                            ],
                          );
                        }
                      }
                    },
                    text: "Create New Circle",
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.black,
                      height: 40,
                      endIndent: 20,
                    ),
                  ),
                  Text(
                    "OR",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.black,
                      height: 40,
                      indent: 20,
                    ),
                  ),
                ],
              ),
              Text(
                "Join a Circle",
                maxLines: 2,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(
                height: 20.0,
              ),
              SearchAppBar(
                controller: _queryController,
                onChanged: (value) {
                  setState(() {
                    searchTerm = value.toString().toLowerCase();
                  });
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              SizedBox(
                height: 400,
                child: FutureBuilder<List<Circle>>(
                  //TODO implement offset
                  future: CircleService().queryCircles(searchTerm, 0),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return CircleListWidget(
                            tag: "${snapshot.data![index].id}$type",
                            circle: snapshot.data![index],
                            navigate: () async {
                              final result =
                                  await mainKeyNav.currentState!.push(
                                PageRouteBuilder(
                                  transitionDuration:
                                      const Duration(milliseconds: 400),
                                  pageBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                  ) {
                                    return CirclePreviewScreen(
                                      circle: snapshot.data![index],
                                      tag: "${snapshot.data![index].id}$type",
                                    );
                                  },
                                  transitionsBuilder: (
                                    BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation,
                                    Widget child,
                                  ) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                ),
                              ) as List;

                              if (result[0] == "Joined") {
                                mainKeyNav.currentState!.pop(
                                  ["Circle Joined"],
                                );
                              }
                            },
                          );
                        },
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDropDownButton extends StatelessWidget {
  const CustomDropDownButton({
    super.key,
    required this.spinnerItems,
    required this.value,
    required this.onChanged,
  });

  final List<String> spinnerItems;
  final String value;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Circle Status",
            style: Theme.of(context).textTheme.labelMedium,
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isDense: true,
              dropdownColor: Theme.of(context).canvasColor,
              icon: const Icon(
                IonIcons.caret_down,
                color: Colors.black,
                size: 15,
              ),
              onChanged: (String? val) => onChanged(val),
              items: spinnerItems.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
