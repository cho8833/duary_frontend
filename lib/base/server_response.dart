import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'server_response.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class ServerResponse<T> {
  String? message;
  int status;
  String? code;
  T data;
  bool error;

  ServerResponse(
      {required this.message,
      required this.status,
      this.code,
      required this.data,
      required this.error});

  factory ServerResponse.fromResponse(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return ServerResponse(
      message: json['message'] as String?,
      status: json['status'] as int,
      code: json['code'] as String?,
      data: fromJson(json['data']),
      error: json['error'] as bool,
    );
  }
}

class ServerPagedResponse<T> extends ServerResponse<PagedData<T>> {
  ServerPagedResponse(
      {required super.message,
      required super.status,
      super.code,
      required super.error,
      required super.data});

  factory ServerPagedResponse.fromResponse(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    PagedData<T> data = PagedData.fromJson(json['data'], fromJson);
    return ServerPagedResponse(
        message: json['message'] as String?,
        status: json['status'] as int,
        error: json['error'] as bool,
        code: json['code'] as String?,
        data: data);
  }
}

@JsonSerializable(createToJson: false, genericArgumentFactories: true)
class PagedData<T> {
  List<T> content;
  Pageable pageable;
  bool? last;
  int totalPages;
  int totalElements;
  bool? first;
  int? size;
  int? number;
  Sort? sort;
  int? numberOfElements;
  bool? empty;

  PagedData(this.content, this.pageable, this.totalElements, this.totalPages,
      {this.last,
      this.first,
      this.size,
      this.number,
      this.sort,
      this.numberOfElements,
      this.empty});

  factory PagedData.fromJson(
          Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    parseFromJson(object) {
      return fromJson(object as Map<String, dynamic>);
    }
    return _$PagedDataFromJson(json, parseFromJson);
  }
}

@JsonSerializable(createToJson: false)
class Pageable {
  int pageNumber;
  int pageSize;
  Sort? sort;
  int? offset;
  bool? paged;
  bool? unpaged;

  Pageable(this.pageNumber, this.pageSize,
      {this.sort, this.offset, this.paged, this.unpaged});

  factory Pageable.fromJson(Map<String, dynamic> json) =>
      _$PageableFromJson(json);
}

@JsonSerializable(createToJson: false)
class Sort {
  bool? empty;
  bool? unsorted;
  bool? sorted;

  Sort({this.empty, this.unsorted, this.sorted});

  factory Sort.fromJson(Map<String, dynamic> json) => _$SortFromJson(json);
}
