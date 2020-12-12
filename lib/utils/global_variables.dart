import 'package:flutter/material.dart';
import 'package:luxemall_app/models/product.dart';

class GlobalVar{
  static final GlobalVar _singleton = GlobalVar._internal();

  factory GlobalVar() {
    return _singleton;
  }

  GlobalVar._internal();

  List<Product> allProducts;
  bool addToCart = true;
}