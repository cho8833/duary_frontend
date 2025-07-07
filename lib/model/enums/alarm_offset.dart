enum AlarmOffset {
  none("NONE", "없음"),
  atTime("AT_TIME", "일정 시간에"),
  min5("MINUTE_5", "5분 전"),
  min10("MINUTE_10", "10분 전"),
  min15("MINUTE_15", "15분 전"),
  min30("MINUTE_30", "30분 전"),
  hour1("HOUR_1", "1시간 전");

  final String title;

  final String name;

  const AlarmOffset(this.name, this.title);

  @override
  String toString() {
    return title;
  }

  String toJson() {
    return name;
  }

  factory AlarmOffset.fromJson(String json) => AlarmOffset.values.firstWhere((element) => element.toJson() == json);

}