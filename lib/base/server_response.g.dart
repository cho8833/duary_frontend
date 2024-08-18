// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerResponse<T> _$ServerResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    ServerResponse<T>(
      message: json['message'] as String?,
      status: (json['status'] as num).toInt(),
      code: json['code'] as String?,
      data: fromJsonT(json['data']),
      error: json['error'] as bool,
    );

PagedData<T> _$PagedDataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    PagedData<T>(
      (json['content'] as List<dynamic>).map(fromJsonT).toList(),
      Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
      (json['totalElements'] as num).toInt(),
      (json['totalPages'] as num).toInt(),
      last: json['last'] as bool?,
      first: json['first'] as bool?,
      size: (json['size'] as num?)?.toInt(),
      number: (json['number'] as num?)?.toInt(),
      sort: json['sort'] == null
          ? null
          : Sort.fromJson(json['sort'] as Map<String, dynamic>),
      numberOfElements: (json['numberOfElements'] as num?)?.toInt(),
      empty: json['empty'] as bool?,
    );

Pageable _$PageableFromJson(Map<String, dynamic> json) => Pageable(
      (json['pageNumber'] as num).toInt(),
      (json['pageSize'] as num).toInt(),
      sort: json['sort'] == null
          ? null
          : Sort.fromJson(json['sort'] as Map<String, dynamic>),
      offset: (json['offset'] as num?)?.toInt(),
      paged: json['paged'] as bool?,
      unpaged: json['unpaged'] as bool?,
    );

Sort _$SortFromJson(Map<String, dynamic> json) => Sort(
      empty: json['empty'] as bool?,
      unsorted: json['unsorted'] as bool?,
      sorted: json['sorted'] as bool?,
    );
