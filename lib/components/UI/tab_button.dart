import 'package:circlesapp/services/component_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabButton extends StatelessWidget {
  const TabButton({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ComponentService.convertWidth(
          MediaQuery.of(context).size.width,
          20,
        ),
        vertical: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          5,
        ),
      ),
      child: Text(
        name,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
