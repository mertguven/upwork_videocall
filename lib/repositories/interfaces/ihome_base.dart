import 'package:upwork_videocall/model/call/GenerateAgoraTokenResponseMessage.dart';
import 'package:upwork_videocall/model/call/SelectOnlineUserResponseMessage.dart';
import 'package:upwork_videocall/model/home/request/UserStatusChangeRequestMessage.dart';
import 'package:upwork_videocall/model/home/response/GetOnlineUsersResponseMessage.dart';
import 'package:upwork_videocall/model/home/response/UserStatusChangeResponseMessage.dart';

abstract class IHomeBase {
  Future<UserStatusChangeResponseMessage> changeUserStatus(
      UserStatusChangeRequestMessage request);
  Future<GetOnlineUsersResponseMessage> getOnlineUsers();
  Future<SelectOnlineUserResponseMessage> selectOnlineUser();
  Future<GenerateAgoraTokenResponseMessage> generateAgoraToken();
}
