import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void initializaNotifications(){
  AndroidInitializationSettings initializationSettingsAndriod = AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndriod,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void>showNotification()async{
  AndroidNotificationDetails andriodPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false
    );

    NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: andriodPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(0,
    'Save Successfully','Your ticket picture has been saved.',
    platformChannelSpecifics);
}