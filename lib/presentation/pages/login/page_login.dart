import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:upwork_videocall/blocs/login/login_bloc.dart';
import 'package:upwork_videocall/model/signin_signup/request/LoginRequestMessage.dart';
import 'package:upwork_videocall/presentation/components/custom_snackbar.dart';
import 'package:upwork_videocall/presentation/pages/login/page_register.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upwork_videocall/presentation/pages/page_home.dart';

class PageLogin extends StatefulWidget {
  @override
  _PageLoginState createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  String userName, password;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginStateComplete) {
          Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                  builder: (context) =>
                      PageHome(userInformation: state.response)),
              (route) => false);
        } else if (state is LoginStateFailed) {
          CustomSnackbar.snacbarWithGet(
              success: false, content: state.errorMessage);
        }
      },
      child: buildScaffold(context),
    );
  }

  Scaffold buildScaffold(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFB8B3B3), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.4, 0.9]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(flex: 4),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("Login",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            ),
            buildTextFormField("Username"),
            buildTextFormField("Password"),
            Spacer(flex: 2),
            buildButton(),
            Spacer(),
            buildTextButton(),
          ],
        ),
      ),
    );
  }

  TextButton buildTextButton() {
    return TextButton(
      onPressed: () => Navigator.push(
          context, CupertinoPageRoute(builder: (context) => PageRegister())),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(text: "Don't have an account? "),
            TextSpan(
                text: "Sign up", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  GestureDetector buildButton() {
    return GestureDetector(
      onTap: () => loginEvent(),
      child: CircleAvatar(
        backgroundColor: Colors.black,
        radius: 10.w,
        child: Icon(
          PhosphorIcons.arrowRight,
          color: Colors.white,
        ),
      ),
    );
  }

  Container buildTextFormField(String hintText) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
          ]),
      child: TextFormField(
        onChanged: (entered) {
          switch (hintText) {
            case "Username":
              userName = entered.length > 0 ? entered.trim() : null;
              break;
            case "Password":
              password = entered.length > 0 ? entered.trim() : null;
              break;
          }
        },
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          fillColor: Colors.white,
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }

  void loginEvent() async {
    if ((userName != null || userName != "") &&
        (password != null || password != "")) {
      LoginRequestMessage request =
          LoginRequestMessage(username: userName, password: password);
      context.read<LoginBloc>().login(request);
    }
  }
}
