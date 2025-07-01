enum Weekday {
  sunday("SUN", 7),
  monday("MON", 1),
  tuesday("TUE", 2),
  wednesday("WED", 3),
  thursday("THU", 4),
  friday("FRI", 5),
  saturday("SAT", 6);

  final String name;

  final int value;

  const Weekday(this.name, this.value);

  @override
  String toString() {
    return name;
  }

  String toJson() {
    return name;
  }

  factory Weekday.fromJson(String json) =>
      Weekday.values.firstWhere((e) => e.toJson() == json);
}