import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserImageWidget extends StatelessWidget {
  const UserImageWidget({
    super.key,
    this.photoUrl,
    this.imgSrc,
    required this.dimensions,
    this.margin = 0,
    this.useCachedNetwork = true,
  });

  final String? photoUrl;
  final File? imgSrc;
  final double dimensions;
  final double margin;
  final bool useCachedNetwork;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dimensions,
      height: dimensions,
      margin: EdgeInsets.only(left: margin),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.amber,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: (useCachedNetwork
              ? CachedNetworkImageProvider(
                  photoUrl!,
                )
              : FileImage(
                  imgSrc!,
                )) as ImageProvider,
        ),
      ),
    );
  }
}
