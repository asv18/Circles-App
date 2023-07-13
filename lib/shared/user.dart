import 'dart:convert';

import 'package:circlesapp/services/user_service.dart';

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? photoUrl;
  String? fKey;
  String? phoneNumber;
  bool exists = true;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.photoUrl,
    this.fKey,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as String,
      firstName: json["first_name"] as String,
      lastName: json["last_name"] as String,
      username: json["username"] as String,
      email: json["email"] as String,
      photoUrl: (json["photo_url"] == "null") ? null : json["photo_url"],
      fKey: json["user_foreign_key"] as String,
      phoneNumber: json["phone_number"],
    );
  }

  factory User.fromSkeletonJson(Map<String, dynamic> json) {
    return User(
      firstName: json["first_name"] as String,
      lastName: json["last_name"] as String,
      username: json["username"] as String,
      photoUrl: (json["photo_url"] == "null") ? null : json["photo_url"],
      email: json["email"] as String,
      fKey: (json["user_foreign_key"] ??
          (((json["user1"] as String) == UserService.dataUser.fKey)
              ? json["user2"]
              : json["user1"])) as String,
    );
  }

  @override
  String toString() {
    return jsonEncode({
      "username": username,
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "photo_url": photoUrl,
      "phone_number": phoneNumber,
    });
  }
}
