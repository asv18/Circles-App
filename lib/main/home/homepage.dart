import 'package:circlesapp/main/circles/circlesdisplay.dart';
import 'package:circlesapp/main/goals/goalsdisplay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'top_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pages = [CirclesDisp(), GoalsDisp()];

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: const Color.fromARGB(255, 145, 220, 255),
        toolbarHeight: MediaQuery.of(context).size.width / 3.5,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _index = 0;
                      });
                    },
                    child: const Text(
                      "Circles",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  thickness: 1.0,
                  indent: 5.0,
                  endIndent: 5.0,
                  color: Colors.black,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _index = 1;
                      });
                    },
                    child: const Text(
                      "Goals",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: _pages[_index],
    );
  }
}
