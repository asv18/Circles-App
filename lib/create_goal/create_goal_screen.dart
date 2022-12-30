import 'package:circlesapp/shared/task.dart';
import 'package:flutter/material.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  String? goalName;
  DateTime? date;
  List<Task> tasks = [
    Task(
      name: "",
      repeat: "",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    String dateText = "mm / dd / yyyy";
    DateTime? selectedDate = DateTime.now();

    Future<void> selectDate(BuildContext context) async {
      selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "New Goal",
          style: TextStyle(
            color: Colors.black,
            fontSize: 48.0,
            fontWeight: FontWeight.w300,
          ),
        ),
        backgroundColor: Colors.grey[50],
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 100.0,
                  height: 100.0,
                  margin: const EdgeInsets.only(right: 20.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "What do you want to achieve?",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10.0),
                      width: 275.0,
                      height: 50.0,
                      child: const TextField(
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          hintText: "Think about the outcome you want...",
                          hintStyle: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 30.0),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    child: const Icon(
                      Icons.calendar_month_outlined,
                      size: 75.0,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "By when?",
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        width: 275.0,
                        height: 50.0,
                        child: TextField(
                          readOnly: true,
                          onTap: () => {
                            selectDate(context),
                            setState(() {
                              if (selectedDate != null) {
                                dateText =
                                    "${selectedDate!.toLocal().month} / ${selectedDate!.toLocal().day} / ${selectedDate!.toLocal().year}";
                              } else {
                                selectedDate = DateTime.now();
                              }
                            })
                          },
                          decoration: InputDecoration(
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            ),
                            hintText: dateText,
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color: (dateText == "mm / dd / yyyy")
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
