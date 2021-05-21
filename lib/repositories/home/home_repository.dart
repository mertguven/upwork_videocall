import 'package:upwork_videocall/model/call/GenerateAgoraTokenResponseMessage.dart';
import 'package:upwork_videocall/model/call/SelectOnlineUserResponseMessage.dart';
import 'package:upwork_videocall/model/home/request/UserStatusChangeRequestMessage.dart';
import 'package:upwork_videocall/model/home/response/GetOnlineUsersResponseMessage.dart';
import 'package:upwork_videocall/model/home/response/UserStatusChangeResponseMessage.dart';
import 'package:upwork_videocall/repositories/interfaces/ihome_base.dart';
import 'package:upwork_videocall/services/web_service.dart';

class HomeRepository extends IHomeBase {
  WebService _webService = WebService();
  dynamic _requestBody;

  @override
  Future<UserStatusChangeResponseMessage> changeUserStatus(
      UserStatusChangeRequestMessage request) async {
    _requestBody = {"status": request.status};
    final item = await _webService.sendRequestWithPostAndToken(
        "UserStatusChange", _requestBody);
    var userStatusChangeResponseMessage =
        UserStatusChangeResponseMessage.fromJson(item);
    return userStatusChangeResponseMessage;
  }

  @override
  Future<GetOnlineUsersResponseMessage> getOnlineUsers() async {
    final item = await _webService.sendRequestWithGet("GetOnlineUsers");
    var getOnlineUsersResponseMessage =
        GetOnlineUsersResponseMessage.fromJson(item);
    return getOnlineUsersResponseMessage;
  }

  @override
  Future<SelectOnlineUserResponseMessage> selectOnlineUser() async {
    final item = await _webService.sendRequestWithGet("SelectOnlineUser");
    var selectOnlineUserResponseMessage =
        SelectOnlineUserResponseMessage.fromJson(item);
    return selectOnlineUserResponseMessage;
  }

  @override
  Future<GenerateAgoraTokenResponseMessage> generateAgoraToken() async {
    final item = await _webService.sendRequestWithPostAndToken(
        "GenerateAgoraToken", _requestBody);
    var generateAgoraTokenResponseMessage =
        GenerateAgoraTokenResponseMessage.fromJson(item);
    return generateAgoraTokenResponseMessage;
  }
}
