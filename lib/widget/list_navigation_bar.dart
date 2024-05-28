import 'package:flutter/material.dart';
import 'package:duary/provider/list_provider.dart';
import 'package:provider/provider.dart';

class ListNavigationBar<L extends PageMixin> extends StatefulWidget {

  const ListNavigationBar({super.key});

  @override
  State<ListNavigationBar> createState() => _ListNavigationBarState<L>();
}

class _ListNavigationBarState<L extends PageMixin>
    extends State<ListNavigationBar> {
  late int totalPageCount;
  static const int _pageCountPerNav = 10;

  void onNavArrowClick(L provider, int navPage) {
    // navPage 가 totalPageCount 를 넘기거나 0 이하이면 navPage 를 바꾸지 않음
    if (navPage < 1 || (totalPageCount / _pageCountPerNav).ceil() < navPage) {
      return;
    }
    provider.setNavPage(navPage);
  }

  @override
  Widget build(BuildContext context) {
    L provider = context.watch<L>();
    int navPage = provider.navPage;
    totalPageCount = provider.totalPages;
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      NavigationArrow(
          onTap: () => onNavArrowClick(provider, navPage - 1), isLeft: true),
      ..._navigationButton(provider, navPage),
      NavigationArrow(
          onTap: () => onNavArrowClick(provider, navPage + 1), isLeft: false)
    ]);
  }

  List<Widget> _navigationButton(L provider, int navPage) {
    List<Widget> buttons = [];
    for (int i = 1 + (navPage - 1) * 10;
    i <
        ((totalPageCount <= navPage * 10) ? totalPageCount : navPage * 10) +
            1;
    i++) {
      buttons.add(TextButton(
          onPressed: () {
            provider.setPage(i-1);
          },
          child: Text((i).toString())));
    }
    return buttons;
  }
}

class NavigationArrow extends StatelessWidget {
  const NavigationArrow({super.key, required this.onTap, required this.isLeft});

  final void Function() onTap;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Icon(
          isLeft ? Icons.navigate_before : Icons.navigate_next,
          color: Colors.grey,
        ),
      ),
    );
  }
}
