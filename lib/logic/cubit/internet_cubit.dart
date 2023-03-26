import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetCubit extends Cubit<bool> {
  late StreamSubscription internetSubscription;

  InternetCubit() : super(true) {
    internetSubscription = Connectivity().onConnectivityChanged.listen((event) {
      checkConnection();
    });
  }

  void checkConnection() async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;

    if(hasConnection != state) {
      emit(hasConnection);
    }
  }

  @override
  Future<void> close() {
    internetSubscription.cancel();
    return super.close();
  }
}