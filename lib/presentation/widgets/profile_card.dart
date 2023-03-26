import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/models/profile_model.dart';
import 'package:qamtu/presentation/widgets/profile_property_column.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileCard extends StatelessWidget {
  final ProfileModel profileModel;
  const ProfileCard({Key? key, required this.profileModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      color: const Color.fromRGBO(250, 250, 250, 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r)
      ),
      margin: EdgeInsets.only(bottom: 10.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(translations.basicInformation, style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500
            ),),

            SizedBox(
              height: 15.h,
            ),

            Row(
              children: [

                // ClipOval(
                //   child: Image.network(
                //     profileModel.image_url,
                //     width: 50.w,
                //     height: 50.h,
                //     fit: BoxFit.contain,
                //   ),
                // ),
                CircleAvatar(
                  radius: 50.w, // Image radius
                  backgroundImage: NetworkImage(profileModel.image_url),
                  backgroundColor: Colors.transparent,
                ),

                SizedBox(
                  width: 20.w,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: profileModel.fullName.split(' ').isNotEmpty,
                        child: ProfilePropertyColumn(title: translations.surname, value: profileModel.fullName.split(' ').isNotEmpty ? profileModel.fullName.split(' ')[0] : ''),
                      ),

                      Visibility(
                          visible: profileModel.fullName.split(' ').length > 1,
                          child: ProfilePropertyColumn(title: translations.name, value: profileModel.fullName.split(' ').length > 1 ? profileModel.fullName.split(' ')[1] : ''),
                      ),

                      Visibility(
                          visible: profileModel.fullName.split(' ').length > 2,
                          child: ProfilePropertyColumn(title: translations.lastName, value: profileModel.fullName.split(' ').length > 2 ? profileModel.fullName.split(' ')[2] : ''),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            ProfilePropertyColumn(title: translations.email, value: profileModel.email),
            ProfilePropertyColumn(title: translations.phoneNumber, value: profileModel.phone_number),
          ],
        ),
      ),
    );
  }
}
