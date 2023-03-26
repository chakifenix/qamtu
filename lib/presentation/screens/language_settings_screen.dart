import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/presentation/widgets/detailed_appbar_title.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../logic/cubit/localization_cubit.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final localizationCubit = BlocProvider.of<LocalizationCubit>(context);
    final userCubit = BlocProvider.of<UserCubit>(context);
    final translations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: DetailedAppbarTitle(
          title: translations.settings,
          subtitle: translations.language,
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(translations.language, style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500
              ),),

              SizedBox(
                height: 10.h,
              ),

              ListTile(
                title: Text('Қазақша', style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400
                ),),
                trailing: Localizations.localeOf(context) == const Locale('kk') ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary,) : null,
                onTap: () => localizationCubit.changeLanguage(0, userCubit),
              ),

              ListTile(
                title: Text('Русский', style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400
                ),),
                trailing: Localizations.localeOf(context) == const Locale('ru') ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary,) : null,
                onTap: () => localizationCubit.changeLanguage(1, userCubit),
              ),
            ],
          ),
        )
      ),
    );
  }
}
