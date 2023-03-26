import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qamtu/logic/cubit/notification_cubit.dart';
import '../../logic/cubit/user_cubit.dart';
import '../widgets/detailed_appbar_title.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;
    final langCode = Localizations.localeOf(context).languageCode;
    final userCubit = BlocProvider.of<UserCubit>(context);


    return BlocProvider(
      create: (_) => NotificationCubit(userCubit: userCubit)..getNotifStatus(langCode),
      child: Scaffold(
        appBar: AppBar(
          title: DetailedAppbarTitle(
            title: translations.settings,
            subtitle: translations.notification,
          ),
        ),

        body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: BlocBuilder<NotificationCubit, bool?>(
                builder: (context, state) {
                  if(state == null) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(translations.notification, style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500
                        ),),

                        SizedBox(
                          height: 10.h,
                        ),

                        ListTile(
                          title: Text(translations.enable, style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400
                          ),),
                          trailing: state ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary,) : null,
                          onTap: () {
                            if(state == false) {
                              BlocProvider.of<NotificationCubit>(context).setNotifState(langCode, true);
                            }
                          },
                        ),

                        ListTile(
                          title: Text(translations.disable, style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400
                          ),),
                          trailing: !state ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary,) : null,
                          onTap: () {
                            if(state == true) {
                              BlocProvider.of<NotificationCubit>(context).setNotifState(langCode, false);
                            }
                          },
                        ),
                      ],
                    );
                  }
                },
              )
            )
        ),
      ),
    );
  }
}
