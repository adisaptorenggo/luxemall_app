import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luxemall_app/utils/assets_resource.dart';
import 'package:luxemall_app/utils/colors_resource.dart';
import 'package:luxemall_app/utils/dev_log.dart';
import 'package:luxemall_app/utils/global_variables.dart';
import 'package:luxemall_app/utils/string_resource.dart';

class SortAndFilterWidget extends StatefulWidget {

  final Function() notifyParent;
  SortAndFilterWidget({Key key, @required this.notifyParent}) : super(key: key);

  @override
  _SortAndFilterWidgetState createState() => _SortAndFilterWidgetState();
}

class _SortAndFilterWidgetState extends State<SortAndFilterWidget> {

  GlobalVar _globalVar = GlobalVar();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.58,
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: 10, bottom: 10
            ),
            child: Image.asset(
              AssetRes.mainLogo,
              width: 30, height: 30,
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 15.0,
                        ),
                        child: Text(
                          'Sort',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: ColorRes.SECONDARY))
                  ),
                  child: Container(
                      margin: EdgeInsets.only(
                        left: 15.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    StrRes.chooseSort,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 30.0,
                                    left: 30.0,
                                  ),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: ColorRes.PRIMARY, width:1.0),
                                      borderRadius: BorderRadius.circular(80.0),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_globalVar.sortType == 'asc') {
                                          _globalVar.sortType = '';
                                        } else {
                                          _globalVar.sortType = 'asc';
                                        }
                                      });
                                    },
                                    color: _globalVar.sortType == 'asc' ? ColorRes.PRIMARY : Colors.white,
                                    child: Container( // min sizes for Material buttons
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Lowest Price',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: _globalVar.sortType == 'asc' ? Colors.white : ColorRes.PRIMARY
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    right: 30.0,
                                    left: 30.0,
                                    bottom: 10,
                                  ),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: ColorRes.PRIMARY, width:1.0),
                                      borderRadius: BorderRadius.circular(80.0),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_globalVar.sortType == 'desc') {
                                          _globalVar.sortType = '';
                                        } else {
                                          _globalVar.sortType = 'desc';
                                        }
                                      });
                                    },
                                    color: _globalVar.sortType == 'desc' ? ColorRes.PRIMARY : Colors.white,
                                    child: Container( // min sizes for Material buttons
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Highest Price',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: _globalVar.sortType == 'desc' ? Colors.white : ColorRes.PRIMARY
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 5,
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 15.0,
                        ),
                        child: Text(
                          'Filter',
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: ColorRes.SECONDARY))
                  ),
                  child: Container(
                      margin: EdgeInsets.only(
                          left: 15.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    StrRes.chooseCategory,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 40,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (c, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      right: 5.0,
                                      top: 2.0,
                                      bottom: 2.0
                                  ),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: ColorRes.PRIMARY, width:1.0),
                                      borderRadius: BorderRadius.circular(80.0),

                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (_globalVar.displayCategoryFilterValue.contains(_globalVar.displayCategory[index])){
                                          _globalVar.displayCategoryFilterValue.remove(_globalVar.displayCategory[index]);
                                        }else {
                                          _globalVar.displayCategoryFilterValue.add(_globalVar.displayCategory[index]);
                                        }
                                      });
                                    },
                                    color: _globalVar.displayCategoryFilterValue.length == 0 || !_globalVar.displayCategoryFilterValue.contains(_globalVar.displayCategory[index]) ? Colors.white : ColorRes.PRIMARY,
                                    child: Container( // min sizes for Material buttons
                                      alignment: Alignment.center,
                                      child: Text(
                                        _globalVar.displayCategory[index],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: _globalVar.displayCategoryFilterValue.length == 0 || !_globalVar.displayCategoryFilterValue.contains(_globalVar.displayCategory[index])? ColorRes.PRIMARY : Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: _globalVar.displayCategory.length,
                            ),
                          )
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 25,
              bottom: 15,
              left: 15,
              right: 15
            ),
            child: RaisedButton(
              onPressed: () {
                if(_globalVar.sortType == '' && _globalVar.displayCategoryFilterValue.isEmpty){
                  DevLog.d(DevLog.ADI, 'if : 1');
                  _globalVar.sortFilterProducts.clear();
                  _globalVar.displaySortFilterProducts.clear();
                  _globalVar.displaySortFilterProducts.addAll(_globalVar.displayProducts);
                  _globalVar.sortFilter = false;
                }
                else if(_globalVar.sortType != '' && _globalVar.displayCategoryFilterValue.isEmpty){
                  DevLog.d(DevLog.ADI, 'if : 2');
                  _globalVar.sortFilterProducts.clear();
                  _globalVar.displaySortFilterProducts.clear();
                  _globalVar.displaySortFilterProducts.addAll(_globalVar.displayProducts);
                  if(_globalVar.sortType == 'asc'){
                    _globalVar.displaySortFilterProducts.sort((a, b) => a.price.compareTo(b.price));
                  } else{
                    _globalVar.displaySortFilterProducts.sort((a, b) => b.price.compareTo(a.price));
                  }
                }
                else if(_globalVar.sortType == '' && _globalVar.displayCategoryFilterValue.isNotEmpty){
                  DevLog.d(DevLog.ADI, 'if : 3');
                  _globalVar.sortFilterProducts.clear();
                  _globalVar.displaySortFilterProducts.clear();
                  _globalVar.sortFilter = true;
                  var j = 0;
                  for(var i = 0; i < _globalVar.allProducts.length ; i++){
                    if(_globalVar.displayCategoryFilterValue.any((element) => element == _globalVar.allProducts[i].category)){
                      _globalVar.sortFilterProducts.add(_globalVar.allProducts[i]);
                      if(j < 4){
                        _globalVar.displaySortFilterProducts.add(_globalVar.allProducts[i]);
                      }
                      j ++;
                      // DevLog.d(DevLog.ADI, 'display sf: ' + _globalVar.displaySortFilterProducts.toString());
                    }
                  }
                }
                else{
                  DevLog.d(DevLog.ADI, 'if : 4');
                  _globalVar.sortFilterProducts.clear();
                  _globalVar.displaySortFilterProducts.clear();
                  _globalVar.sortFilter = true;
                  for(var i = 0; i < _globalVar.allProducts.length ; i++){
                    if(_globalVar.displayCategoryFilterValue.any((element) => element == _globalVar.allProducts[i].category)){
                      _globalVar.sortFilterProducts.add(_globalVar.allProducts[i]);
                      // DevLog.d(DevLog.ADI, 'display sf: ' + _globalVar.displaySortFilterProducts.toString());
                    }
                  }
                  if(_globalVar.sortType == 'asc'){
                    _globalVar.sortFilterProducts.sort((a, b) => a.price.compareTo(b.price));
                  } else{
                    _globalVar.sortFilterProducts.sort((a, b) => b.price.compareTo(a.price));
                  }
                  var j=0;
                  for(var i = 0 ; i < _globalVar.sortFilterProducts.length; i++){
                    if(j < 4){
                      _globalVar.displaySortFilterProducts.add(_globalVar.sortFilterProducts[i]);
                    }
                    j ++;
                  }

                }
                widget.notifyParent();
                // DevLog.d(DevLog.ADI, 'display sf final: ' + _globalVar.displaySortFilterProducts.toString());
                Navigator.pop(context);
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
                    'Apply',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}