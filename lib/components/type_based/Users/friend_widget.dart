import 'package:circlesapp/components/type_based/Users/user_image_widget.dart';
import 'package:circlesapp/routes.dart';
import 'package:circlesapp/services/component_service.dart';
import 'package:circlesapp/services/friend_service.dart';
import 'package:circlesapp/shared/friendship.dart';
import 'package:circlesapp/shared/message.dart';
import 'package:circlesapp/shared/user.dart';
import 'package:circlesapp/variable_screens/messagescreen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FriendWidget extends StatelessWidget {
  const FriendWidget({
    super.key,
    required this.friend,
  });

  final User friend;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Friendship friendship = await FriendService().fetchFriendship(
          friend.fKey!,
        );

        List<Message> messages = await FriendService().fetchMessages(
          friendship.id!,
          BigInt.zero,
        );

        if (mainKeyNav.currentState!.mounted) {
          mainKeyNav.currentState!.push(
            MaterialPageRoute(
              builder: (context) => MessageScreen(
                friend: friend,
                friendship: friendship,
                messages: messages,
              ),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: ComponentService.convertHeight(
            MediaQuery.of(context).size.height,
            10,
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ComponentService.convertWidth(
              MediaQuery.of(context).size.width,
              10,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: ComponentService.convertHeight(
                MediaQuery.of(context).size.height,
                2.5,
              ),
            ),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: UserImageWidget(
                    photoUrl: friend.photoUrl ??
                        'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                    dimensions: ComponentService.convertWidth(
                      MediaQuery.of(context).size.width,
                      55,
                    ),
                    margin: ComponentService.convertWidth(
                      MediaQuery.of(context).size.width,
                      20,
                    ),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${friend.name}",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                      Text(
                        friend.username!,
                        style: TextStyle(
                          fontSize: 1.2.sp,
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
