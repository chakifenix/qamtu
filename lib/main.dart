import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qamtu/colors.dart';
import 'package:qamtu/logic/cubit/internet_cubit.dart';
import 'package:qamtu/logic/cubit/localization_cubit.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/presentation/screens/auth_responder_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  const MyApp({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      builder:  (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<InternetCubit>(
              create: (BuildContext context) => InternetCubit(),),
            BlocProvider<LocalizationCubit>(
              create: (BuildContext context) => LocalizationCubit(sharedPreferences.getInt('language')),),
            BlocProvider<UserCubit>(
              create: (BuildContext context) => UserCubit(sharedPreferences.getString('userData')),),
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
                            color: Colors.black
                        ),
                        foregroundColor: primaryBlue
                    )
                ),

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
                    if(internetState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.internetConnected), backgroundColor: customGreen,));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.noInternet), backgroundColor: customRed,));
                    }
                  },
                  child: child,
                ),
              );
            },
          )
        );
      },

      child: AuthResponderScreen(),
    );
  }
}

