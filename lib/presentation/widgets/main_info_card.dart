import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/models/profile_model.dart';
import 'package:qamtu/presentation/widgets/profile_property_column.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainInfoCard extends StatelessWidget {
  final ProfileModel profileModel;
  const MainInfoCard({Key? key, required this.profileModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;

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
            Text(translations.generalInformation, style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500
            ),),

            SizedBox(
              height: 15.h,
            ),

            Visibility(
              visible: profileModel.birthdate != '',
              child: ProfilePropertyColumn(title: translations.birthday, value: profileModel.birthdate,),
            ),

            Visibility(
              visible: profileModel.age > 0,
              child: ProfilePropertyColumn(title: translations.age, value: profileModel.age.toString()),
            ),

            Visibility(
              visible: profileModel.position != '',
              child: ProfilePropertyColumn(title: translations.position, value: profileModel.position,),
            ),

            Visibility(
              visible: profileModel.family_status != '',
              child: ProfilePropertyColumn(title: translations.familyStatus, value: profileModel.family_status,),
            ),

            Visibility(
              visible: profileModel.privilege != '',
              child: ProfilePropertyColumn(title: translations.privilege, value: profileModel.privilege,),
            ),
          ],
        ),
      ),
    );
  }
}
