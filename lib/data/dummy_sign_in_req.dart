class DummySignInReq {
  String username;
  String? fcmToken;

  DummySignInReq(this.username, {this.fcmToken});

  Map<String, dynamic> toJson() =>
      {
        "username": username,
        "fcmToken": fcmToken,
      };
}