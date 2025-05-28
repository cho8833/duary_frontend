import 'package:duary/data/update_member_req.dart';
import 'package:duary/data/update_member_res.dart';

abstract interface class MemberRepository {

  Future<UpdateMemberRes> updateMember(UpdateMemberReq req);
}