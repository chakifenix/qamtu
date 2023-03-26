import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/presentation/screens/language_settings_screen.dart';
import 'package:qamtu/presentation/screens/notification_settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../colors.dart';
import '../../logic/cubit/internet_cubit.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final userCubit = BlocProvider.of<UserCubit>(context);
    final translations = AppLocalizations.of(context)!;
    final internetCubit = BlocProvider.of<InternetCubit>(context);


    return Card(
      color: Color.fromRGBO(250, 250, 250, 1),
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r)
      ),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(translations.settings, style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500
            ),),

            SizedBox(
              height: 15.h,
            ),

            GestureDetector(
              onTap: () {
                if(internetCubit.state) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LanguageSettingsScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(translations.noInternet), backgroundColor: customRed,));
                }
              },
              child: Text(translations.language, style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black
              ),),
            ),

            SizedBox(
              height: 20.h,
            ),

            GestureDetector(
              onTap: () {
                if(internetCubit.state) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSettingsScreen()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(translations.noInternet), backgroundColor: customRed,));
                }
              },
              child: Text(translations.notification, style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black
              ),),
            ),

            SizedBox(
              height: 20.h,
            ),

            GestureDetector(
              onTap: () {
                if(internetCubit.state) {
                  userCubit.deleteUser();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(translations.noInternet), backgroundColor: customRed,));
                }
              },
              child: Text(translations.logOut, style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.red
              ),),
            ),

            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
