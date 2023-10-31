import 'package:circlesapp/components/type_based/Users/user_image_circle_widget.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({
    super.key,
    required this.user,
    required this.onPressed,
  });

  final User user;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: UserImageCircleWidget(
                        photoUrl: user.photoUrl ??
                            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                        dimensions: 25,
                        margin: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${user.name}",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async => onPressed(),
                icon: const Icon(
                  FontAwesome.plus,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
