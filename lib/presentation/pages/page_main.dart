import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:sizer/sizer.dart';

class PageMain extends StatefulWidget {
  @override
  _PageMainState createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  String userName, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFFDDDADA), Colors.white],
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
      onPressed: () {},
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
      onTap: () {
        print(userName.toString() + "/" + password.toString());
      },
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
}