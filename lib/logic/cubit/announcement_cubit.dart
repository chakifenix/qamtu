import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:qamtu/logic/cubit/user_cubit.dart';
import 'package:qamtu/logic/state/announcement_state.dart';
import 'package:qamtu/models/announcement_model.dart';
import 'package:qamtu/services/network_layer.dart';
import 'package:qamtu/urls.dart';

class AnnouncementCubit extends Cubit<AnnouncementState> {
  final UserCubit userCubit;
  late ScrollController controller;
  final String languageCode;
  bool moreLoading = false;

  AnnouncementCubit({required this.userCubit, required this.languageCode}) : super(AnnouncementLoading()) {
    controller = ScrollController()..addListener(loadMore);
  }

  void getAnnouncements(String language) {
    if(state is AnnouncementLoading) {

    } else {
      emit(AnnouncementLoading());
    }

    userCubit.makeRequest(url: ANNOUNCEMENT_URL, parameters: {'page': '1'}, language: language, headers: {'X-Auth': userCubit.state!.accessToken, 'Accept' : 'application/json',}, ).then((response) {
      if(response is String) {
        emit(AnnouncementError(response));
      } else if(response is Response) {
        try {
          final answer = NetworkLayer().responseToMap(response);
          final announcements = List<AnnouncementModel>.from(
              answer['data']['data'].map((x) => AnnouncementModel.fromJson(x)));
          bool hasNext = answer['data']['links']['next'] != null;
          emit(AnnouncementLoaded(currentPage: 1, hasNextPage: hasNext, announcements: announcements));
        } catch(_) {
          emit(AnnouncementError('Белгісіз ақау'));
        }
      }
    });
  }

  void loadMore() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if(state is AnnouncementLoaded) {
        final currentState = state as AnnouncementLoaded;
        if(currentState.hasNextPage && !moreLoading) {
          moreLoading = true;

          userCubit.makeRequest(url: ANNOUNCEMENT_URL, parameters: {'page': (currentState.currentPage + 1).toString()}, language: languageCode, headers: {'Authorization': 'Bearer ${userCubit.state!.accessToken}', 'Accept' : 'application/json',}, ).then((response) {
            if(response is Response) {
              try {
                final answer = NetworkLayer().responseToMap(response);

                List<AnnouncementModel> announcements = List<AnnouncementModel>.from(
                    answer['data']['data'].map((x) => AnnouncementModel.fromJson(x)));
                bool hasNext = answer['data']['links']['next'] != null;

                announcements.addAll(currentState.announcements);
                emit(AnnouncementLoaded(currentPage: currentState.currentPage + 1, hasNextPage: hasNext, announcements: announcements));
              } catch(_) {
                return;
              }
            }
          });
        }

        moreLoading = false;
      }
    }
  }

  @override
  Future<void> close() {
    controller.removeListener(loadMore);
    return super.close();
  }
}