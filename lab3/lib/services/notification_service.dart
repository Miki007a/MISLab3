import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> initialize() async {
    try {
      final token = await _firebaseMessaging.getToken();

      if (navigatorKey.currentContext != null) {
        final bool? shouldRequest = await showDialog<bool>(
          context: navigatorKey.currentContext!,
          builder: (context) => AlertDialog(
            title: Text('Enable Notifications'),
            content: Text('Would you like to receive notifications for daily jokes?'),
            actions: [
              TextButton(
                child: Text('No'),
                onPressed: () => Navigator.pop(context, false),
              ),
              TextButton(
                child: Text('Yes'),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        );

        if (shouldRequest == true) {
          final settings = await _firebaseMessaging.requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
          );
          print('Notification permission status: ${settings.authorizationStatus}');
        }
      }

      FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received foreground message:');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('Data: ${message.data}');
        _showForegroundNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('App opened from notification:');
        print('Title: ${message.notification?.title}');
        print('Body: ${message.notification?.body}');
        print('Data: ${message.data}');
        navigatorKey.currentState?.pushNamed('/favorites');
      });

    } catch (e, stackTrace) {
      print('Error in notification setup: $e');
      print('Stack trace: $stackTrace');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _backgroundMessageHandler(RemoteMessage message) async {
    print('Received background message:');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');
  }

  static void _showForegroundNotification(RemoteMessage message) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.notification?.title ?? 'New Notification',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              if (message.notification?.body != null)
                Text(message.notification!.body!),
            ],
          ),
          action: SnackBarAction(
            label: 'VIEW',
            onPressed: () {
              navigatorKey.currentState?.pushNamed('/favorites');
            },
          ),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
} 