import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:upwork_videocall/model/profile/response/GetUserInformationResponseMessage.dart';
import 'package:upwork_videocall/model/signin_signup/request/LoginRequestMessage.dart';
import 'package:upwork_videocall/repositories/auth/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginStateInitial());
  final _repo = AuthRepository();

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginEventInitial)
      yield LoginStateLoading();
    else if (event is LoginEventComplete) {
      final response = await _repo.getUser();
      yield LoginStateComplete(response);
    } else {
      yield LoginStateFailed("Login failed, please try again!");
    }
  }

  Future<void> login(LoginRequestMessage request) async {
    final response = await _repo.signIn(request);
    if (response.success) {
      add(LoginEventComplete());
    } else {
      add(LoginEventFailed());
    }
  }
}
