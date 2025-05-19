import 'package:flutter/material.dart';

class ButtonBase extends StatefulWidget {
  const ButtonBase({super.key, required this.onTap, required this.child});

  final Future<void> Function() onTap;
  final Widget child;

  @override
  State<ButtonBase> createState() => _ButtonBaseState();
}

class _ButtonBaseState extends State<ButtonBase> {

  // Future 캐싱을 통해 중복 호출 방지
  Future<void>? _ongoingFuture;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          if (_ongoingFuture != null) {
            return _ongoingFuture;
          }

          _ongoingFuture = widget.onTap();
          _ongoingFuture!.whenComplete(() {
            _ongoingFuture = null;
          });

          return _ongoingFuture;
        },
        child: widget.child,
      ),
    );
  }
}
