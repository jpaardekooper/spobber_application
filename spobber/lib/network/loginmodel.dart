class LoginModel {
  final String username;
  final String token;

  LoginModel({
    this.username,
    this.token,
  });

  LoginModel fromJson(Map<String, dynamic> json) {
    return LoginModel(
        username: json['username'],
        token: json['token']);
  }
}
