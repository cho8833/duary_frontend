enum Weekday {
  sunday("SUN", "일", 0),
  monday("MON", "월", 1),
  tuesday("TUE", "화", 2),
  wednesday("WED", "수", 3),
  thursday("THU", "목", 4),
  friday("FRI", "금", 5),
  saturday("SAT", "토", 6);

  final String name;

  final String title;

  final int value;

  const Weekday(this.name, this.title, this.value);

  @override
  String toString() {
    return title;
  }

  String toJson() {
    return name;
  }

  factory Weekday.fromJson(String json) =>
      Weekday.values.firstWhere((e) => e.toJson() == json);
}