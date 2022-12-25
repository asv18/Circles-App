import 'package:circlesapp/main/home/circles/circlesdisplay.dart';
import 'package:circlesapp/main/home/goals/goalsdisplay.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 120.0,
              height: 120.0,
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Top Text",
                    style: TextStyle(fontSize: 30.0),
                  ),
                  Container(
                    width: double.infinity,
                    height: 32.0,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(30.0),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Stuff",
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        minimumSize: const Size.fromHeight(30.0),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {},
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Stuff",
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        elevation: 2,
        backgroundColor: const Color.fromARGB(255, 145, 220, 255),
        toolbarHeight: MediaQuery.of(context).size.height / 6.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _controller.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
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
                  indent: 8.0,
                  endIndent: 8.0,
                  color: Colors.black87,
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _controller.animateToPage(1,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut);
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
      body: PageView(
        controller: _controller,
        children: [CirclesDisp(), GoalsDisp()],
      ),
    );
  }
}
