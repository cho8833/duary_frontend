import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  ValueNotifier<bool> isNotificationEnabled = ValueNotifier(false);

  Future<bool> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false
    );
    isNotificationEnabled.value = _checkStatus(settings);
    return isNotificationEnabled.value;
  }

  Future<bool> getPermission() async {
    NotificationSettings settings  = await messaging.getNotificationSettings();
    isNotificationEnabled.value = _checkStatus(settings);
    return isNotificationEnabled.value;
  }


  bool _checkStatus(NotificationSettings settings) {
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      return true;
    } else{
      return false;
    }
  }
}