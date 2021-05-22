part of 'call_bloc.dart';

@immutable
abstract class CallEvent {}

class CallEventInitial extends CallEvent {}

class CallEventFailed extends CallEvent {}

class CallEventComplete extends CallEvent {
  final SelectOnlineUserResponseMessage response;

  CallEventComplete(this.response);
}
