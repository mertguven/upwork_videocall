part of 'call_bloc.dart';

@immutable
abstract class CallState {}

class CallStateInitial extends CallState {}

class CallStateLoading extends CallState {}

class CallStateFailed extends CallState {}

class CallStateComplete extends CallState {
  final SelectOnlineUserResponseMessage response;

  CallStateComplete(this.response);
}
