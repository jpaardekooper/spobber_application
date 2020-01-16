class User {
  final String username;
  final String password;
  final String email;

  User({
    this.username,
    this.password,
    this.email,
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'email': email,
      };
}
