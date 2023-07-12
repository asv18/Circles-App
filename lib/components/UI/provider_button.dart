import 'package:flutter/material.dart';

class ProviderButton extends StatelessWidget {
  final Color backgroundColor;
  final ImageProvider icon;
  final Function loginMethod;

  const ProviderButton({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.loginMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      width: 50,
      height: 50,
      alignment: Alignment.center,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: icon,
            fit: BoxFit.fitHeight,
          ),
        ),
        child: InkWell(
          onTap: () => loginMethod(),
        ),
      ),
    );
  }
}
