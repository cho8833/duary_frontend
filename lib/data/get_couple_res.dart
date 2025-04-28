import 'package:duary/model/couple.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_couple_res.g.dart';


@JsonSerializable()
class GetCoupleRes {
  Couple couple;

  GetCoupleRes(this.couple);

  factory GetCoupleRes.fromJson(Map<String, dynamic> json) => _$GetCoupleResFromJson(json);
}