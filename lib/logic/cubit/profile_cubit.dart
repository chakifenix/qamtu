import 'package:http/http.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/models/profile_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qamtu/urls.dart';

import '../../services/network_layer.dart';

class ProfileCubit extends Cubit<ProfileModel?> {

  final UserCubit userCubit;

  ProfileCubit({required this.userCubit}) : super(null);

  void getProfile(String language) async {
    userCubit.makeRequest(url: PROFILE_URL, language: language, headers: {'X-Auth': userCubit.state!.accessToken, 'Accept' : 'application/json',}, ).then((response) {
      if(response is Response) {
        try {
          final answer = NetworkLayer().responseToMap(response);
          emit(ProfileModel.fromJson(answer['data']));
        } catch(_) {
        }
      } else {
      }
    });
  }
}