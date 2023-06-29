import 'package:flutter/material.dart';

class BottomAppBarButton extends StatelessWidget {
  const BottomAppBarButton({
    super.key,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.icon,
    required this.color,
  });

  final double width;
  final double height;
  final Function onPressed;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: IconButton(
        onPressed: () => onPressed(),
        icon: FittedBox(
          child: Icon(
            icon,
            size: width,
            color: color,
          ),
        ),
      ),
    );
  }
}
