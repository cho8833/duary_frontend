import 'package:duary/support/asset_path.dart';
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

  final Text title;
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
      width: preferredSize.width,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              title,
            ],
          ),
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
          trailingBuilder != null ? trailingBuilder!(context) : Container()
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarObj.preferredSize.height);
}

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, required this.appBarObj, this.trailingBuilder, this.leadingBuilder});

  final AppBar appBarObj;
  final Widget Function(BuildContext)? trailingBuilder;
  final Widget Function(BuildContext)? leadingBuilder;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, statusBarHeight+16, 16, 16),
      height: preferredSize.height + statusBarHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0, child: leadingBuilder != null ? leadingBuilder!(context) :  Container(),
          ),
          Image.asset(AssetPath.duaryLogo, height: 24,),
          Positioned(
              right: 0,
              child: trailingBuilder != null ? trailingBuilder!(context) : Container()),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarObj.preferredSize.height);
}

class AppBarBase extends StatelessWidget
    with CheckTheme
    implements PreferredSizeWidget {
  const AppBarBase(
      {super.key,
      required this.appBarObj,
      this.trailingBuilder,
      this.backgroundColor,
      this.centerBuilder, this.leadingBuilder});

  final AppBar appBarObj;
  final Widget Function(BuildContext)? trailingBuilder;
  final Widget Function(BuildContext)? centerBuilder;
  final Widget Function(BuildContext)? leadingBuilder;
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
      width: preferredSize.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                centerBuilder != null ? centerBuilder!(context) : Container(),
              ],
            ),
          ),
          Positioned(
            left: 0,
              child: leadingBuilder != null ? leadingBuilder!(context) : Container(),
          ),
          Positioned(
            right: 0,
              child: trailingBuilder != null ? trailingBuilder!(context) : Container())
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarObj.preferredSize.height);
}