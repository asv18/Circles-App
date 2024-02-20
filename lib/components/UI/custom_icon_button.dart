import 'package:circlesapp/services/component_service.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color = const Color.fromARGB(255, 245, 248, 255),
    this.iconColor = Colors.black,
  });

  final IconData icon;
  final Function onPressed;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ComponentService.convertWidth(
        MediaQuery.of(context).size.width,
        40,
      ),
      height: ComponentService.convertWidth(
        MediaQuery.of(context).size.width,
        40,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: color,
      ),
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        child: FittedBox(
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
