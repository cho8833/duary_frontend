enum Role {

  user("USER", "유저"),
  admin("ADMIN", "관리자");

  final String name;

  final String title;

  const Role(this.name, this.title);

  @override
  String toString() {
    return title;
  }

  String toJson() {
    return name;
  }

  factory Role.fromJson(String json) {
    return Role.values.firstWhere((element) => element.toJson() == json);
  }
}