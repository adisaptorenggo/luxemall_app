import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  GlobalVar _globalVar = GlobalVar();

  @override
  void initState() {
    _globalVar.sortFilter = false;
    _globalVar.displayProducts = List();
    _globalVar.sortFilterProducts = List();
    _globalVar.displaySortFilterProducts = List();
    _globalVar.displayCategoryFilterValue = List();
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
          child: ListView.builder(
            itemBuilder: (c, index) => Container(
              child: Row(
                children: <Widget>[
                  Container(
                    child: _globalVar.displaySortFilterProducts[index].title != null?
                    Image.network(
                      _globalVar.displaySortFilterProducts[index].image,
                      height: 60, width: 60,
                    ) :
                    Container(),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        _globalVar.displaySortFilterProducts[index].price != null?
                        _globalVar.displaySortFilterProducts[index].price.toString() : ''
                      ),
                    ),
                  )
                ],
              ),
            ),
            itemExtent: 100.0,
            itemCount: _globalVar.displaySortFilterProducts.length,
          ),
        ),
      ),
      bottomNavigationBar:
      _globalVar.addToCart?
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
                    'View Cart',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ):
      BottomAppBar(child: Container(),),
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

    }else{
      _getDisplayProducts();
    }


  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _load = true;
    if(_globalVar.sortFilter){
      if(_globalVar.displaySortFilterProducts.length >= _globalVar.sortFilterProducts.length){
        _refreshController.loadNoData();
      } else{
        _sfLimit += 4;
        _globalVar.displaySortFilterProducts.clear();
        for(var i = 0 ; i <_sfLimit ; i++){
          _globalVar.displaySortFilterProducts.add(_globalVar.sortFilterProducts[i]);
        }
        setState(() {
        });
      }
    }else{
      _limit += 4;
      if(_limit <= 20){
        _getDisplayProducts();
      }else{
        _limit = 20;
        _refreshController.loadNoData();
      }
    }

    if(mounted) {
      setState(() {});
    }

  }

  void _getDisplayProducts() {
    DevLog.d(DevLog.ADI, 'Get All Products Message');
    Future<String> ftDisplayProducts = getLimitProducts(_limit.toString());
    ftDisplayProducts.then((onValue) {
      if (onValue.length == 0) {
        _showErrorDialog('Server Error');
      } else {
        _handleGetdisplayProductsMessage(onValue);
      }
    });
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

  void _showErrorDialog(String contentText) {
    lxShowDialog(
        context,'Error', contentText,
        btnPressed: () {
        });
  }
}