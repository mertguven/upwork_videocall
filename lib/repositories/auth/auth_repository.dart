import 'package:upwork_videocall/helpers/shared-prefs.dart';
import 'package:upwork_videocall/model/profile/response/GetUserInformationResponseMessage.dart';
import 'package:upwork_videocall/model/signin_signup/response/RegisterResponseMessage.dart';
import 'package:upwork_videocall/model/signin_signup/response/LoginResponseMessage.dart';
import 'package:upwork_videocall/model/signin_signup/request/RegisterRequestMessage.dart';
import 'package:upwork_videocall/model/signin_signup/request/LoginRequestMessage.dart';
import 'package:upwork_videocall/repositories/interfaces/iauth_base.dart';
import 'package:upwork_videocall/services/web_service.dart';

class AuthRepository extends IAuthBase {
  WebService _webService = WebService();
  dynamic requestBody;

  Future<GetUserInformationResponseMessage> getUser() async {
    final item = await _webService.sendRequestWithGet("GetUserByToken");
    var getUserInformationResponseMessage =
        GetUserInformationResponseMessage.fromJson(item);
    return getUserInformationResponseMessage;
  }

  @override
  Future<LoginResponseMessage> signIn(LoginRequestMessage request) async {
    requestBody = {
      "username": request.username,
      "password": request.password,
    };
    final item = await _webService.sendRequestWithPost("Login", requestBody);
    var loginResponseMessage = LoginResponseMessage.fromJson(item);
    if (loginResponseMessage.success) {
      SharedPrefs.saveToken(loginResponseMessage.token);
      SharedPrefs.login();
    }
    return loginResponseMessage;
  }

  @override
  Future<RegisterResponseMessage> signUp(RegisterRequestMessage request) async {
    requestBody = {
      "username": request.username,
      "password": request.password,
    };
    final item = await _webService.sendRequestWithPost("Register", requestBody);
    var registerResponseMessage = RegisterResponseMessage.fromJson(item);
    return registerResponseMessage;
  }
}
