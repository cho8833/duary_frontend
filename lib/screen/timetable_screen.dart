import 'package:duary/model/event.dart';
import 'package:duary/provider/event_provider.dart';
import 'package:duary/widget/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final DateTime today = DateTime.now();
  late final PagingController<DateTime, Event> _pagingController;
  late final EventProvider _eventProvider;

  @override
  void initState() {
    _pagingController = PagingController(firstPageKey: today);
    _pagingController.addPageRequestListener((pageKey) {

    });
    _eventProvider = context.read<EventProvider>();
    super.initState();
  }

  Future<void> _fetchPage(DateTime pageKey) async {
    final newItems = await _eventProvider.getEvent(pageKey).catchError((e) {

    });


  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting("ko_KR");
    return Scaffold(
      appBar: AppBarBase(
          appBarObj: AppBar(),
          centerBuilder: (context) => Column(
                children: [
                  const Text(
                    "오늘",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        color: Color(0xFFFE8F00)),
                  ),
                  Text(
                    "${DateFormat("yyyy년 M월 dd일").format(today)} ${DateFormat.E("ko_KR").format(today)}요일",
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                        color: Color(0xFF969696)),
                  )
                ],
              )),
      body: PagedListView(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate(
              itemBuilder: (context, item, index) => CustomPaint(
                    size: const Size(167, 62),
                    painter: _SpeechBubblePainter(isLeft: true),
                  ))),
    );
  }

  bool _isToday(DateTime dateTime) {
    if (dateTime.day == today.day &&
        dateTime.month == today.month &&
        dateTime.year == today.year) {
      return true;
    } else {
      return false;
    }
  }
}

class _EventItem extends StatelessWidget {
  const _EventItem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _SpeechBubblePainter extends CustomPainter {

  final bool isLeft;

  _SpeechBubblePainter({required this.isLeft});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFFFA93A).withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // Draw the rounded rectangle
    if (isLeft) {
      // If flipped, draw the rectangle on the right
      final RRect roundedRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.1, 0, size.width * 0.9, size.height),
        const Radius.circular(20),
      );
      canvas.drawRRect(roundedRect, paint);

      // Draw the triangle on the left
      final Path trianglePath = Path();
      trianglePath.moveTo(size.width * 0.1, size.height * 0.5);
      trianglePath.lineTo(size.width * 0.1, size.height * 0.7);
      trianglePath.lineTo(0, size.height * 0.6);
      trianglePath.close();

      canvas.drawPath(trianglePath, paint);
    } else {
      // If not flipped, draw the rectangle on the left
      final RRect roundedRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width * 0.9, size.height),
        const Radius.circular(20),
      );
      canvas.drawRRect(roundedRect, paint);

      // Draw the triangle on the right
      final Path trianglePath = Path();
      trianglePath.moveTo(size.width * 0.9, size.height * 0.5);
      trianglePath.lineTo(size.width * 0.9, size.height * 0.7);
      trianglePath.lineTo(size.width, size.height * 0.6);
      trianglePath.close();

      canvas.drawPath(trianglePath, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SpeechBubblePainter oldDelegate) {
    return false;
  }
}
