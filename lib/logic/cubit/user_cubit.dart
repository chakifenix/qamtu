import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:qamtu/models/user_model.dart';
import 'package:qamtu/urls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/network_layer.dart';

class UserCubit extends Cubit<UserModel?> {

  String? userData;

  UserCubit(this.userData) : super(userData == null ? null : UserModel.fromJson(jsonDecode(userData)));

  Future<void> setUser(UserModel user) async {
    String userData = jsonEncode(user);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('userData', userData);
    emit(user);
  }

  void deleteUser() async {
    if(state != null) {
      makeRequest(url: LOGOUT_URL, language: 'kk', headers: {'X-Auth': state!.accessToken, 'Accept' : 'application/json',});
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.remove('userData');
      emit(null);
    }
  }

  Future<dynamic> makeRequest({required String url, bool isPost = false, Map<String, String>? headers, Map<String, String>? body, required String language, Map<String, String>? parameters,}) async {
    dynamic returnValue;
    try {
      await NetworkLayer().makeRequest(url: url, isPost: isPost, headers: headers, body: body, language: language, parameters: parameters).then((answer) async {
        if(answer is Response || answer is String) {
          returnValue = answer;
      }  else if(answer is int && state != null) {
          await NetworkLayer().refreshToken(state!.refreshToken, language).then((tokenAnswer) async {
            if(tokenAnswer is Map) {
              UserModel newUser = UserModel(tokenAnswer['access_token'], tokenAnswer['refresh_token'], state!.firebaseToken);
              setUser(newUser);
              returnValue = await makeRequest(url: url, language: language, isPost: isPost, headers: {'Authorization': 'Bearer ${tokenAnswer['access_token']}', 'Accept' : 'application/json'}, body: body);
            } else if(tokenAnswer is String) {
              returnValue = tokenAnswer;
            } else {
              deleteUser();
              return;
            }
          });
        } else {
          returnValue = 'Белгісіз ақау';
        }
      });
    } catch (e) {
      if(e is SocketException){
        returnValue =  'Интернет байланысын тексеріңіз';
      }
      else if(e is TimeoutException){
        returnValue =  'Ұзақ жүктеу, қайталап көріңіз';
      }
      else {
        returnValue =  'Белгісіз ақау' ;
      }
    }
    return returnValue;
  }
}