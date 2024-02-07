import 'package:circlesapp/services/component_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.loginFunction,
    required this.text,
  });

  final String text;
  final Function loginFunction;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: ComponentService.convertWidth(
          MediaQuery.of(context).size.width,
          40,
        ),
      ),
      child: ElevatedButton(
        onPressed: () => loginFunction(),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: ComponentService.convertWidth(
                    MediaQuery.of(context).size.width,
                    30,
                  ),
                  height: ComponentService.convertWidth(
                    MediaQuery.of(context).size.width,
                    30,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  child: Icon(
                    FontAwesome.arrow_right_solid,
                    size: 13,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
