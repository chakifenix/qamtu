import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeStatusCard extends StatelessWidget {
  final int raiting;
  final String full_name;

  const HomeStatusCard({Key? key, required this.raiting, required this.full_name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10.r)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(translations.welcomeText, style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white
          ),),
          SizedBox(
            height: 5.h,
          ),

          Text(full_name, style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white
          ),),

          SizedBox(
            height: 20.h,
          ),

          Text(languageCode == 'kk' ? '${translations.queryPlace} - $raiting' : '$raiting ${translations.queryPlace}', style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white
          ),)
        ],
      ),
    );
  }
}
