class User {
  final String username;
  final String password;
  final String imagen_user;

  User(
      {required this.username,
      required this.password,
      required this.imagen_user});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        username: json['username'],
        password: json['password'],
        imagen_user: json['imagen_user']);
  }
}
