import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/logic/state/login_state.dart';
import 'package:qamtu/models/user_model.dart';
import 'package:qamtu/services/firebase_service.dart';
import 'package:qamtu/services/network_layer.dart';
import 'package:qamtu/urls.dart';

class LoginCubit extends Cubit<LoginState> {
  UserCubit userCubit;
  Timer? _timer;
  LoginCubit({required this.userCubit}) : super(LoginInitial(isPhone: true));
  // LoginCubit({required this.userCubit}) : super(LoginSms(isPhone: true, firstText: 'fdsadf', iinText: 'fdadfd'));


  void loginFunc(String smsCode, String language) async {
    if(state is LoginSms) {
      final currentState = state as LoginSms;
      emit(LoginLoading());

      userCubit.makeRequest(url: currentState.isPhone ? LOGIN_NOTIFY_VERIFY : LOGIN_EMAIL_VERIFY, language: language, isPost: true, body: currentState.isPhone ? {
        'verification_code': smsCode,
        'phone': '7${currentState.firstText}',
        'iin': currentState.iinText
      } : {
        'verification_code': smsCode,
        'email': currentState.firstText
      }).then((response) async {
        if(response is Response) {
          final answerMap = NetworkLayer().responseToMap(response);
          final newUser = UserModel(answerMap['access_token'], answerMap['refresh_token'], 'firebase');
          emit(LoginSuccess(user: newUser));

          if(!currentState.isPhone) {
            final bool notifStatus = await FirebaseService().requestPermission();

            if(notifStatus) {
              String token = await FirebaseService().getToken();
              userCubit.makeRequest(url: NOTIFICATION_URL, language: language, headers: {'X-Auth': answerMap['access_token'], 'Accept' : 'application/json',}, isPost: true, body: {'firebase_token': notifStatus ? token : ''});
            }
          }

        } else if(response is String) {
          emit(LoginSms(isPhone: currentState.isPhone, firstText: currentState.firstText, iinText: currentState.iinText, errorMessage: response));
          startTimer();
        } else {
          emit(LoginInitial(isPhone: currentState.isPhone, errorMessage: language == 'kk' ? 'Белгісіз қате': 'Неизвестная ошибка'));
        }
      });
    }
  }

  void startTimer() {
    if(state is LoginSms) {
      const oneSec = Duration(seconds: 1);
      _timer = Timer.periodic(
        oneSec,
            (Timer timer) {
          if(state is LoginSms) {
            final currentState = state as LoginSms;
            if(currentState.seconds > 0) {
              emit(LoginSms(isPhone: currentState.isPhone, firstText: currentState.firstText, iinText: currentState.iinText, showSendAgain: false, seconds: currentState.seconds - 1));
            } else {
              emit(LoginSms(isPhone: currentState.isPhone, firstText: currentState.firstText, iinText: currentState.iinText, showSendAgain: true, seconds: 0));
            }
          } else {
            if(_timer != null) {
              _timer!.cancel();
            }
          }
        },
      );
    }
  }

  void sendSmsCode({bool isPhone = true, required String firstText, required String iin, required language}) async {
    emit(LoginLoading());

    final bool notifStatus = await FirebaseService().requestPermission();

    if(!notifStatus && isPhone) {
      emit(LoginInitial(isPhone: isPhone, errorMessage: language == 'kk' ? 'Хабарламаға рұқсат беріңіз': 'Дайте разрешение на уведомление'));
    } else {
      String token = await FirebaseService().getToken();
      userCubit.makeRequest(url: isPhone ? LOGIN_NOTIFY_URL : LOGIN_EMAIL_URL, isPost: true, body: isPhone ? {'phone': '7$firstText', 'iin': iin, 'firebase_token': notifStatus ? token : ''} : {'email': firstText, 'iin': iin}, language: language).then((response) {
        if(response is Response) {
          emit(LoginSms(isPhone: isPhone, firstText: firstText, iinText: iin));
          startTimer();
        } else if(response is String) {
          emit(LoginInitial(isPhone: isPhone, errorMessage: response));
        } else {
          emit(LoginInitial(isPhone: isPhone, errorMessage: language == 'kk' ? 'Белгісіз қате': 'Неизвестная ошибка'));
        }
      });
    }
  }

  void toggleLoginMode(bool isPhone) {
    if(state is LoginInitial) {
      final currentState = state as LoginInitial;
      if(currentState.isPhone != isPhone) {
        emit(LoginInitial(isPhone: isPhone));
      }
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close

    if(_timer != null) {
      _timer!.cancel();
    }
    return super.close();
  }
}