import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upwork_videocall/helpers/shared-prefs.dart';
import 'package:upwork_videocall/presentation/pages/login/page_login.dart';
import 'package:upwork_videocall/presentation/pages/page_home.dart';
import 'package:upwork_videocall/repositories/auth/auth_repository.dart';

class PageSplash extends StatefulWidget {
  @override
  _PageSplashState createState() => _PageSplashState();
}

class _PageSplashState extends State<PageSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () => pageRotation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  pageRotation() async {
    if (SharedPrefs.getLogin) {
      print("user token: " + SharedPrefs.getToken);
      final response = await AuthRepository().getUser();
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
              builder: (context) => PageHome(userInformation: response)),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => PageLogin()),
          (route) => false);
    }
  }
}
