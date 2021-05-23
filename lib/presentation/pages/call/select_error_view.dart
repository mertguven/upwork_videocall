import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:upwork_videocall/presentation/pages/page_home.dart';

class SelectErrorView extends StatefulWidget {
  @override
  _SelectErrorViewState createState() => _SelectErrorViewState();
}

class _SelectErrorViewState extends State<SelectErrorView> {
  AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        goBackHomeView(context);
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 3),
              FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Lottie.asset(
                    "assets/animations/404.json",
                    controller: controller,
                  )),
              Spacer(),
              Text(
                "All users are currently busy",
                style: TextStyle(
                    color: Colors.brown,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    primary: Colors.brown,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Close",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  onPressed: () => goBackHomeView(context),
                ),
              ),
              Spacer(flex: 3),
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
}
