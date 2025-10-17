import 'package:duary/model/event.dart';

abstract interface class LLMRepository {
  Future<String> getTalk(Event event);
}