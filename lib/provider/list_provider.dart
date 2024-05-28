import 'package:flutter/cupertino.dart';
import 'package:duary/base/server_response.dart';
import 'package:status_builder/status_builder.dart';

abstract class ListProvider<M> {

  // 선택된 Data 저장
  List<M> dataList = [];

  String? listErrorMessage;

  ValueNotifier<Status> listStatusNotifier = ValueNotifier(Status.success);

  Future<void> getList();
}

mixin PageMixin<M> on ListProvider<M> {
  // 현재 페이지 ( 10개 단위 )
  int page = 0;

  // 총 데이터 개수
  int total = 0;

  int totalPages = 1;

  // navigation bar 의 page
  int navPage = 1;

  int pageSize = 10;

  void parsePagedData(PagedData<M> pagedData) {
    dataList = pagedData.content;
    page = pagedData.pageable.pageNumber;
    pageSize = pagedData.pageable.pageSize;
    total = pagedData.totalElements;
    totalPages = pagedData.totalPages;
  }

  void setPage(int page) {
    this.page = page;
    getList();
  }

  void setNavPage(int navPage) {
    this.navPage = navPage;
  }
}