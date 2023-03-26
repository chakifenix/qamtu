import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qamtu/l10n/l10n.dart';

class LocalizationCubit extends Cubit<Locale?> {

  int? savedLocale;
  LocalizationCubit(this.savedLocale) : super(savedLocale != null ? L10n.all[savedLocale] : null);

  void changeLanguage(int index, UserCubit userCubit) async {
    if(L10n.all.length > index) {
      emit(L10n.all[index]);
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('language', index).whenComplete(() async {
        await userCubit.makeRequest(url: LANG_URL, language: L10n.all[index].languageCode, headers: {'X-Auth': userCubit.state!.accessToken, 'Accept' : 'application/json',}, isPost: true, body: {'lang': L10n.all[index].languageCode});
      });
    }
  }
}