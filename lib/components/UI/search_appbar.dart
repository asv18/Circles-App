import 'package:flutter/material.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    Key? key,
    required this.controller,
    required this.onChanged,
  }) : super(key: key);

  final TextEditingController controller;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(12, 26),
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0.0,
            horizontal: 20.0,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2.0),
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
        ),
        onChanged: (value) => onChanged(value),
      ),
    );
  }
}
