import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProviderButton extends StatelessWidget {
  // final ImageProvider icon;
  final Function loginMethod;
  final String text;
  final Widget? icon;

  const ProviderButton({
    super.key,
    required this.icon,
    required this.loginMethod,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton.icon(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        onPressed: () => loginMethod(),
        icon: Container(
          child: icon,
        ),
        /**
         * Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: icon,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
         */
        label: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
