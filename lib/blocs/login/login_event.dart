part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginEventInitial extends LoginEvent {}

class LoginEventComplete extends LoginEvent {}

class LoginEventFailed extends LoginEvent {}
