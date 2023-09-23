import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserImageCircleWidget extends StatelessWidget {
  const UserImageCircleWidget({
    super.key,
    required this.photoUrl,
    required this.dimensions,
    this.margin = 0,
  });

  final String? photoUrl;
  final double dimensions;
  final double margin;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: dimensions,
      backgroundImage: CachedNetworkImageProvider(
        photoUrl ??
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
      ),
    );
  }
}
