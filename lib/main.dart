import 'package:flutter/material.dart';
import 'package:luxemall_app/screens/splash_screen.dart';
import 'package:luxemall_app/utils/colors_resource.dart';
import 'package:luxemall_app/utils/string_resource.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StrRes.appName,
      theme: ThemeData(

        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: ColorRes.PRIMARY,

        // Define the default font family.
        fontFamily: 'Roboto',
      ),
      home: SplashScreen(),
    );
  }
}
