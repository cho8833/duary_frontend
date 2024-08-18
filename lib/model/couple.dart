import 'package:duary/model/member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'couple.g.dart';

@JsonSerializable()
class Couple {
  DateTime relationDate;

  Member me;
  Member lover;

  Couple(this.relationDate, this.me, this.lover);
}