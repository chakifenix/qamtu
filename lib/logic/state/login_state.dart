import 'package:equatable/equatable.dart';
import 'package:qamtu/models/user_model.dart';

abstract class LoginState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  final bool isPhone;
  final String? errorMessage;

  LoginInitial({required this.isPhone, this.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [
    isPhone
  ];
}

class LoginLoading extends LoginState {
  final bool? isPhone;

  LoginLoading({this.isPhone});
}

class LoginSms extends LoginState{
  final bool isPhone;
  final String firstText;
  final String iinText;
  final String? errorMessage;
  final bool showSendAgain;
  final int seconds;

  LoginSms({required this.isPhone, required this.firstText, required this.iinText, this.showSendAgain = false, this.seconds = 59, this.errorMessage});

  @override
  // TODO: implement props
  List<Object?> get props => [
    isPhone,
    seconds,
    showSendAgain
  ];
}

class LoginSuccess extends LoginState{
  final UserModel user;

  LoginSuccess({required this.user});
}


