import 'package:circlesapp/services/component_service.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CreateButton extends StatelessWidget {
  const CreateButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: ComponentService.convertWidth(
        MediaQuery.of(context).size.width,
        40,
      ),
      child: TextButton(
        onPressed: () => onPressed(),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).primaryColor,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Bootstrap.plus,
              color: Colors.white,
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
