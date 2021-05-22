import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:upwork_videocall/model/call/GenerateAgoraTokenResponseMessage.dart';
import 'package:upwork_videocall/model/home/request/UserStatusChangeRequestMessage.dart';
import 'package:upwork_videocall/repositories/home/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static final _singleton = HomeBloc._();

  HomeBloc._() : super(HomeStateInitial());

  factory HomeBloc() => _singleton;

  final _repo = HomeRepository();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeEventInitial)
      yield HomeStateLoading();
    else if (event is HomeEventComplete) yield HomeStateComplete();
  }

  Future<void> changeUserStatus(UserStatusChangeRequestMessage request) async {
    final response = await _repo.changeUserStatus(request);
    if (response.success) {
      add(HomeEventComplete());
    }
  }

  Future<GenerateAgoraTokenResponseMessage> generateAgoraToken() async {
    final response = await _repo.generateAgoraToken();
    if (response.success) {
      return response;
    }
    return null;
  }
}
