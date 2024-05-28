import 'package:flutter/cupertino.dart';
import 'package:duary/data/page_req.dart';
import 'package:duary/model/enums/role.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/list_provider.dart';
import 'package:duary/repository/member_repository.dart';
import 'package:status_builder/status_builder.dart';

class MemberProvider extends ListProvider<Member> with PageMixin {
  final MemberRepository _repository;

  MemberProvider(this._repository);

  static const int _pageSize = 10;

  ValueNotifier<Status> updateRoleStatusNotifier = ValueNotifier(Status.idle);

  @override
  Future<void> getList() async {
    listStatusNotifier.value = Status.loading;
    pageSize = _pageSize;
    PageReq req = PageReq(page, pageSize);
    await _repository.getList(req).then((value) {
      parsePagedData(value);
      listStatusNotifier.value = Status.success;
    }).catchError((e) {
      listErrorMessage = e.toString();
      listStatusNotifier.value = Status.fail;
    });
  }

  Future<void> updateRole(Member member, Role role) async {
    updateRoleStatusNotifier.value = Status.loading;
    await _repository.updateRole(member.id, role).then((_) {
      updateRoleStatusNotifier.value = Status.success;
    }).catchError((e) {
      updateRoleStatusNotifier.value = Status.fail;
    });
  }
}
