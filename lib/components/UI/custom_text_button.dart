import 'package:circlesapp/services/component_service.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key, required this.text, required this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await onPressed();
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
            horizontal: ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              40,
            ),
            vertical: ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              10,
            ),
          ),
        ),
        textStyle: MaterialStateProperty.all<TextStyle>(
          Theme.of(context).textTheme.titleSmall!,
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).primaryColor,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60.0),
          ),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
