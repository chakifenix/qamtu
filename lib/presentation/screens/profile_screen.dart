import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/colors.dart';
import 'package:qamtu/logic/cubit/profile_cubit.dart';
import 'package:qamtu/models/profile_model.dart';
import 'package:qamtu/presentation/widgets/main_info_card.dart';
import 'package:qamtu/presentation/widgets/profile_card.dart';
import 'package:qamtu/presentation/widgets/settings_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../logic/cubit/user_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final translations = AppLocalizations.of(context)!;
    final userCubit = BlocProvider.of<UserCubit>(context);
    final language = Localizations.localeOf(context).languageCode;

    return BlocProvider(
      create: (_) => ProfileCubit(userCubit: userCubit)..getProfile(language),
      child: Scaffold(
        appBar: AppBar(
          title: Text(translations.profile),
        ),
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileModel?>(
            builder: (context, state) {
              return ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                children: [

                  // Container(
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //       color: customLightGreen,
                  //       borderRadius: BorderRadius.circular(10.r)
                  //   ),
                  //   padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  //   child: Text('Ваш резюме подтверждено с проверкой Центр занятости!', style: TextStyle(
                  //       fontSize: 12.sp,
                  //       fontWeight: FontWeight.w400
                  //   ),),
                  // ),
                  //
                  // SizedBox(
                  //   height: 15.h,
                  // ),

                  state == null ? const Center(
                    child: LinearProgressIndicator(),
                  ) : ProfileCard(profileModel: state,),

                  state == null ? SizedBox() : MainInfoCard(profileModel: state),

                  SettingsCard(),
                ],
              );
            },
          )
        ),
      ),
    );
  }
}
