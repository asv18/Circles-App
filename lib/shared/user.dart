import 'dart:convert';

import 'package:circlesapp/services/user_service.dart';

class User {
  String? id;
  String? name;
  String? username;
  String? email;
  String? photoUrl;
  String? fKey;
  String? phoneNumber;
  bool exists = true;

  User({
    this.id,
    this.name,
    this.username,
    this.email,
    this.photoUrl,
    this.fKey,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as String,
      name: json["name"] as String,
      username: json["username"] as String,
      email: json["email"] as String,
      photoUrl: (json["photo_url"] == "null") ? null : json["photo_url"],
      fKey: json["user_foreign_key"] as String,
      phoneNumber: json["phone_number"],
    );
  }

  factory User.fromSkeletonJson(Map<String, dynamic> json) {
    return User(
      name: json["name"] as String,
      username: json["username"] as String,
      photoUrl: (json["photo_url"] == "null") ? null : json["photo_url"],
      fKey: (json["user_foreign_key"] ??
          (((json["user1"] as String) == UserService.dataUser.fKey)
              ? json["user2"]
              : json["user1"])) as String,
    );
  }

  factory User.fromSkeletonJsonAdmin(Map<String, dynamic> json) {
    return User(
      name: json["name"] as String,
      username: json["username"] as String,
      photoUrl: (json["photo_url"] == "null") ? null : json["photo_url"],
      fKey: json["user_foreign_key"],
    );
  }

  User.empty() {
    id = null;
    name = null;
    username = null;
    email = null;
    photoUrl = null;
    fKey = null;
    phoneNumber = null;
    exists = true;
  }

  @override
  String toString() {
    return jsonEncode({
      "username": username,
      "name": name,
      "email": email,
      "photo_url": photoUrl,
      "phone_number": phoneNumber,
    });
  }
}
