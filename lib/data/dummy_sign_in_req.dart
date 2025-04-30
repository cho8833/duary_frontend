class DummySignInReq {
  int username;

  DummySignInReq(this.username);

  Map<String, int> toJson() =>
      {
        "username": username,
      };
}