class User {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  bool exists = false;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
  });

  User.newUser({
    required this.exists,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["data"]["id"] as String,
      firstName: json["data"]["first_name"] as String,
      lastName: json["data"]["last_name"] as String,
      username: json["data"]["username"] as String,
      email: json["data"]["email"] as String,
    );
  }
}
