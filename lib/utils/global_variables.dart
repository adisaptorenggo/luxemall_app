import 'package:flutter/material.dart';
import 'package:luxemall_app/models/product.dart';

class GlobalVar{
  static final GlobalVar _singleton = GlobalVar._internal();

  factory GlobalVar() {
    return _singleton;
  }

  GlobalVar._internal();

  List<Product> allProducts;
  List<Product> displayProducts;
  List<Product> sortFilterProducts;
  List<Product> displaySortFilterProducts;

  Map<String, int> cartProducts;

  //Sort And Filter
  bool sortFilter;
  String sortType = '';
  List<String> displayCategory;
  List<String> displayCategoryFilterValue;
}