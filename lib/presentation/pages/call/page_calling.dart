import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:upwork_videocall/blocs/call/call_bloc.dart';
import 'package:upwork_videocall/presentation/pages/call/connecting_view.dart';
import 'package:upwork_videocall/presentation/pages/call/select_error_view.dart';

class PageCalling extends StatefulWidget {
  @override
  _PageCallingState createState() => _PageCallingState();
}

class _PageCallingState extends State<PageCalling> {
  @override
  void initState() {
    super.initState();
    context.read<CallBloc>().add(CallEventInitial());
    context.read<CallBloc>().selectOnlineUser();
    //searchOnlineUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CallBloc, CallState>(
      listener: (context, state) {
        if (state is CallStateFailed) {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(builder: (context) => SelectErrorView()),
              (route) => false);
        } else if (state is CallStateComplete) {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      ConnectingView(response: state.response)),
              (route) => false);
        }
      },
      child: buildScaffold(context),
    );
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 0.9],
            colors: [
              Color(0xFFD64565),
              Color(0xffe08791),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/animations/calling.json"),
            Text(
              "Aranıyor...",
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  /*searchOnlineUser() async {
    context.read<CallBloc>().selectOnlineUser();
    while (true) {
      var response = await homeController.selectOnlineUser();
      print(response.status);
      if (response.success) {
        if (response.status == "Matching" || response.status == "Online") {
          streamController.add(response);
          streamSubscription = stream.listen((value) async {
            streamSubscription?.cancel();
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    child: ConnectingView(response: value),
                    type: PageTransitionType.fade),
                (route) => false);
          });
          break;
        }
      } else {
        if (searchCounter > 10) {
          selectError();
          break;
        } else {
          searchCounter++;
        }
        Future.delayed(Duration(seconds: 1));
      }
    }
  }*/

  /*selectError() async {
    var homeController = Provider.of<HomeController>(context, listen: false);
    UserStatusChangeRequestMessage request =
        UserStatusChangeRequestMessage(status: "Idle");
    await homeController.changeUserStatus(request);
    streamSubscription?.cancel();
    Navigator.pushAndRemoveUntil(
        context,
        PageTransition(child: SelectErrorView(), type: PageTransitionType.fade),
        (route) => false);
  }*/
}
