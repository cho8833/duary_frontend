class DummySignInReq {
  String username;

  DummySignInReq(this.username);

  Map<String, String> toJson() =>
      {
        "username": username,
      };
}