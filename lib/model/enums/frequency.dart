enum Frequency {
  oneTime("None", "반복 안함"),
  daily("DAILY", "일 반복"),
  weekly("WEEKLY", "주 반복"),
  monthly("MONTHLY", "월 반복"),
  yearly("YEARLY", "년 반복");

  final String name;

  final String title;

  const Frequency(this.name, this.title);

  @override
  String toString() {
    return title;
  }

  String toJson() {
    return name;
  }

  factory Frequency.fromJson(String json) =>
      Frequency.values.firstWhere((e) => e.toJson() == json);
}
