import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  const FormTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.suffixIcon,
    required this.onChanged,
    this.visibility = true,
  });

  final TextEditingController controller;
  final bool visibility;
  final String hintText;
  final Widget? suffixIcon;
  final Function validator;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(
          4.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        keyboardType: (hintText == "Phone Number") ? TextInputType.phone : null,
        onChanged: (value) => onChanged(),
        controller: controller,
        obscureText: visibility,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(
            hintText,
          ),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 25,
            horizontal: 20,
          ),
        ),
        validator: (value) => validator(value),
      ),
    );
  }
}
