import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class Notifications {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future init() async {
    await _notification.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher')));
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async =>
      _notification.show(id, title, body, await _notificationDetails());

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "channel id",
        "Channel name",
        importance: Importance.max,
      ),
    );
  }

  static Future<bool> callOnFcmApiSendPushNotifications(
      {required String topic,
      required String title,
      required String body}) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';
    final data = {
      "to": "/topics/$topic",
      "notification": {
        "title": title,
        "body": body,
      },
      "data": {
        "type": '0rder',
        "id": '28',
        "click_action": 'FLUTTER_NOTIFICATION_CLICK',
      }
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAIS_XLD0:APA91bFnDDdUq39UI9mDNl9vEBJ2ziOac0IWNQ48lBO62T65Ip2w7staKL6EXw52BoSBOoYnM1Nfi6WYRgqatjs5FeFLzLzJx1OY_-l5uUOGjytS9ICA8ng4wLGraKEmmznxAtSs7ZK5' // 'key=YOUR_SERVER_KEY'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
