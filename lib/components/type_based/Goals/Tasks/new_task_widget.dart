import 'package:circlesapp/shared/task.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class NewTaskWidget extends StatefulWidget {
  const NewTaskWidget({
    super.key,
    required this.task,
    required this.onDismissed,
  });

  final Task task;
  final Function onDismissed;

  @override
  State<NewTaskWidget> createState() => _NewTaskWidgetState();
}

class _NewTaskWidgetState extends State<NewTaskWidget> {
  List<String> spinnerItems = [
    "Never",
    "Daily",
    "Weekly",
    "Monthly",
  ];

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<Task>(widget.task),
      onDismissed: (direction) {
        widget.onDismissed(direction);
      },
      background: Container(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 50.0,
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 50.0,
          ),
          child: const Icon(
            Icons.delete,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            side: BorderSide(color: Theme.of(context).primaryColorDark),
          ),
          child: Container(
            height: 105.0,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField2(
                          hintText:
                              "Think about a milestone you can check off...",
                          onChanged: (value) {
                            setState(() {
                              widget.task.name = value;
                            });
                          },
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Repeats: ",
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 5,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButton<String>(
                                value: widget.task.repeat,
                                padding: const EdgeInsets.all(0),
                                isDense: true,
                                underline: const SizedBox.shrink(),
                                icon: const Icon(
                                  IonIcons.caret_down,
                                  color: Colors.black,
                                  size: 15,
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    widget.task.repeat = value!;
                                  });
                                },
                                items:
                                    spinnerItems.map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField2 extends StatelessWidget {
  const CustomTextField2({
    super.key,
    required this.hintText,
    this.controller,
    this.onTap,
    this.readOnly,
    this.suffixIcon,
    this.onChanged,
  });

  final String hintText;
  final TextEditingController? controller;
  final Function? onTap;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      keyboardType: (hintText == "Phone Number") ? TextInputType.phone : null,
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      scrollPadding: const EdgeInsets.all(0),
      controller: controller,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        isDense: true,
        filled: false,
        iconColor: Theme.of(context).primaryColorLight,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodySmall,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.all(0),
      ),
      onChanged: (value) {
        if (onChanged != null) {
          onChanged!(value);
        }
      },
    );
  }
}
