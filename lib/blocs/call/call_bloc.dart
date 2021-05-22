import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:upwork_videocall/blocs/home/home_bloc.dart';
import 'package:upwork_videocall/model/call/SelectOnlineUserResponseMessage.dart';
import 'package:upwork_videocall/model/home/request/UserStatusChangeRequestMessage.dart';
import 'package:upwork_videocall/repositories/home/home_repository.dart';

part 'call_event.dart';
part 'call_state.dart';

class CallBloc extends Bloc<CallEvent, CallState> {
  CallBloc() : super(CallStateInitial());

  int searchCounter = 0;

  final _repo = HomeRepository();

  @override
  Stream<CallState> mapEventToState(
    CallEvent event,
  ) async* {
    if (event is CallEventInitial)
      yield CallStateLoading();
    else if (event is CallEventComplete)
      yield CallStateComplete(event.response);
    else {
      yield CallStateFailed();
    }
  }

  Future<void> selectOnlineUser() async {
    final response = await _repo.selectOnlineUser();
    if (response.success &&
        (response.status == "Matching" || response.status == "Online")) {
      add(CallEventComplete(response));
    } else {
      if (searchCounter > 5) {
        UserStatusChangeRequestMessage request =
            UserStatusChangeRequestMessage(status: "Idle");
        await HomeBloc().changeUserStatus(request);
        add(CallEventFailed());
      } else {
        searchCounter++;
        Future.delayed(Duration(seconds: 1));
        await selectOnlineUser();
      }
    }
  }
}
