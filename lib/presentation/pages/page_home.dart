import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:upwork_videocall/blocs/home/home_bloc.dart';
import 'package:upwork_videocall/helpers/shared-prefs.dart';
import 'package:upwork_videocall/model/home/request/UserStatusChangeRequestMessage.dart';
import 'package:upwork_videocall/model/profile/response/GetUserInformationResponseMessage.dart';
import 'package:upwork_videocall/presentation/pages/call/page_calling.dart';
import 'package:upwork_videocall/presentation/pages/login/page_login.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageHome extends StatefulWidget {
  final GetUserInformationResponseMessage userInformation;

  const PageHome({Key key, this.userInformation}) : super(key: key);
  @override
  _PageHomeState createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  exitEvent() {
    SharedPrefs.sharedClear();
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => PageLogin()),
        (route) => false);
  }

  Future<void> _changeTheStatus() async {
    var permissionStatus = await _handleMic();
    if (permissionStatus.isGranted) {
      UserStatusChangeRequestMessage request =
          UserStatusChangeRequestMessage(status: "Online");
      await context.read<HomeBloc>().changeUserStatus(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeStateComplete) {
          Navigator.push(
              context, CupertinoPageRoute(builder: (context) => PageCalling()));
        }
      },
      child: buildScaffold(),
    );
  }

  Scaffold buildScaffold() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppbar(),
      body: homeBody(),
    );
  }

  AppBar buildAppbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
            icon: Icon(
              PhosphorIcons.signOutBold,
              size: 30,
              color: Colors.brown,
            ),
            onPressed: () => exitEvent()),
      ],
      centerTitle: true,
    );
  }

  Container homeBody() => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFB8B3B3), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.4, 1]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            callButton(),
            topInformationContainer(),
          ],
        ),
      );

  Container topInformationContainer() => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Search",
              style: TextStyle(
                  color: Colors.brown,
                  fontSize: 26,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "and meet new people!",
              style: TextStyle(
                  color: Colors.brown.shade200,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  GestureDetector callButton() => GestureDetector(
        onTap: () => _changeTheStatus(),
        child: Lottie.asset("assets/animations/call.json"),
      );

  Future<PermissionStatus> _handleMic() async {
    final microphoneStatus = await Permission.microphone.request();
    if (microphoneStatus.isGranted) {
      final cameraStatus = await Permission.camera.request();
      if (cameraStatus.isGranted) {
        return cameraStatus;
      } else {
        return PermissionStatus.denied;
      }
    } else {
      return PermissionStatus.denied;
    }
  }
}
