import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
  final Function() notifyParent;

  ProductScreen(this._selectedProduct,{Key key, @required this.notifyParent}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  GlobalVar _globalVar = GlobalVar();

  Product _product;
  bool buttonActive;
  int _quantity;

  @override
  void initState() {
    _product = widget._selectedProduct;
    _quantity = 0;
    if(_product.quantity == 0) buttonActive = false;
    else buttonActive = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        widget.notifyParent();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                widget.notifyParent();
                Navigator.pop(context);
              }
          ),
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
                left: 15,
                right: 15,
                bottom: 10
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      StrRes.tags + ': ',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(color: ColorRes.PRIMARY),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.blueGrey[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      '  ' + _product.category + '  ',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: RaisedButton(
                              color: ColorRes.PRIMARY,
                              onPressed: (){
                                if(_quantity > 0){
                                  _quantity--;
                                  if(_quantity == 0){
                                    buttonActive = false;
                                  }
                                  setState(() {
                                  });
                                }
                              },
                              shape: CircleBorder(
                              ),
                              child: Container(
                                child: Text(
                                  '-',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
                                ),
                              ),
                            )
                          ),
                          Container(
                            child: Text(
                              _quantity.toString(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Container(
                            child: RaisedButton(
                              color: ColorRes.PRIMARY,
                              onPressed: (){
                                _quantity++;
                                buttonActive = true;
                                setState(() {
                                });
                              },
                              shape: CircleBorder(
                              ),
                              child: Container(
                                child: Text(
                                  '+',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
                                ),
                              ),
                            )
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar:
        BottomAppBar(
          child: Container(
            height: 80,
            child: Container(
                margin: EdgeInsets.all(15),
                child: RaisedButton(
                  onPressed: () => buttonActive ? _onButtonClicked(context) : null,
                  shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.all(0.0),
                  child: buttonActive ?
                  Ink(
                    decoration: const BoxDecoration(
                      gradient:
                      LinearGradient(
                        colors: <Color>[
                          ColorRes.PRIMARY,
                          ColorRes.PRIMARY,
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                          minWidth: 88.0,
                          minHeight: 36.0), // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: Text(
                        StrRes.addToCart,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ):
                  Ink(
                    decoration: const BoxDecoration(
                      gradient:
                      LinearGradient(
                        colors: <Color>[
                          Colors.grey,
                          Colors.grey,
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                          minWidth: 88.0,
                          minHeight: 36.0), // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: Text(
                        StrRes.addToCart,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ),
    );
  }

  void _onButtonClicked(BuildContext context) {
    var _cart = {
      'productId': _product.id,
      'quantity': _product.quantity,
    };
    DevLog.d(DevLog.ADI, 'cart: ' + _cart.toString());
    _globalVar.cartProducts.addAll(_cart);
    _sendAddToCart();
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
    int _totalQuantity = 0;
    if(_globalVar.productToCart.isEmpty){
      _product.quantity = _quantity;
      _product.total = _quantity * _product.price;
      _totalQuantity = _product.quantity;
      _globalVar.productToCart.add(_product);
    }else{
      bool _flag = false;
      for(int i = 0; i < _globalVar.productToCart.length; i++){
        if(_globalVar.productToCart[i].id == _product.id){
          _globalVar.productToCart[i].quantity += _quantity;
          _globalVar.productToCart[i].total = _globalVar.productToCart[i].quantity * _globalVar.productToCart[i].price;
          _totalQuantity = _globalVar.productToCart[i].quantity;
          _flag = true;
          break;
        }
      }
      if(!_flag){
        _product.quantity = _quantity;
        _product.total = _product.quantity * _product.price;
        _totalQuantity = _product.quantity;
        _globalVar.productToCart.add(_product);
      }
    }
    _showSuccessDialog('Success Adding Product to Cart, Total Quantity of this Product: ' + _totalQuantity.toString());
  }

  void _showSuccessDialog(String contentText){
    lxShowDialog(
        context,'Success', contentText,
        btnPressed: () {
        });
  }

  void _showErrorDialog(String contentText) {
    lxShowDialog(
        context,'Error', contentText,
        btnPressed: () {
        });
  }

}