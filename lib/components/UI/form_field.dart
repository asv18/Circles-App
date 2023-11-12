import 'package:circlesapp/services/component_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.suffixIcon,
    this.prefixIcon,
    required this.onChanged,
    this.visibility = true,
  });

  final TextEditingController controller;
  final bool visibility;
  final String hintText;
  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final Function validator;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      keyboardType: (hintText == "Phone Number") ? TextInputType.phone : null,
      onChanged: (value) => onChanged(),
      controller: controller,
      obscureText: visibility,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).primaryColorLight,
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 218, 229, 255),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        iconColor: Theme.of(context).primaryColor,
        label: Text(
          hintText,
          style: GoogleFonts.poppins(),
        ),
        floatingLabelStyle: GoogleFonts.poppins(
          color: Theme.of(context).primaryColor,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).primaryColor,
          size: 22,
        ),
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.symmetric(
          vertical: ComponentService.convertHeight(
            MediaQuery.of(context).size.height,
            20,
          ),
          horizontal: ComponentService.convertWidth(
            MediaQuery.of(context).size.width,
            20,
          ),
        ),
      ),
      validator: (value) => validator(value),
    );
  }
}
