import 'dart:io';
import 'package:cloudinary/cloudinary.dart';
import 'package:uuid/uuid.dart';

class APIServices {
  final _cloudinary = Cloudinary.unsignedConfig(
    cloudName: 'dnsh86z2c',
  );

  Future<String?> uploadImage(File imageSrc) async {
    const uuid = Uuid();

    final response = await _cloudinary.unsignedUpload(
      file: imageSrc.path,
      uploadPreset: "unnvggvo",
      fileBytes: imageSrc.readAsBytesSync(),
      resourceType: CloudinaryResourceType.image,
      folder: "public",
      fileName: uuid.v1(),
    );

    if (response.statusCode == 200) {
      return response.url!;
    }

    return null;
  }
}
