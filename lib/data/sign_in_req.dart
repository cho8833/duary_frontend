class SignInReq {
  String username;
  String password;

  SignInReq(this.username, this.password);

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password
    };
  }
}