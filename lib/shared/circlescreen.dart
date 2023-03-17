import 'package:circlesapp/shared/circle.dart';
import 'package:flutter/material.dart';

class CircleScreen extends StatefulWidget {
  CircleScreen({
    super.key,
    required this.circle,
  });

  Circle circle;

  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: (MediaQuery.of(context).size.height / 4.6),
        elevation: 2,
        backgroundColor: Colors.transparent,
        flexibleSpace: Hero(
          tag: widget.circle.name,
          child: Image(
            image: NetworkImage(widget.circle.image),
            fit: BoxFit.cover,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20.0),
          child: Text("${widget.circle.name}!!"),
        ),
      ),
    );
  }
}
