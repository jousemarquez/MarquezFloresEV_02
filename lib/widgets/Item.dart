class User {
  final String username;
  final String password;
  final String userImage;

  User(
      {required this.username,
      required this.password,
      required this.userImage});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'],
        password: json['password'],
        userImage: json['userImage']);
  }
}
