import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luxemall_app/resources/images_resource.dart';
import 'package:luxemall_app/screens/home_screen.dart';
import 'package:luxemall_app/ui/screen_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // navigateReplaceSlideLeft(context, HomeScreen());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width / 4,
          child: Image.asset(
            ImgRes.mainLogo,
          ),
        ),
      ),
    );
  }
}
