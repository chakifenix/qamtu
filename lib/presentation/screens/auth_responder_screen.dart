import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qamtu/presentation/screens/tabview_screen.dart';
import '../../logic/cubit/user_cubit.dart';
import '../../models/user_model.dart';
import 'login_screen.dart';

class AuthResponderScreen extends StatefulWidget {
  const AuthResponderScreen({Key? key}) : super(key: key);

  @override
  State<AuthResponderScreen> createState() => _AuthResponderScreenState();
}

class _AuthResponderScreenState extends State<AuthResponderScreen> {
  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // requestPermission();
  }

  // void requestPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true
  //   );
  //
  //   if(settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     getToken();
  //     initInfo();
  //   }
  // }
  //
  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     if(token != null) {
  //       print('token $token');
  //     } else {
  //       print('token is null');
  //     }
  //   });
  // }
  //
  // initInfo() {
  //   //SHOW NOTIFICATION APP IS OPEN
  //   var androidInitialize = const AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
  //   var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: initializationSettingsDarwin);
  //   flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  //   //---------------------------------
  //
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  //     RemoteNotification? notification = message.notification;
  //
  //     if(notification != null) {
  //       BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
  //         notification.body.toString(), htmlFormatBigText: true, contentTitle: notification.title.toString(), htmlFormatContentTitle: true
  //       );
  //
  //       AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //         '0', '0', importance: Importance.high, styleInformation: bigTextStyleInformation, priority: Priority.high, playSound: true
  //       );
  //
  //       NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: const DarwinNotificationDetails());
  //
  //       await flutterLocalNotificationsPlugin.show(0, notification.title, notification.body, platformChannelSpecifics, payload: message.data['title']);
  //     }
  //   });
  //
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserModel?>(
      builder: (context, state) {
        if (state == null) {
          return LoginScreen();
        } else {
          return TabviewScreen();
        }
      },
    );
  }
}
