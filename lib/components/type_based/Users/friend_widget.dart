import 'package:circlesapp/components/type_based/Users/circle_image_widget.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:flutter/material.dart';

class FriendWidget extends StatelessWidget {
  const FriendWidget({
    super.key,
    required this.friend,
  });

  final User friend;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      height: 50,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            CircleImageWidget(
              photoUrl: friend.photoUrl,
              dimensions: 50,
              margin: 30,
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
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
    );
  }
}
