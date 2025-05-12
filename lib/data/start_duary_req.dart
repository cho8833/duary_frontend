import 'package:duary/model/enums/character.dart';

class StartDuaryReq {
  String name;
  DateTime birthday;
  DateTime relationDate;
  Character myCharacter;

  StartDuaryReq(this.name, this.birthday, this.relationDate, this.myCharacter);

  Map<String, dynamic> toJson() => {
        "name": name,
        "birthday": birthday.toUtc().toIso8601String(),
        "relationDate": relationDate.toUtc().toIso8601String(),
        "myCharacter": myCharacter,
      };
}
