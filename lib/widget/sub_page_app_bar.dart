import 'package:duary/support/check_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubPageAppBar extends StatelessWidget
    with CheckTheme
    implements PreferredSizeWidget {
  const SubPageAppBar(
      {super.key,
      required this.appBarObj,
      required this.title,
      this.trailingBuilder, this.backgroundColor});

  final String title;
  final AppBar appBarObj;
  final Widget Function(BuildContext)? trailingBuilder;
  final Color? backgroundColor;

  void setStatusBarColor() {
    isDarkMode()
        ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
        : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  @override
  Widget build(BuildContext context) {
    setStatusBarColor();
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.fromLTRB(16, statusBarHeight, 16, 0),
      height: preferredSize.height + statusBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              color: Theme.of(context).colorScheme.primary,
              size: 30,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black
            )
          ),
          trailingBuilder != null ? trailingBuilder!(context) : Container()
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarObj.preferredSize.height);
}
