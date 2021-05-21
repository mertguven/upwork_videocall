part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterStateInitial extends RegisterState {}

class RegisterStateLoading extends RegisterState {}

class RegisterStateComplete extends RegisterState {
  final RegisterResponseMessage responseMessage;

  RegisterStateComplete(this.responseMessage);
}
