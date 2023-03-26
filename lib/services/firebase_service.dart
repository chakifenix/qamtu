import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<bool> requestPermission() async {
    bool status = false;
    final settings = await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, provisional: false, sound: true);

    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      status = true;
      initInfo();
    }

    return status;
  }

  // Future<String?> getToken() async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   return FirebaseMessaging.instance.getToken();
  // }

  Future<String> getToken() async {
    return await FirebaseMessaging.instance.getToken() ?? '';
  }

  initInfo() {
    //SHOW NOTIFICATION APP IS OPEN
    var androidInitialize = const AndroidInitializationSettings('@drawable/ic_stat_logo_9');
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: initializationSettingsDarwin);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);
    //---------------------------------


    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if(notification != null) {
        BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
            notification.body.toString(), htmlFormatBigText: true, contentTitle: notification.title.toString(), htmlFormatContentTitle: true
        );

        AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
            '0', '0', importance: Importance.high, styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true
        );

        NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: const DarwinNotificationDetails());

        await flutterLocalNotificationsPlugin.show(0, notification.title, notification.body, platformChannelSpecifics, payload: message.data['title']);
      }
    });

  }
}