import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/urls.dart';

import '../../services/firebase_service.dart';

class NotificationCubit extends Cubit<bool?> {

  final UserCubit userCubit;
  NotificationCubit({required this.userCubit}) : super(null);

  void getNotifStatus(String language) {
    userCubit.makeRequest(url: NOTIFICATION_URL, language: language, headers: {'X-Auth': userCubit.state!.accessToken, 'Accept' : 'application/json',}).then((value) => {
      if(value is Response) {
        emit(true)
      } else {
        emit(false)
      }
    });
  }

  Future<void> setNotifState(String language, bool status) async {
    if(status != state) {
      if(!status) {
        userCubit.makeRequest(url: NOTIFICATION_URL, language: language, headers: {'X-Auth': userCubit.state!.accessToken, 'Accept' : 'application/json',}, isPost: true, body: {'firebase_token': ''}).then((value) => {
          if(value is Response) {
            emit(false)
          }
        });
      } else {
        final bool notifStatus = await FirebaseService().requestPermission();

        if(notifStatus) {
          String token = await FirebaseService().getToken();
          userCubit.makeRequest(url: NOTIFICATION_URL, language: language, headers: {'X-Auth': userCubit.state!.accessToken, 'Accept' : 'application/json',}, isPost: true, body: {'firebase_token': token}).then((value) => {
            if(value is Response) {
              emit(true)
            }
          });
        }
      }
    }
  }

  // void changeLanguage(int index, UserCubit userCubit) async {
  //   if(L10n.all.length > index) {
  //     emit(L10n.all[index]);
  //     final prefs = await SharedPreferences.getInstance();
  //     prefs.setInt('language', index).whenComplete(() async {
  //       await userCubit.makeRequest(url: LANG_URL, language: L10n.all[index].languageCode, headers: {'X-Auth': userCubit.state!.accessToken, 'Accept' : 'application/json',}, isPost: true, body: {'lang': L10n.all[index].languageCode});
  //     });
  //   }
  // }
}