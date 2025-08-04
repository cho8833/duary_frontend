import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';

class LinkStateManager {
  StreamSubscription<Uri>? _subscription;

  final AppLinks appLinks;

  LinkStateManager(this.appLinks);

  ValueNotifier<String?> coupleCode = ValueNotifier(null);

  void setCode(String? code) {
    coupleCode.value = code;
  }

  void listenToLinkStream() {
    _subscription = appLinks.uriLinkStream.listen((uri) {
      if (uri.queryParameters.containsKey('cleandCode')) {
        setCode(uri.queryParameters['cleandCode']);
      }
    });
  }

  Future<void> handleUri() async {
    Uri? uri = await appLinks.getLatestLink();
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
