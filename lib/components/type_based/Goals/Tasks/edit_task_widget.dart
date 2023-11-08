import 'package:circlesapp/shared/task.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class EditTaskWidget extends StatefulWidget {
  const EditTaskWidget({
    super.key,
    required this.task,
    required this.onChangedDropdown,
    required this.onChangedName,
  });

  final Task task;

  final Function onChangedDropdown;
  final Function onChangedName;

  @override
  State<EditTaskWidget> createState() => _EditTaskWidgetState();
}

class _EditTaskWidgetState extends State<EditTaskWidget> {
  late List<String> spinnerItems;

  @override
  void initState() {
    super.initState();

    spinnerItems = [
      "Never",
      "Daily",
      "Weekly",
      "Monthly",
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      height: 105.0,
      child: Material(
        color: Theme.of(context).primaryColorLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Theme.of(context).primaryColorDark),
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
                      hintText: "Think about a milestone you can check off...",
                      initialText: widget.task.name,
                      onChanged: (value) => widget.onChangedName(value),
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
                            onChanged: (value) =>
                                widget.onChangedDropdown(value),
                            items: spinnerItems.map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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
    );
  }
}

class CustomTextField2 extends StatelessWidget {
  const CustomTextField2({
    super.key,
    required this.hintText,
    required this.initialText,
    this.onTap,
    this.readOnly,
    this.suffixIcon,
    this.onChanged,
  });

  final String hintText;
  final String initialText;
  final Function? onTap;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      initialValue: initialText,
      scrollPadding: const EdgeInsets.all(0),
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        isDense: true,
        filled: false,
        iconColor: Theme.of(context).primaryColorLight,
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
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
