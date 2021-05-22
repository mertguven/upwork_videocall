import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';
import 'package:upwork_videocall/blocs/call/call_bloc.dart';
import 'package:upwork_videocall/blocs/home/home_bloc.dart';
import 'package:upwork_videocall/blocs/login/login_bloc.dart';
import 'package:upwork_videocall/blocs/register/register_bloc.dart';
import 'package:upwork_videocall/helpers/shared-prefs.dart';
import 'package:upwork_videocall/presentation/pages/page_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(create: (context) => RegisterBloc()),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc()),
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
        BlocProvider<CallBloc>(create: (context) => CallBloc())
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          return GetMaterialApp(
            title: 'Upwork Video Call',
            debugShowCheckedModeBanner: false,
            home: PageSplash(),
          );
        },
      ),
    );
  }
}
