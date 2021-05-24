import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:upwork_videocall/blocs/home/home_bloc.dart';
import 'package:upwork_videocall/model/call/SelectOnlineUserResponseMessage.dart';
import 'package:upwork_videocall/presentation/pages/call/voice_call_view.dart';
import 'package:upwork_videocall/presentation/pages/page_home.dart';

class ConnectingView extends StatefulWidget {
  final SelectOnlineUserResponseMessage response;
  ConnectingView({this.response});

  @override
  _ConnectingViewState createState() => _ConnectingViewState();
}

class _ConnectingViewState extends State<ConnectingView>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _generateAgoraTokenAndAnimationController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        goBackHomeView(context);
      },
      child: Scaffold(
        body: Container(
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
              Spacer(flex: 5),
              Text(
                widget.response.username,
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              Spacer(),
              FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Lottie.asset("assets/animations/countdown.json")),
              Spacer(),
              Text(
                "Bağlanıyor...",
                style: TextStyle(
                    color: Colors.brown.shade300,
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }

  void goBackHomeView(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => PageHome()),
      (route) => false);

  _generateAgoraTokenAndAnimationController() async {
    final response = await context.read<HomeBloc>().generateAgoraToken();
    if (response.success) {
      _controller = AnimationController(
          vsync: this, duration: Duration(milliseconds: 2000))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                    builder: (context) => VoiceCallView(
                        response: widget.response, token: response.token)),
                (route) => false);
          }
        });
      _controller.forward();
    }
  }
}
