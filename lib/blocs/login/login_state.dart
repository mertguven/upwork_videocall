part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginStateInitial extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateComplete extends LoginState {
  final GetUserInformationResponseMessage response;

  LoginStateComplete(this.response);
}

class LoginStateFailed extends LoginState {
  final String errorMessage;

  LoginStateFailed(this.errorMessage);
}
