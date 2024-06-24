import 'package:firebase_messaging/firebase_messaging.dart';

import 'dev/logger.dart';

mixin NotificationMixin {
  void setUpNotificationMixin() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      logger.w('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      logger.w('User granted provisional permission');
    } else {
      logger.w('User declined or has not accepted permission');
    }
  }
}
