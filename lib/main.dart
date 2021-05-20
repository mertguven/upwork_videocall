import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:upwork_videocall/presentation/pages/page_main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Upwork Video Call',
          debugShowCheckedModeBanner: false,
          home: PageMain(),
        );
      },
    );
  }
}
