import 'package:circlesapp/services/component_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
            EdgeInsets.symmetric(
              horizontal: ComponentService.convertWidth(
                MediaQuery.of(context).size.width,
                10,
              ),
              vertical: ComponentService.convertHeight(
                MediaQuery.of(context).size.height,
                10,
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            Theme.of(context).canvasColor,
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
        label: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
