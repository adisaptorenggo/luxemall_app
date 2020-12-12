import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luxemall_app/models/product.dart';
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
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  bool _refresh = false, _load = false;

  @override
  void initState() {
    GlobalVar().allProducts = List();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getAllProducts());
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
                    child: GlobalVar().allProducts[index].title != null?
                    Image.network(
                      GlobalVar().allProducts[index].image,
                      height: 60, width: 60,
                    ) :
                    Container(),
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                          GlobalVar().allProducts[index].title != null?
                          GlobalVar().allProducts[index].title : ''
                      ),
                    ),
                  )
                ],
              ),
            ),
            itemExtent: 100.0,
            itemCount: GlobalVar().allProducts.length,
          ),
        ),
      ),
      bottomNavigationBar:
      GlobalVar().addToCart?
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
                      ColorRes.SECONDARY,
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
                    style: TextStyle(color: ColorRes.SECONDARY),
                  ),
                ),
              ),
            ),
          ),
        ),
      ):
      BottomAppBar(child: Container(),),
      floatingActionButton: FloatingActionButton(
        // onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refresh = true;
    _getAllProducts();


  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));

    _load = true;
    _limit += 4;
    if(_limit <= 20){
      _getAllProducts();
    }else{
      _limit = 20;
      _refreshController.loadNoData();
    }

    if(mounted) {
      setState(() {});
    }

  }

  void _getAllProducts() {
    DevLog.d(DevLog.ADI, 'Get All Products Message');
    Future<String> ftAllProducts = getAllProducts(_limit.toString());
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
    GlobalVar().allProducts.clear();
    for(var i = 0; i < jsonData.length; i++){
      // DevLog.d(DevLog.ADI, 'where : ' + GlobalVar().allProducts.where((element) => GlobalVar().allProducts[i].id == jsonData[i]['id']).toString());
      // DevLog.d(DevLog.ADI, 'i = ' + i.toString());
      Product _product = Product(
        id : 0,
        title : jsonData[i]['title'],
        price : jsonData[i]['title'],
        description : jsonData[i]['title'],
        category : jsonData[i]['title'],
        image : jsonData[i]['image'],
      );
      // DevLog.d(DevLog.ADI, 'product : ' + _product.toString());
      GlobalVar().allProducts.add(_product);
      setState(() {
      });
    }
    if(_refresh){
      _refresh = false;
      _refreshController.refreshCompleted();
    }else if(_load){
      _load = false;
      _refreshController.loadComplete();
    }
    // DevLog.d(DevLog.ADI, 'allProducts : ' + GlobalVar().allProducts.toString());
  }

  void _showErrorDialog(String contentText) {
    lxShowDialog(
        context,'Error', contentText,
        btnPressed: () {
        });
  }
}