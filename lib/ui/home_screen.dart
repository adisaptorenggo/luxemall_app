import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luxemall_app/ui/cart_sreen.dart';
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

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _limit = 4;
  int _sfLimit = 4;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  bool _refresh = false, _load = false;
  bool _firstBuild;

  GlobalVar _globalVar = GlobalVar();

  @override
  void initState() {
    _firstBuild = true;
    _globalVar.firstSortFilter = false;
    _globalVar.sortFilter = false;
    _globalVar.displayProducts = List();
    _globalVar.sortFilterProducts = List();
    _globalVar.displaySortFilterProducts = List();
    _globalVar.displayCategoryFilterValue = List();
    _globalVar.cartProducts = {};
    WidgetsBinding.instance.addPostFrameCallback((_) => _getDisplayProducts());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StrRes.appName),
      ),
      body: Container(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode){
              Widget body;
              switch (mode){
                case LoadStatus.idle : body =  Text(StrRes.pullUpload); break;
                case LoadStatus.loading : body =  CupertinoActivityIndicator(); break;
                case LoadStatus.failed : body = Text(StrRes.loadFailed); break;
                case LoadStatus.canLoading : body = Text(StrRes.loadMore); break;
                default: body = Text(StrRes.noData); break;
              }
              return Container(
                height: 55.0,
                child: Center(child:body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          child: GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.only(
              right: 25,
              left: 25,
              bottom: 5,
              top: 5,
            ),
            childAspectRatio: 9.5/15,
            children: List.generate(_globalVar.displaySortFilterProducts.length, (index) {
              return Container(
                margin: EdgeInsets.only(
                    left: 7.5,
                    right: 7.5,
                    top: 7
                ),
                child: GestureDetector(
                  onTap: (){
                    _onProductSelected(context, _globalVar.displaySortFilterProducts[index].id);
                  },
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
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Container(
                                  child: Image.network(
                                    _globalVar.displaySortFilterProducts[index].image,
                                    width: 80,
                                    height: 80,
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: ColorRes.PRIMARY,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      ' \$' + _globalVar.displaySortFilterProducts[index].price.toString() + ' ',
                                      style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
                                    ),
                                  ),
                                )
                              ]
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                right: 15,
                                left: 15
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    _globalVar.displaySortFilterProducts[index].title,
                                    style: Theme.of(context).textTheme.overline.copyWith(fontWeight: FontWeight.bold, color: ColorRes.PRIMARY),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              right: 15,
                              left: 15,
                              bottom: 5,
                              top: 5
                            ),
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.bottomLeft,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.blueGrey[200],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Text(
                                        ' ' + _globalVar.displaySortFilterProducts[index].category + ' ',
                                        style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      bottomNavigationBar:
      _globalVar.productToCart.isNotEmpty?
      BottomAppBar(
        child: Container(
          height: 80,
          child: Container(
            margin: EdgeInsets.all(15),
            child: RaisedButton(
              onPressed: () {
                navigateSlideLeft(context, CartScreen(notifyParent: refresh));
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
                    StrRes.viewCart,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ):
      BottomAppBar(child: Container(height: 0,),),
      floatingActionButton: FloatingActionButton(
        heroTag: 'unique',
        child: Image.asset(
          AssetRes.sortFilter,
          color: Colors.white,
          width: 30, height: 30,
        ),
        backgroundColor: ColorRes.PRIMARY,
        onPressed: () {
          _onSortFilterPressed(context);
        },
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onProductSelected(context, int id){
    _getProduct(id);
  }

  void _onSortFilterPressed(context){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc){
          return SortAndFilterWidget(notifyParent: refresh);
        }
    );
  }

  void refresh() {
    setState(() {});
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refresh = true;
    if(_globalVar.sortFilter){
      _globalVar.displaySortFilterProducts.clear();
      _sfLimit = 4;
      for(var i = 0 ; i <_sfLimit ; i++){
        _globalVar.displaySortFilterProducts.add(_globalVar.sortFilterProducts[i]);
      }
      _refreshController.refreshCompleted();
    }else{
      _getDisplayProducts();
    }


  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _load = true;
    if(_globalVar.sortFilter){
      if(_globalVar.firstSortFilter){
        _globalVar.firstSortFilter = false;
        _sfLimit = 4;
      }
      DevLog.d(DevLog.ADI,'if 1');
      if(_globalVar.displaySortFilterProducts.length >= _globalVar.sortFilterProducts.length){
        _refreshController.loadComplete();
        DevLog.d(DevLog.ADI,'if 2');
      } else{
        _sfLimit += 4;
        DevLog.d(DevLog.ADI,'if 3 '+_sfLimit.toString());
        _globalVar.displaySortFilterProducts.clear();
        for(var i = 0 ; i < _sfLimit ; i++){
          DevLog.d(DevLog.ADI,'if 4 '+i.toString());
          if(i == _globalVar.sortFilterProducts.length) {
            DevLog.d(DevLog.ADI,'if 5');
            break;
          }
          _globalVar.displaySortFilterProducts.add(_globalVar.sortFilterProducts[i]);
        }
        setState(() {
        });
        _refreshController.loadComplete();
      }
    }else{
      DevLog.d(DevLog.ADI,'if 6');
      _limit += 4;
      if(_limit <= 20){
        _getDisplayProducts();
      }else{
        _limit = 20;
        _refreshController.loadComplete();
      }
    }

    if(mounted) {
      setState(() {
      });
    }

  }

  void _getDisplayProducts() {
    DevLog.d(DevLog.ADI, 'Get All Products Message');
    if(_firstBuild){
      _firstBuild = false;
      Future<ProgressDialog> ftProgressDialog = loadingDialog(context, StrRes.plsWait);
      ftProgressDialog.then((progressDialog) {
        Future<String> ftDisplayProducts = getLimitProducts(_limit.toString());
        ftDisplayProducts.then((onValue) {
          progressDialog.hide();
          if (onValue.length == 0) {
            _showErrorDialog('Server Error');
          } else {
            _handleGetdisplayProductsMessage(onValue);
          }
        });
      });
    } else{
      Future<String> ftDisplayProducts = getLimitProducts(_limit.toString());
      ftDisplayProducts.then((onValue) {
        if (onValue.length == 0) {
          _showErrorDialog('Server Error');
        } else {
          _handleGetdisplayProductsMessage(onValue);
        }
      });
    }
  }

  void _handleGetdisplayProductsMessage(String response) async {
    List<dynamic> jsonData = parseResponse(response);
    _globalVar.displayProducts.clear();
    for(var i = 0; i < jsonData.length; i++){
      // DevLog.d(DevLog.ADI, 'where : ' + _globalVar.displayProducts.where((element) => _globalVar.displayProducts[i].id == jsonData[i]['id']).toString());
      // DevLog.d(DevLog.ADI, 'i = ' + i.toString());
      Product _product = Product(
        id : jsonData[i]['id'],
        title : jsonData[i]['title'],
        price : jsonData[i]['price'].toDouble(),
        description : jsonData[i]['description'],
        category : jsonData[i]['category'],
        image : jsonData[i]['image'],
      );
      // DevLog.d(DevLog.ADI, 'product : ' + _product.toString());
      _globalVar.displayProducts.add(_product);

    }
    _globalVar.displaySortFilterProducts.clear();
    _globalVar.displaySortFilterProducts.addAll(_globalVar.displayProducts);
    setState(() {
    });
    if(_refresh){
      _refresh = false;
      _refreshController.refreshCompleted();
    }else if(_load){
      _load = false;
      _refreshController.loadComplete();
    }
    // DevLog.d(DevLog.ADI, 'displayProducts : ' + _globalVar.displayProducts.toString());
  }

  void _getProduct(int id) {
    DevLog.d(DevLog.ADI, 'Get Product Message');
    Future<ProgressDialog> ftProgressDialog = loadingDialog(context, StrRes.plsWait);
    ftProgressDialog.then((progressDialog) {
      Future<String> ftProduct = getProduct(id.toString());
      ftProduct.then((onValue) {
        // DevLog.d(DevLog.ADI, 'Get Product Response : $onValue');
        progressDialog.hide();
        if (onValue.length == 0) {
          _showErrorDialog('Server Error');
        } else {
          _handleGetProductMessage(onValue);
        }
      });
    });
  }

  void _handleGetProductMessage(String response) async {
    Map<String, dynamic> jsonData = parseResponse2(response);
    Product product = Product(
      id : jsonData['id'],
      title : jsonData['title'],
      price : jsonData['price'].toDouble(),
      description : jsonData['description'],
      category : jsonData['category'],
      image : jsonData['image'],
    );
    DevLog.d(DevLog.ADI, 'product : ' + product.toString());
    navigateSlideLeft(context, ProductScreen(product,notifyParent: refresh));
  }

  void _showErrorDialog(String contentText) {
    lxShowDialog(
        context,'Error', contentText,
        btnPressed: () {
        });
  }
}