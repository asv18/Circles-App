import 'package:circlesapp/services/component_service.dart';
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
      height: ComponentService.convertHeight(
        MediaQuery.of(context).size.height,
        32,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          minimumSize: Size.fromHeight(
            ComponentService.convertHeight(
              MediaQuery.of(context).size.height,
              30,
            ),
          ),
          alignment: Alignment.centerLeft,
        ),
        onPressed: () => onPressed(),
        child: Padding(
          padding: EdgeInsets.only(
            left: ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              8,
            ),
          ),
          child: Text(
            contents,
            style: const TextStyle(color: Colors.white, fontSize: 14.0),
          ),
        ),
      ),
    );
  }
}
