class User {
  String? id;
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? photoUrl;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.photoUrl,
  });

  User.skeleton({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.photoUrl,
  });

  User.empty();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["data"]["id"] as String,
      firstName: json["data"]["first_name"] as String,
      lastName: json["data"]["last_name"] as String,
      username: json["data"]["username"] as String,
      email: json["data"]["email"] as String,
      photoUrl: json["data"]["photo_url"],
    );
  }

  factory User.fromSkeletonJson(Map<String, dynamic> json) {
    return User.skeleton(
      firstName: json["first_name"] as String,
      lastName: json["last_name"] as String,
      username: json["username"] as String,
      photoUrl: json["data"]["photo_url"],
    );
  }

  @override
  String toString() {
    return "hmm";
  }
}
