import 'package:duary/model/couple.dart';
import 'package:duary/model/member.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lover_updated_data.g.dart';

@JsonSerializable(createToJson: false)
class LoverUpdatedData {
  Member member;
  Couple couple;

  LoverUpdatedData(this.member, this.couple);

  factory LoverUpdatedData.fromJson(Map<String, dynamic> json) => _$LoverUpdatedDataFromJson(json);
}