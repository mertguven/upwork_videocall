import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:upwork_videocall/model/signin_signup/request/RegisterRequestMessage.dart';
import 'package:upwork_videocall/model/signin_signup/response/RegisterResponseMessage.dart';
import 'package:upwork_videocall/repositories/auth/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterStateInitial());
  final _repo = AuthRepository();

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterEventInitial || event is RegisterEventComplete) {
      if (event is RegisterEventInitial) yield RegisterStateLoading();
    }
  }

  Future<RegisterResponseMessage> register(
      RegisterRequestMessage request) async {
    final response = await _repo.signUp(request);
    return response;
  }
}
