enum Frequency {
  oneTime("None", "반복 안함"),
  daily("DAILY", "매일"),
  weekly("WEEKLY", "매주"),
  monthly("MONTHLY", "매월"),
  yearly("YEARLY", "매년");

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
