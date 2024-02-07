import 'package:circlesapp/services/component_service.dart';
import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(
              ComponentService.convertWidth(
                MediaQuery.of(context).size.width,
                12,
              ),
              ComponentService.convertHeight(
                MediaQuery.of(context).size.height,
                26,
              ),
            ),
            blurRadius: 50,
            spreadRadius: 0,
            color: Colors.grey.withOpacity(.1),
          ),
        ],
      ),
      child: TextField(
        cursorColor: Colors.black,
        controller: controller,
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          isDense: true,
          prefixIcon: Icon(
            Icons.search,
            size: 20,
            color: Theme.of(context).primaryColorDark,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          hintText: 'Search...',
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(.75),
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              20,
            ),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).canvasColor, width: 1.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).canvasColor, width: 2.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
        onChanged: (value) => onChanged(value),
      ),
    );
  }
}
