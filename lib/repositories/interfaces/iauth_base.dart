import 'package:upwork_videocall/model/signin_signup/request/LoginRequestMessage.dart';
import 'package:upwork_videocall/model/signin_signup/request/RegisterRequestMessage.dart';
import 'package:upwork_videocall/model/signin_signup/response/LoginResponseMessage.dart';
import 'package:upwork_videocall/model/signin_signup/response/RegisterResponseMessage.dart';

abstract class IAuthBase {
  Future<LoginResponseMessage> signIn(LoginRequestMessage request);
  Future<RegisterResponseMessage> signUp(RegisterRequestMessage request);
}
