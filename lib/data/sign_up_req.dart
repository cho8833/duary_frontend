class SignUpReq {
  String username;
  String password;

  SignUpReq(this.username, this.password);

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password
  };
}