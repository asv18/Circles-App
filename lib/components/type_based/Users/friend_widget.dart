import 'package:circlesapp/components/type_based/Users/circle_image_widget.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:circlesapp/variable_screens/messagescreen.dart';
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  const FriendWidget({
    super.key,
    required this.friend,
  });

  final User friend;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: InkRipple.splashFactory,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MessageScreen(
              friend: friend,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.5),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: CircleImageWidget(
                    photoUrl: friend.photoUrl,
                    dimensions: 55,
                    margin: 20,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${friend.firstName} ${friend.lastName}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        friend.username!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
