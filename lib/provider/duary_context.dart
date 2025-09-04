import 'package:duary/data/duary_info_res.dart';
import 'package:duary/data/start_duary_req.dart';
import 'package:duary/data/input_couple_code_req.dart';
import 'package:duary/data/update_couple_req.dart';
import 'package:duary/data/update_member_req.dart';
import 'package:duary/model/couple.dart';
import 'package:duary/model/enums/alarm_offset.dart';
import 'package:duary/model/enums/character.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/token_provider.dart';
import 'package:duary/repository/impl/websocket_handler.dart';
import 'package:duary/repository/auth_repository.dart';
import 'package:duary/repository/couple_repository.dart';
import 'package:duary/repository/member_repository.dart';
import 'package:duary/support/custom_exception.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DuaryContext {
  // singleton
  static final DuaryContext _instance = DuaryContext._internal();
  factory DuaryContext() => _instance;
  DuaryContext._internal();

  late final CoupleRepository _coupleRepository;

  late final AuthRepository authRepository;

  late final MemberRepository _memberRepository;

  final WebSocketHandler wsHandler = WebSocketHandler();

  void init(CoupleRepository coupleRepository, AuthRepository ar,
      MemberRepository memberRepository) {
    _coupleRepository = coupleRepository;
    authRepository = ar;
    _memberRepository = memberRepository;

    wsHandler.duaryInfoNotifier.addListener(_coupleConnectionListener);

    wsHandler.loverUpdateNotifier.addListener(() {
      final data = wsHandler.loverUpdateNotifier.value;
      if (data != null) {
        lover.value = data.member;
        myCouple.value = data.couple;
      }
    });
  }

  final TokenProvider tokenProvider = TokenProvider();

  ValueNotifier<Couple?> myCouple = ValueNotifier(null);

  ValueNotifier<Member?> me = ValueNotifier(null);

  ValueNotifier<Member?> lover = ValueNotifier(null);

  void refreshDuaryInfo(DuaryInfoRes res) {
    wsHandler.connect();
    me.value = res.member;
    myCouple.value = res.couple;
    if (res.couple != null) {
      lover.value = getLoverFromCouple(res.couple!);
    }
  }

  Future<void> startDuary(
    String? name,
    DateTime? birthday,
    DateTime? relationDate,
    Character myCharacter,
  ) async {
    validateName(name);
    validateBirthday(birthday);
    validateRelationDate(relationDate);
    DateTime? birthdayReq;
    if (birthday != null) {
      birthdayReq =
          DateTime(birthday.year, birthday.month, birthday.day);
    }
    DateTime? relationDateReq;
    if (relationDate != null) {
      relationDateReq =
          DateTime(relationDate.year, relationDate.month, relationDate.day);
    }
    StartDuaryReq req =
        StartDuaryReq(name!, birthdayReq, relationDateReq, myCharacter);
    await _coupleRepository.startDuary(req).then((res) {
      refreshDuaryInfo(res);
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> inputCoupleCode(String coupleCode) async {
    InputCoupleCodeReq req = InputCoupleCodeReq(coupleCode);
    await _coupleRepository.inputCoupleCode(req).then((res) {
      refreshDuaryInfo(res);
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> disconnectCouple() async {
    await _coupleRepository.disconnectCouple().then((res) {
      me.value = res.member;
      myCouple.value = null;
      lover.value = null;
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  void _coupleConnectionListener() {
    final duaryInfo = wsHandler.duaryInfoNotifier.value;
    if (duaryInfo != null) {
      me.value = duaryInfo.member;
      myCouple.value = duaryInfo.couple;
      if (duaryInfo.couple != null) {
        lover.value = getLoverFromCouple(duaryInfo.couple!);
      } else {
        lover.value = null;
      }
      Fluttertoast.showToast(msg: "연결되었습니다");
    }
  }

  bool isLoggedIn() {
    return me.value != null;
  }

  bool isCoupleCreated() {
    return me.value != null && me.value!.coupleId != null;
  }

  bool isCoupleConnected() {
    return lover.value != null;
  }

  Member? getLoverFromCouple(Couple couple) {
    Member? lover;
    if (myCouple.value!.members.length > 1) {
      lover = myCouple.value!.members
          .firstWhere((m) => m.socialId != me.value!.socialId);
    }
    return lover;
  }

  void validateName(String? name) {
    if (name == null || name.isEmpty == true) {
      throw ValidationException("닉네임을 입력해주세요");
    }
  }

  void validateBirthday(DateTime? birthday) {
    DateTime now = DateTime.now();
    if (birthday != null && birthday.isAfter(now)) {
      throw ValidationException("생일을 다시 설정해주세요");
    }
  }

  void validateRelationDate(DateTime? relationDate) {
    DateTime now = DateTime.now();
    if (relationDate != null && relationDate.isAfter(now)) {
      throw ValidationException("생일을 다시 설정해주세요");
    }
  }

  Future<void> updateMember(
      {String? name,
      DateTime? birthday,
      Character? character,
      AlarmOffset? myAlarm,
      AlarmOffset? loverAlarm,
      List<AppleCalendar>? syncedAppleCalendar}) async {
    if (name != null) {
      validateName(name);
    }
    if (birthday != null) {
      validateBirthday(birthday);
    }

    UpdateMemberReq req =
        UpdateMemberReq(name, birthday, character, myAlarm, loverAlarm, syncedAppleCalendar);
    await _memberRepository.updateMember(req).then((res) {
      me.value = res.member;
      myCouple.value = res.couple;
    }).catchError((e) {
      throw ServerResponseException(e.toString());
    });
  }

  Future<void> updateCouple(DateTime relationDate) async {
    validateRelationDate(relationDate);
    UpdateCoupleReq req = UpdateCoupleReq(relationDate);
    await _coupleRepository.updateCouple(req).then((couple) {
      myCouple.value = couple;
    });
  }
}
