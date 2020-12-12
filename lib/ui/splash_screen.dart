import 'dart:async';

import 'package:flutter/material.dart';
import 'package:luxemall_app/messages/message_composer.dart';
import 'package:luxemall_app/models/product.dart';
import 'package:luxemall_app/utils/dev_log.dart';
import 'package:luxemall_app/utils/assets_resource.dart';
import 'package:luxemall_app/utils/global_variables.dart';
import 'package:luxemall_app/utils/popup_dialog.dart';
import 'package:luxemall_app/utils/screen_transition.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  GlobalVar _globalVar = GlobalVar();

  @override
  void initState() {
    _globalVar.allProducts = List();
    _globalVar.displayCategory = List();
    _globalVar.productToCart = List();
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
            AssetRes.mainLogo,
          ),
        ),
      ),
    );
  }

  void _getAllProducts() {
    DevLog.d(DevLog.ADI, 'Get All Products Message');
    Future<String> ftAllProducts = getAllProducts();
    ftAllProducts.then((onValue) {
      // DevLog.d(DevLog.ADI, 'Get All Products Message Response : $onValue');
      if (onValue.length == 0) {
        _showErrorDialog('Server Error');
      } else {
        _handleGetAllProductsMessage(onValue);
      }
    });
  }

  void _handleGetAllProductsMessage(String response) async {
    List<dynamic> jsonData = parseResponse(response);
    _globalVar.allProducts.clear();
    for(var i = 0; i < jsonData.length; i++) {
      // DevLog.d(DevLog.ADI, 'where : ' + _globalVar.displayProducts.where((element) => _globalVar.displayProducts[i].id == jsonData[i]['id']).toString());
      // DevLog.d(DevLog.ADI, 'i = ' + i.toString());
      Product _product = Product(
        id: jsonData[i]['id'],
        title: jsonData[i]['title'],
        price: jsonData[i]['price'].toDouble(),
        description: jsonData[i]['description'],
        category: jsonData[i]['category'],
        image: jsonData[i]['image'],
      );

      _globalVar.allProducts.add(_product);
      if(_globalVar.displayCategory.length == 0 || _globalVar.displayCategory == null){
        _globalVar.displayCategory.add(_globalVar.allProducts[i].category);
      }else if(!_globalVar.displayCategory.any((element) => element == _globalVar.allProducts[i].category)){
        _globalVar.displayCategory.add(_globalVar.allProducts[i].category);
      }
      // DevLog.d(DevLog.ADI, 'where : ' + _globalVar.displayCategory.toString());

    }

    setState(() {});
    navigateReplaceSlideLeft(context, HomeScreen());
  }

  void _showErrorDialog(String contentText) {
    lxShowDialog(
        context,'Error', contentText,
        btnPressed: () {
        });
  }
}
