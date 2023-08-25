import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CircleImageWidget extends StatelessWidget {
  const CircleImageWidget({
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
    return Container(
      width: dimensions,
      height: dimensions,
      margin: EdgeInsets.only(right: margin),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.contain,
          image: CachedNetworkImageProvider(
            photoUrl ??
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
          ),
        ),
      ),
    );
  }
}
