import 'package:circlesapp/services/auth_service.dart';
import 'package:circlesapp/shared/goal.dart';
import 'package:circlesapp/shared/task.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Task> tasks = [
    Task(name: "task 1", repeat: "Never"),
    Task(name: "task 2", repeat: "Daily"),
    Task(name: "task 3", repeat: "Monthly"),
    Task(name: "task 4", repeat: "Weekly"),
  ];
  List<Goal> goals = [
    Goal(
      name: "goal 1",
      timeLim: 3,
      numTasks: 4,
      numRecur: 1,
      progress: 2,
    ),
    Goal(
      name: "goal 2",
      timeLim: 5,
      numTasks: 2,
      numRecur: 1,
      progress: 1,
    ),
    Goal(
      name: "goal 3",
      timeLim: 1,
      numTasks: 2,
      numRecur: 0,
      progress: 4,
    ),
    Goal(
      name: "goal 4",
      timeLim: 8,
      numTasks: 6,
      numRecur: 3,
      progress: 4,
    ),
    Goal(
      name: "goal 5",
      timeLim: 2,
      numTasks: 6,
      numRecur: 4,
      progress: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: ((context, innerBoxIsScrolled) => [
              SliverAppBar(
                toolbarHeight: MediaQuery.of(context).size.height / 6.0,
                flexibleSpace: const Image(
                  image: NetworkImage(
                      'https://source.unsplash.com/random/600x600?sig=1'),
                  fit: BoxFit.cover,
                ),
                backgroundColor: Colors.transparent,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Transform.translate(
                      offset: const Offset(0, 60.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 20.0),
                            child: PhysicalModel(
                              color: Colors.transparent,
                              shape: BoxShape.circle,
                              elevation: 5,
                              child: Container(
                                width: 150.0,
                                height: 150.0,
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
                            ),
                          ),
                          PhysicalModel(
                            borderRadius: BorderRadius.circular(20.0),
                            elevation: 5,
                            color: Colors.transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.blue,
                              ),
                              height: 50.0,
                              width: 50.0,
                              alignment: Alignment.center,
                              child: Center(
                                child: InkWell(
                                  onTap: () {},
                                  child: const Icon(
                                    Icons.settings,
                                    size: 30.0,
                                  ),
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
            ]),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 75.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10.0, 20.0, 0, 20.0),
                  child: const Text(
                    "Daily tasks",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  height: 150.0,
                  child: ListView.builder(
                    itemCount: tasks.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.blue,
                        ),
                        width: 200.0,
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  tasks[index].name,
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Text(
                                (tasks[index].repeat == "Never")
                                    ? "Not Recurring"
                                    : tasks[index].repeat,
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  indent: 20.0,
                  endIndent: 20.0,
                  color: Colors.black,
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(20.0, 20.0, 0, 10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Goals",
                            style: TextStyle(fontSize: 24),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20.0),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/creategoal');
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 30.0, 0),
                        height: 150.0,
                        width: 400.0,
                        child: ListView.builder(
                          itemCount: goals.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      goals[index].name,
                                      style: const TextStyle(fontSize: 16.0),
                                    ),
                                    Row(
                                      children: List.generate(
                                        5,
                                        (i) {
                                          if (i < goals[index].progress) {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Icon(
                                                Icons.circle,
                                                color: Colors.green[500],
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  right: 5.0),
                                              child: Icon(
                                                Icons.circle_outlined,
                                                color: Colors.green[500],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Divider(
                                  thickness: 1,
                                  color: (index == goals.length - 1)
                                      ? Colors.transparent
                                      : Colors.black,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 1.0,
                  indent: 20.0,
                  endIndent: 20.0,
                  color: Colors.black,
                ),
                ElevatedButton(
                  child: const Text('Signout'),
                  onPressed: () async {
                    await AuthService().signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
