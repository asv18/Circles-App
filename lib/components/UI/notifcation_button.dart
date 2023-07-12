import 'package:flutter/material.dart';

class NotifButton extends StatelessWidget {
  const NotifButton({
    super.key,
    required this.onPressed,
    required this.contents,
  });

  final Function onPressed;
  final String contents;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 32.0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: const Size.fromHeight(30.0),
          alignment: Alignment.centerLeft,
        ),
        onPressed: () => onPressed(),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            contents,
            style: const TextStyle(color: Colors.white, fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
