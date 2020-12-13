import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luxemall_app/ui/product_screen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:luxemall_app/models/product.dart';
import 'package:luxemall_app/ui/sort_filter_widget.dart';
import 'package:luxemall_app/utils/assets_resource.dart';
import 'package:luxemall_app/utils/dev_log.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:luxemall_app/messages/message_composer.dart';
import 'package:luxemall_app/utils/colors_resource.dart';
import 'package:luxemall_app/utils/dev_log.dart';
import 'package:luxemall_app/utils/global_variables.dart';
import 'package:luxemall_app/utils/popup_dialog.dart';
import 'package:luxemall_app/utils/screen_transition.dart';
import 'package:luxemall_app/utils/string_resource.dart';

class CartScreen extends StatefulWidget {

  final Function() notifyParent;
  CartScreen({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  GlobalVar _globalVar = GlobalVar();

  double _total;
  bool _button;

  @override
  void initState() {
    _total = 0;
    _button = false;
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
          title: Text(StrRes.myCart),
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Column(
                children: List.generate(_globalVar.productToCart.length, (index) {
                  if(!_button){
                    _total = _total + _globalVar.productToCart[index].total;
                  }
                  return Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          _showDialog(index);
                        },
                        child: Center(
                          child: Container(
                            child: Image.asset(
                              AssetRes.trash,
                              color: Colors.blueGrey[200],
                              width: 50, height: 50,
                            )
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 7
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight, // 10% of the width, so there are ten blinds.
                                  colors: [
                                    ColorRes.SECONDARY,
                                    ColorRes.SECONDARY,
                                  ], // whitish to gray
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    child: Image.network(
                                      _globalVar.productToCart[index].image,
                                      width: 80,
                                      height: 80,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            _globalVar.productToCart[index].title,
                                            style: Theme.of(context).textTheme.bodyText1.copyWith(color: ColorRes.PRIMARY),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Row(
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                  _globalVar.productToCart[index].quantity.toString(),
                                                  style: Theme.of(context).textTheme.caption.copyWith(color: ColorRes.THIRD),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  ' x ',
                                                  style: Theme.of(context).textTheme.caption.copyWith(color: ColorRes.THIRD),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  '\$ ' + _globalVar.productToCart[index].price.toString(),
                                                  style: Theme.of(context).textTheme.caption.copyWith(color: ColorRes.THIRD),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(right: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: (){
                                                          _button = true;
                                                          if(_globalVar.productToCart[index].quantity > 1){
                                                            _globalVar.productToCart[index].quantity--;
                                                            _globalVar.productToCart[index].total = _globalVar.productToCart[index].total - _globalVar.productToCart[index].price;
                                                            _total = _total - _globalVar.productToCart[index].price;
                                                            setState(() {
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: ColorRes.PRIMARY
                                                          ),
                                                          child: Container(
                                                            padding: EdgeInsets.all(5),
                                                            child: Image.asset(
                                                              AssetRes.minus,
                                                              width: 15, height:15,
                                                              color: Colors.white,
                                                            ),
                                                          )
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                          left: 5, right: 5
                                                        ),
                                                        child: Text(
                                                          _globalVar.productToCart[index].quantity.toString(),
                                                          style: Theme.of(context).textTheme.caption.copyWith(color: ColorRes.THIRD),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: (){
                                                          _button = true;
                                                          _globalVar.productToCart[index].quantity++;
                                                          _globalVar.productToCart[index].total = _globalVar.productToCart[index].total + _globalVar.productToCart[index].price;
                                                          _total = _total + _globalVar.productToCart[index].price;
                                                          setState(() {
                                                          });
                                                        },
                                                        child: Container(
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: ColorRes.PRIMARY
                                                            ),
                                                            child: Container(
                                                              padding: EdgeInsets.all(5),
                                                              child: Image.asset(
                                                                AssetRes.plus,
                                                                width: 15, height:15,
                                                                color: Colors.white,
                                                              ),
                                                            )
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(right: 15),
                          alignment: Alignment.centerRight,
                          child: Text(
                            '\$ ' + _globalVar.productToCart[index].total.toStringAsFixed(2),
                            style: Theme.of(context).textTheme.subtitle2.copyWith(color: ColorRes.THIRD),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: 40,
                  left: 30,
                  bottom: 20
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: Text(
                          StrRes.total,
                          style: Theme.of(context).textTheme.headline6.copyWith(color: ColorRes.THIRD),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        right: 20,
                      ),
                      child: Text(
                        '\$ ' + _total.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headline6.copyWith(color: ColorRes.THIRD),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar:
        BottomAppBar(
          child: Container(
            height: 80,
            child: Container(
              margin: EdgeInsets.all(15),
              child: RaisedButton(
                onPressed: () {
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
                      StrRes.payNow,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

  void _onRemoveProduct(int index){
    _button = true;
    _total = _total - _globalVar.productToCart[index].total;
    int idRemove = _globalVar.productToCart[index].id;
    _globalVar.productToCart.removeWhere((element) => element.id == idRemove);
    setState(() {
      if(_globalVar.productToCart.isEmpty){
        widget.notifyParent();
        Navigator.pop(context);
      }
    });
  }

  void _showDialog(int index) {
    lxShowDialogTwoAction(
        context,'Remove Product', StrRes.removeConfirm,
        btnPressed: () {
          _onRemoveProduct(index);
        });
  }
}