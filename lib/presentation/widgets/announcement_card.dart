import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/presentation/screens/detailed_announce_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageURL;
  final void Function()? onTap;
  const AnnouncementCard({Key? key, required this.title, required this.subtitle, required this.imageURL, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          color: Color.fromRGBO(250, 250, 250, 1),
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r)
          ),
          margin: EdgeInsets.only(top: 0, bottom: 10.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.network(imageURL, fit: BoxFit.fitWidth,),
                  ),
                ),

                SizedBox(
                  height: 10.h,
                ),

                Text(title, style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500
                )),

                SizedBox(
                  height: 10.h,
                ),

                Text(subtitle, style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400
                ),),

                SizedBox(
                  height: 10.h,
                ),

                GestureDetector(
                  onTap: onTap,
                  child: Text(AppLocalizations.of(context)!.more, style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.primary
                  ),),
                )
              ],
            ),
          )
      ),
    );
  }
}
