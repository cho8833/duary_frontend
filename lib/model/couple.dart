import 'package:duary/model/member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'couple.g.dart';

@JsonSerializable()
class Couple {
  DateTime relationDate;

  List<Member> members;

  late Member me;

  late Member lover;

  Couple(this.relationDate, this.members);
}