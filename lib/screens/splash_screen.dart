import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luxemall_app/messages/message_composer.dart';
import 'package:luxemall_app/screens/home_screen.dart';
import 'package:luxemall_app/utils/dev_log.dart';
import 'package:luxemall_app/utils/images_resource.dart';
import 'package:luxemall_app/utils/popup_dialog.dart';
import 'package:luxemall_app/utils/screen_transition.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    _getAllProducts();
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

  void _getAllProducts() {
    DevLog.d(DevLog.ADI, 'Get All Products Message');
    Future<String> ftAllProducts = getAllProducts('20');
    ftAllProducts.then((onValue) {
      DevLog.d(DevLog.ADI, 'Get All Products Message Response : $onValue');
      if (onValue.length == 0) {
        _showErrorDialog('Server Error');
      } else {
        _handleGetAllProductsMessage(onValue);
      }
    });
  }

  void _handleGetAllProductsMessage(String response) async {
    List<dynamic> jsonData = parseResponse(response);
    DevLog.d(DevLog.ADI, 'jsonData : ' + jsonData.toString());
    navigateReplaceSlideLeft(context, HomeScreen());
  }

  void _showErrorDialog(String contentText) {
    lxShowDialog(
        context,'Error', contentText,
        btnPressed: () {
        });
  }
}
