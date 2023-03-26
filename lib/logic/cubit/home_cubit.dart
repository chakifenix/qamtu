import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/logic/state/home_state.dart';
import 'package:qamtu/models/history_model.dart';
import 'package:qamtu/urls.dart';

import '../../services/network_layer.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserCubit userCubit;

  HomeCubit({required this.userCubit}) : super(HomeLoading());

  void getStatus(String language) {
    if(userCubit.state != null) {
      userCubit.makeRequest(url: STATUS_URL, language: language, headers: {'X-Auth': userCubit.state!.accessToken, 'Accept' : 'application/json',}).then((response) {
        if(response is Response) {
          final answer = NetworkLayer().responseToMap(response);
          emit(HomeLoaded(rating: answer['data']['raiting'] ?? 0, category_rating: answer['data']['privilege_raiting'] ?? 0, category_name: answer['data']['user']['privilege']['name'] ?? '',full_name: answer['data']['user']['full_name'] ?? '', history: List<HistoryModel>.from(
              answer['data']['history'].map((x) => HistoryModel.fromJson(x))), queueList: List<QueueModel>.from(
              answer['data']['raiting_number'].map((x) => QueueModel.fromJson(x)))));
        } else {
          emit(HomeError());
        }
      });
    }
  }
}