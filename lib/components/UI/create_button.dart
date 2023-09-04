import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class CreateButton extends StatelessWidget {
  const CreateButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: TextButton(
        onPressed: () => onPressed(),
        style: ButtonStyle(
          // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          //   const EdgeInsets.symmetric(
          //     horizontal: 40,
          //     vertical: 10,
          //   ),
          // ),
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
