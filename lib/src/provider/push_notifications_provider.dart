import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hotel3/src/provider/users_provider.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';

class PushNotificationsProvider {

  AndroidNotificationChannel channel;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initNotifications () async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void onMessageListener () {

    // RECIBMOS LAS NOTIFICACIONES EN SEGUNDO PLANO
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        print('NUEVA NOTIFICACION : $message');
      }
    });


    //RECIBIR LAS NOTIFICACIONES EN PRIMER PLANO
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    // SE EJECUTA CUANDO PRESIONAMOS CLICK EN LA NOTIFCACION
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  void saveToken(User user, BuildContext context) async {
    String token = await FirebaseMessaging.instance.getToken();
    UsersProvider usersProvider = UsersProvider();
    usersProvider.init(context, sessionUser: user);
    usersProvider.updateNotificationToken(user.id, token);
  }

  Future<void> sendMessage(String to, Map<String, dynamic> data, String title, String body) async {
    Uri uri =Uri.https('fcm.googleapis.com', '/fcm/send');
    await http.post(
      uri,
      headers: <String, String> {
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAK5Q1JXU:APA91bG9roeeBx7vg2PJf5ZFC_ijEYHia4SxGzyhy0FUqstBT2GbNRrMZHVFbDWbmRJGTF8j0dP3n5UpW0GzHmDrZg-_H4DkivQSHv0wr3cajC0vOYfJCFFDEozBTB-Or9zXEDyalyMS',
      },
      body: jsonEncode(
        <String, dynamic> {
          'notification': <String, dynamic> {
            'body': body,
            'title': title
          },
          'priority': 'high',
          'ttl': '4500s',
          'data': data,
          'to': to
        }
      )
    );
  }

}