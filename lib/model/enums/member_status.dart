enum MemberStatus {
  solo("SOLO", "솔로"),
  couple("COUPLE", "커플");

  final String name;

  final String title;

  const MemberStatus(this.name, this.title);

  @override
  String toString() {
    return title;
  }

  String toJson() {
    return name;
  }

  factory MemberStatus.fromJson(String json) {
    return MemberStatus.values.firstWhere((element) => element.toJson() == json);
  }
}