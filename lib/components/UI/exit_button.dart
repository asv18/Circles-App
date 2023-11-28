import 'package:circlesapp/services/component_service.dart';
import 'package:flutter/material.dart';

class ExitButton extends StatelessWidget {
  const ExitButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final Function onPressed;

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
        color: Theme.of(context).primaryColorLight,
      ),
      child: TextButton(
        onPressed: () {
          onPressed();
        },
        child: FittedBox(
          child: Icon(
            icon,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
