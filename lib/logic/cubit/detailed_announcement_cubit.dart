import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/models/detailed_announcement_model.dart';

import '../../services/network_layer.dart';
import '../../urls.dart';

class DetailedAnnouncementCubit extends Cubit<DetailedAnnouncementModel?> {
  final UserCubit userCubit;

  DetailedAnnouncementCubit({required this.userCubit}) : super(null);

  void getAnnouncement(int id, String language) {
    userCubit.makeRequest(url: ANNOUNCEMENT_URL + '/$id', language: language, headers: {'X-Auth': userCubit.state!.accessToken, 'Accept' : 'application/json',}, ).then((response) {
      if(response is Response) {
        try {
          final answer = NetworkLayer().responseToMap(response);
          emit(DetailedAnnouncementModel.fromJson(answer['data']));
        } catch(_) {

        }
      }
    });
  }
}