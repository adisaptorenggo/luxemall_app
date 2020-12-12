import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:luxemall_app/models/product.dart';
import 'package:luxemall_app/utils/dev_log.dart';
import 'package:luxemall_app/messages/message_composer.dart';
import 'package:luxemall_app/utils/colors_resource.dart';
import 'package:luxemall_app/utils/dev_log.dart';
import 'package:luxemall_app/utils/global_variables.dart';
import 'package:luxemall_app/utils/popup_dialog.dart';
import 'package:luxemall_app/utils/screen_transition.dart';
import 'package:luxemall_app/utils/string_resource.dart';

class ProductScreen extends StatefulWidget {

  final Product _selectedProduct;

  ProductScreen(this._selectedProduct);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  GlobalVar _globalVar = GlobalVar();

  Product _product;

  @override
  void initState() {
    _product = widget._selectedProduct;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StrRes.appName),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
                top: 15,
                bottom: 5,
                left: 10,
                right: 10
            ),
            child: Image.network(
              _product.image,
              width: 300, height: 300,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
              bottom: 5,
              left: 10,
              right: 10
            ),
            child: Text(
              _product.title,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 5,
                  top: 5,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: ColorRes.PRIMARY,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  ' \$' + _product.price.toString() + ' ',
                  style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 10,
                right: 10
            ),
            child: Text(
              _product.description,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                top: 5,
                left: 10,
                right: 10
            ),
            child: Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'tags: ',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(color: ColorRes.PRIMARY),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: ColorRes.THIRD,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    '  ' + _product.category + '  ',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
      // _globalVar.cartProducts.isNotEmpty?
      // BottomAppBar(
      //   child: Container(
      //     height: 80,
      //     child: Container(
      //       margin: EdgeInsets.all(15),
      //       child: RaisedButton(
      //         onPressed: () {
      //
      //         },
      //         shape: RoundedRectangleBorder(
      //           side: BorderSide.none,
      //           borderRadius: BorderRadius.circular(5.0),
      //         ),
      //         padding: const EdgeInsets.all(0.0),
      //         child: Ink(
      //           decoration: const BoxDecoration(
      //             gradient: LinearGradient(
      //               colors: <Color>[
      //                 ColorRes.PRIMARY,
      //                 ColorRes.PRIMARY,
      //               ],
      //             ),
      //             borderRadius:
      //             BorderRadius.all(Radius.circular(5.0)),
      //           ),
      //           child: Container(
      //             constraints: const BoxConstraints(
      //                 minWidth: 88.0,
      //                 minHeight: 36.0), // min sizes for Material buttons
      //             alignment: Alignment.center,
      //             child: Text(
      //               'View Cart',
      //               textAlign: TextAlign.center,
      //               style: TextStyle(color: Colors.white),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ),
      // ):
      BottomAppBar(
        child: Container(
          height: 80,
          child: Container(
            margin: EdgeInsets.all(15),
            child: RaisedButton(
              onPressed: () {
                var _cart = {
                  'productId': _product.id,
                  'quantity': 2,
                };
                DevLog.d(DevLog.ADI, 'cart: ' + _cart.toString());
                _globalVar.cartProducts.addAll(_cart);
                _sendAddToCart();
              },
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      ColorRes.PRIMARY,
                      ColorRes.PRIMARY,
                    ],
                  ),
                  borderRadius:
                  BorderRadius.all(Radius.circular(5.0)),
                ),
                child: Container(
                  constraints: const BoxConstraints(
                      minWidth: 88.0,
                      minHeight: 36.0), // min sizes for Material buttons
                  alignment: Alignment.center,
                  child: Text(
                    '+ Add to Cart',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sendAddToCart() {
    DevLog.d(DevLog.ADI, 'Send Add To Cart Message');
    // final DateTime now = DateTime.now();
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');
    // final String formatted = formatter.format(now);
    Future<ProgressDialog> ftProgressDialog = loadingDialog(context, StrRes.plsWait);
    ftProgressDialog.then((progressDialog) {
      Future<String> ftAddToCart = sendAddToCart(
        1,
        DateTime.now().toString(),
        _globalVar.cartProducts,
      );
      ftAddToCart.then((onValue) {
        DevLog.d(DevLog.ADI, 'Add To Cart Response : $onValue');
        progressDialog.hide();
        if (onValue.length == 0) {
          _showErrorDialog('Server Error');
        } else {
          _handleAddToCartMessage(onValue);
        }
      });
    });
  }

  void _handleAddToCartMessage(String response) async {
    Map<String, dynamic> jsonData = parseResponse2(response);
    DevLog.d(DevLog.ADI, 'jsonData: ' + jsonData.toString());
  }

  void _showErrorDialog(String contentText) {
    lxShowDialog(
        context,'Error', contentText,
        btnPressed: () {
        });
  }

}