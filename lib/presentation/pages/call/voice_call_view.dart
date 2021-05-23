import 'dart:async';
import 'dart:ui';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:upwork_videocall/blocs/home/home_bloc.dart';
import 'package:upwork_videocall/model/call/SelectOnlineUserResponseMessage.dart';
import 'package:upwork_videocall/model/home/request/UserStatusChangeRequestMessage.dart';
import 'package:upwork_videocall/presentation/components/custom_snackbar.dart';
import 'package:upwork_videocall/presentation/pages/page_home.dart';
import 'package:upwork_videocall/utilities/settings.dart';

class VoiceCallView extends StatefulWidget {
  final ClientRole role = ClientRole.Broadcaster;
  final String token;
  final SelectOnlineUserResponseMessage response;

  const VoiceCallView({Key key, this.token, this.response}) : super(key: key);

  @override
  _VoiceCallViewState createState() => _VoiceCallViewState();
}

class _VoiceCallViewState extends State<VoiceCallView> {
  bool muted = false;
  final _users = <int>[];
  final _infoStrings = <String>[];
  RtcEngine _engine;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isUserOnline = false;

  @override
  void dispose() {
    super.dispose();
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
  }

  @override
  void initState() {
    super.initState();
    UserStatusChangeRequestMessage request =
        UserStatusChangeRequestMessage(status: "Busy");
    changeStatus(request);
    print(widget.token);
    initialize();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.joinChannel(widget.token, "pUWVRYAEouEPNnTz", null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableAudio();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
  }

  // Initialize the app
  void _addAgoraEventHandlers() {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'Lütfen kanala tekrar katılın!';
        CustomSnackbar.snacbarWithGet(success: false, content: code.toString());
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'Kanala katıldın.';
        CustomSnackbar.snacbarWithGet(success: true, content: info);
        _infoStrings.add(info);
      });
      Future.delayed(
          Duration(seconds: 5), () => deleteInfoString(_infoStrings));
    }, userOffline: (uid, elapsed) {
      setState(() {
        _users.remove(uid);
        _onCallEnd(context);
        isUserOnline = false;
      });
    }, leaveChannel: (stats) {
      setState(() {
        _users.clear();
        isUserOnline = false;
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = '${widget.response.username} giriş yaptı.';
        CustomSnackbar.snacbarWithGet(success: true, content: info);
        _infoStrings.add(info);
        _users.add(uid);
        isUserOnline = true;
      });
      Future.delayed(
          Duration(seconds: 5), () => deleteInfoString(_infoStrings));
    }));
  }

  void _onCallEnd(BuildContext context) async {
    UserStatusChangeRequestMessage request =
        UserStatusChangeRequestMessage(status: "Idle");
    await changeStatus(request);
    Navigator.pushAndRemoveUntil(context,
        CupertinoPageRoute(builder: (context) => PageHome()), (route) => false);
  }

  // Create a simple chat UI
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: scaffoldKey,
        body: Center(
          child: Stack(
            children: <Widget>[
              _viewRows(),
              _toolbar(),
            ],
          ),
        ),
      ),
    );
  }

  deleteInfoString(List<String> infoStrings) {
    _infoStrings.clear();
  }

  TextStyle customTextStyle() {
    return TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 20);
  }

  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return Container();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.brown,
              size: 40.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.brown : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
          ],
        ));
    }
    return Container();
  }

  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _videoView(view) {
    return Expanded(
        child: Container(
      alignment: Alignment.center,
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
          Spacer(flex: 4),
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: MediaQuery.of(context).size.width / 3,
                backgroundColor: Colors.brown.withOpacity(0.05),
              ),
              CircleAvatar(
                radius: MediaQuery.of(context).size.width / 3.5,
                backgroundColor: Colors.brown.withOpacity(0.15),
              ),
              CircleAvatar(
                radius: MediaQuery.of(context).size.width / 4,
                backgroundColor: Colors.brown.withOpacity(0.25),
              ),
              Text(
                widget.response.username,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
            ],
          ),
          Spacer(flex: 6),
        ],
      ),
    ));
  }

  Future<void> changeStatus(UserStatusChangeRequestMessage request) async {
    await context.read<HomeBloc>().changeUserStatus(request);
  }
}
