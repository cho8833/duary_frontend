import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

class LinkStateManager extends ChangeNotifier {
  StreamSubscription<Uri>? _subscription;

  ValueNotifier<String?> coupleCode = ValueNotifier(null);

  void setCode(String? code) {
    coupleCode.value = null;
    coupleCode.value = code;
    notifyListeners();
  }

  void listenToLinkStream(AppLinks appLinks) {
    _subscription = appLinks.uriLinkStream.listen((uri) {
      if (uri.queryParameters.containsKey('cleandCode')) {
        setCode(uri.queryParameters['cleandCode']);
      }
    });
  }

  Future<void> handleUri() async {
    Uri? uri = await AppLinks().getLatestLink();
    if (uri != null) {
      setCode(uri.queryParameters['cleandCode']);
    }
  }


  void cancelSubscription() {
    coupleCode.value = null;
    if (_subscription != null) {
      _subscription!.cancel();
    }
  }
}
