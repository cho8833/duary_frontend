enum RepeatFrequency {
  daily("DAILY", "날마다"),
  weekly("WEEKLY", "주마다"),
  monthly("MONTHLY", "달마다"),
  yearly("YEARLY", "년마다");

  final String name;

  final String title;

  const RepeatFrequency(this.name, this.title);

  @override
  String toString() {
    return title;
  }

  String toJson() {
    return name;
  }

  factory RepeatFrequency.fromJson(String json) {
    return RepeatFrequency.values.firstWhere((element) => element.toJson() == json);
  }
}