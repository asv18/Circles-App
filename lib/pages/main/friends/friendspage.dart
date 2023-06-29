import 'package:circlesapp/components/search_appbar.dart';
import 'package:circlesapp/services/data_service.dart';
import 'package:flutter/material.dart';

import '../../../shared/user.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late Future<List<User>> potentialFriends;

  @override
  void initState() {
    super.initState();

    potentialFriends = DataService().fetchUserSkeletons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        title: SearchAppBar(
          onChanged: (value) {},
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<List<User>>(
              future: potentialFriends,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Text("ERROR!!!!!");
                } else if (snapshot.hasData) {
                  List<User> users = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Text("dan,.. ${users[index].firstName}");
                    },
                  );
                }

                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
