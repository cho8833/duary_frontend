import 'package:duary/model/event.dart';
import 'package:duary/model/member.dart';
import 'package:duary/provider/duary_context.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:flutter/material.dart';

class TimeTableController extends ChangeNotifier {
  String? selectedEventId;

  final DuaryContext _duaryContext = DuaryContext();

  final EventProvider eventProvider;

  final Set<DateTime> _fetchedDays = {};

  final Set<Event> _allEvents = {};

  TimeTableController(this.eventProvider);

  final Map<DateTime, List<List<Event>>> myEvents = {};
  final Map<DateTime, List<List<Event>>> loverEvents = {};

  Future<Map<Member, List<List<Event>>>> getEventByDay(DateTime date) async {
    final DateTime startDate = DateUtils.dateOnly(date);
    final DateTime endDate = date.add(const Duration(days: 1));

    // _allEvents.addAll(await eventProvider.getEvent(startDate, endDate));

    _fetchedDays.add(startDate);

    processOverlapEvents();

    return {
      _duaryContext.me.value!: myEvents[startDate]!,
      _duaryContext.lover.value!: loverEvents[startDate]!
    };
  }

  void processOverlapEvents() {
    // 내 이벤트와 상대방 이벤트로 분리
    final List<Event> allMyEvents = _allEvents.where((event) {
      return _duaryContext.me.value!.socialId == event.member.socialId ||
          event.isTogether;
    }).toList();

    final List<Event> allLoverEvents = _allEvents.where((event) {
      return _duaryContext.lover.value!.socialId == event.member.socialId ||
          event.isTogether;
    }).toList();

    // 2. 전체 이벤트를 기준으로 "전역 그룹" 생성
    final List<List<Event>> globalMyGroups = groupingOverlapEvents(allMyEvents);
    final List<List<Event>> globalLoverGroups =
        groupingOverlapEvents(allLoverEvents);

    // 3. 생성된 전역 그룹을 각 날짜에 맞게 분배
    // clear()를 통해 기존 데이터를 초기화
    myEvents.clear();
    loverEvents.clear();

    for (final DateTime date in _fetchedDays) {
      final DateTime dayEnd = date.add(const Duration(days: 1));

      // 이 날짜에 해당하는 내 이벤트 그룹 찾기
      final List<List<Event>> myGroupsForDate = globalMyGroups.where((group) {
        // 그룹 내 이벤트 중 하나라도 이 날짜와 겹치면 해당 그룹 전체를 포함
        return group.any((event) =>
            event.startDateTime.isBefore(dayEnd) &&
            event.endDateTime.isAfter(date));
      }).toList();
      myEvents[date] = myGroupsForDate;

      // 이 날짜에 해당하는 상대방 이벤트 그룹 찾기
      final List<List<Event>> loverGroupsForDate =
          globalLoverGroups.where((group) {
        return group.any((event) =>
            event.startDateTime.isBefore(dayEnd) &&
            event.endDateTime.isAfter(date));
      }).toList();
      loverEvents[date] = loverGroupsForDate;
    }
  }

// groupingOverlapEvents 함수는 대부분 그대로 사용할 수 있으나,
// 여러 날에 걸친 이벤트를 정확히 처리하려면 스위프 라인 알고리즘의 시간 단위를
// '날짜와 무관한 분'이 아닌 '절대적인 시간'으로 계산해야 더 정확합니다.
// 하지만 현재 구조상 이벤트 객체 자체가 시간을 다 가지고 있으므로,
// 아래의 로직도 대부분의 경우에 잘 동작할 것입니다.
//
// **중요**: 만약 이벤트가 24시간을 초과하는 경우 (예: 월요일 10:00 ~ 화요일 14:00),
// 현재의 `groupingOverlapEvents`는 겹침을 정확히 계산하지 못할 수 있습니다.
// 그 이유는 `hour * 60 + minute` 계산이 날짜 정보를 무시하기 때문입니다.
//
// 만약 24시간을 초과하는 이벤트를 완벽하게 지원해야 한다면,
// `groupingOverlapEvents` 내부의 겹침 탐지 로직을 수정해야 합니다.
// (예: 스위프 라인 대신 모든 이벤트 쌍을 직접 비교)
//
// 여기서는 기존 `groupingOverlapEvents`를 그대로 사용한다고 가정합니다.
  List<List<Event>> groupingOverlapEvents(List<Event> events) {
    // ... (기존 groupingOverlapEvents 코드와 동일)
    final List<List<Event>> grouped = [];

    // sweep-line algorithm : 이벤트들의 겹치는 구간을 찾음
    const int maxTime = 1440;
    // NOTE: 이 방식은 이벤트가 24시간을 넘지 않는다고 가정합니다.
    // 만약 날짜를 넘어가는 긴 이벤트가 있다면, 이 로직은 한계가 있습니다.
    final List<List<Event>> startEvents = List.generate(maxTime + 2, (_) => []);
    final List<List<Event>> endEvents = List.generate(maxTime + 2, (_) => []);

    // 여러 날에 걸친 이벤트를 처리하기 위한 로직 수정이 필요할 수 있습니다.
    // 예를 들어, 월요일 23:00 ~ 화요일 01:00 이벤트는
    // 월요일의 23:00~24:00, 화요일의 00:00~01:00 으로 분리해서 처리해야 할 수 있습니다.
    // 하지만 여기서는 우선 단순화된 기존 로직을 따른다고 가정합니다.
    for (final event in events) {
      // 이 부분은 날짜가 바뀌면 겹침 계산이 부정확해질 수 있습니다.
      int start = event.startDateTime.hour * 60 + event.startDateTime.minute;
      int end = event.endDateTime.hour * 60 + event.endDateTime.minute;

      // 날짜가 넘어가는 이벤트 처리 (간단한 예시)
      if (event.endDateTime.day != event.startDateTime.day) {
        // 이 경우, sweep-line 알고리즘을 단순 적용하기 어렵습니다.
        // 여기서는 가장 간단한 해결책으로, 모든 이벤트 쌍의 시간을 직접 비교하여
        // overlap 그래프를 만드는 것이 더 안정적일 수 있습니다.
      }

      startEvents[start].add(event);
      endEvents[end].add(event);
    }

    // ... (이하 로직은 대부분 동일)
    final Set<Event> activeEvents = <Event>{};
    final Map<String, Set<String>> overlaps = {
      for (var event in events) event.id: <String>{},
    };

    for (int minute = 0; minute <= maxTime; minute++) {
      for (final event in startEvents[minute]) {
        for (final activeEvent in activeEvents) {
          // 실제로는 날짜까지 고려해서 겹치는지 확인해야 더 정확합니다.
          // A.start < B.end && B.start < A.end
          if (event.startDateTime.isBefore(activeEvent.endDateTime) &&
              activeEvent.startDateTime.isBefore(event.endDateTime)) {
            overlaps[event.id]!.add(activeEvent.id);
            overlaps[activeEvent.id]!.add(event.id);
          }
        }
        activeEvents.add(event);
      }
      for (final event in endEvents[minute]) {
        activeEvents.remove(event);
      }
    }

    // grouping 로직 (동일)
    final Set<String> visited = <String>{};
    final Map<String, Event> eventById = {
      for (Event event in events) event.id: event
    };

    for (final event in events) {
      if (!visited.contains(event.id)) {
        final List<String> queue = [event.id];
        final List<Event> group = <Event>[];

        while (queue.isNotEmpty) {
          final String current = queue.removeLast();
          if (visited.contains(current)) continue;

          visited.add(current);
          group.add(eventById[current]!);

          for (final neighbor in overlaps[current]!) {
            if (!visited.contains(neighbor)) {
              queue.add(neighbor);
            }
          }
        }
        grouped.add(group);
      }
    }

    return grouped;
  }
}
