import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/compute/v1.dart';
import 'package:qamtu/colors.dart';
import 'package:qamtu/firebase_options.dart';
import 'package:qamtu/logic/cubit/internet_cubit.dart';
import 'package:qamtu/logic/cubit/localization_cubit.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/presentation/screens/auth_responder_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).whenComplete(() {
    SharedPreferences.getInstance().then((sharedPreferences) {
      runApp(MyApp(
        sharedPreferences: sharedPreferences,
      ));
    });
  });
}

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String accessToken = '';
  Duration? accessTokenExpiry;
  Future<void> getAccessToken() async {
    try {
      final serviceAccountJson = await rootBundle.loadString(
          'assets/notif-test-56453-firebase-adminsdk-7t4c4-31a7d36cf5.json');

      final accountCredentials = ServiceAccountCredentials.fromJson(
        json.decode(serviceAccountJson),
      );

      const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = http.Client();
      try {
        final accessCredentials =
            await obtainAccessCredentialsViaServiceAccount(
          accountCredentials,
          scopes,
          client,
        );

        setState(() {
          accessToken = accessCredentials.accessToken.data;
        });

        print('Access Token: $accessToken');
      } catch (e) {
        print('Error obtaining access token: $e');
      } finally {
        client.close();
      }
    } catch (e) {
      print('Error loading service account JSON: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // getAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder: (context, child) {
        return MultiBlocProvider(
            providers: [
              BlocProvider<InternetCubit>(
                create: (BuildContext context) => InternetCubit(),
              ),
              BlocProvider<LocalizationCubit>(
                create: (BuildContext context) => LocalizationCubit(
                    widget.sharedPreferences.getInt('language')),
              ),
              BlocProvider<UserCubit>(
                create: (BuildContext context) =>
                    UserCubit(widget.sharedPreferences.getString('userData')),
              ),
            ],
            child: BlocBuilder<LocalizationCubit, Locale?>(
              builder: (context, locale) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData(
                      colorScheme: ColorScheme.fromSwatch().copyWith(
                        primary: primaryBlue,
                      ),
                      textTheme: GoogleFonts.interTextTheme(),
                      appBarTheme: AppBarTheme(
                          backgroundColor: Colors.white,
                          elevation: 0.5,
                          centerTitle: false,
                          titleTextStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                          foregroundColor: primaryBlue)),
                  supportedLocales: L10n.all,
                  locale: locale ?? const Locale('kk'),
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                  ],
                  home: BlocListener<InternetCubit, bool>(
                    listener: (context, internetState) {
                      if (internetState) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!.internetConnected),
                          backgroundColor: customGreen,
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.noInternet),
                          backgroundColor: customRed,
                        ));
                      }
                    },
                    child: child,
                  ),
                );
              },
            ));
      },
      child: AuthResponderScreen(),
    );
  }
}
