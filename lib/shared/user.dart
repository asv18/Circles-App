class User {
  final String id;
  final String firstName;
  final String lastName;
  final String username;

  const User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.username});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["data"]["id"] as String,
      firstName: json["data"]["first_name"] as String,
      lastName: json["data"]["last_name"] as String,
      username: json["data"]["username"] as String,
    );
  }
}
