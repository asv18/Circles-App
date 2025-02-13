import 'package:circlesapp/services/component_service.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.onTap,
    this.readOnly,
    this.suffixIcon,
    this.onChanged,
  });

  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final Function? onTap;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ComponentService.convertWidth(
        MediaQuery.of(context).size.width,
        80,
      ),
      padding: EdgeInsets.symmetric(
        vertical: ComponentService.convertHeight(
          MediaQuery.of(context).size.height,
          16,
        ),
        horizontal: ComponentService.convertWidth(
          MediaQuery.of(context).size.width,
          16,
        ),
      ),
      decoration: ShapeDecoration(
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  labelText,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                TextFormField(
                  style: Theme.of(context).textTheme.titleMedium,
                  cursorColor: Colors.black,
                  keyboardType:
                      (hintText == "Phone Number") ? TextInputType.phone : null,
                  onTap: () {
                    if (onTap != null) {
                      onTap!();
                    }
                  },
                  scrollPadding: const EdgeInsets.all(0),
                  controller: controller,
                  readOnly: readOnly ?? false,
                  decoration: InputDecoration(
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                    isDense: true,
                    filled: false,
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorLight,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorLight,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorLight,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorLight,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    hintText: hintText,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  onChanged: (value) {
                    if (onChanged != null) {
                      onChanged!(value);
                    }
                  },
                ),
              ],
            ),
          ),
          suffixIcon ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
