import 'package:duary/base/server_response.dart';
import 'package:duary/data/page_req.dart';
import 'package:duary/model/enums/role.dart';
import 'package:duary/model/member.dart';

abstract interface class MemberRepository {
  Future<PagedData<Member>> getList(PageReq req);

  Future<void> updateRole(int id, Role role);
}