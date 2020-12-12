import 'dart:convert';

import 'package:http/http.dart';

import 'package:luxemall_app/utils/dev_log.dart';

class HttpRequest{

  static Future<String> httpGet(String url) async {
    DevLog.d(DevLog.ADI, 'HTTP GET Url : $url');
    try{
      Response response = await get(url);
      int statusCode = response.statusCode;
      DevLog.d(DevLog.ADI, 'HTTP GET Status Code : $statusCode');
      return response.body;
    }catch(e, s){
      DevLog.d(DevLog.ADI, "The exception thrown is $e");
      DevLog.d(DevLog.ADI, "STACK TRACE \n $s");
    }

    return '';
  }

  static Future<Response> httpPostFullResponse(String url, String body, Map<String, String> headers) async {
    DevLog.d(DevLog.ADI, 'HTTP POST Url : $url');
    for (String keys in headers.keys){
      DevLog.d(DevLog.ADI, 'HTTP Header : $keys - ${headers[keys]}');
    }
    DevLog.d(DevLog.ADI, 'HTTP POST Body : $body');
    try{
      Response response = await post(url, headers: headers, body: body).timeout(const Duration(seconds: 30));
      int statusCode = response.statusCode;
      DevLog.d(DevLog.ADI, 'HTTP POST Status Code : $statusCode');
      return response;
    }catch(e, s){
      DevLog.d(DevLog.ADI, "The exception thrown is $e");
      DevLog.d(DevLog.ADI, "STACK TRACE \n $s");
    }

    return null;
  }

  static Map<String, String> createHeader(){
    Map<String, String> headers = {'Content-type': 'application/json'};
    return headers;
  }
}

List<dynamic> parseResponse(String response){
  return jsonDecode(response);
}

Map<String, dynamic> parseResponse2(String response){
  return jsonDecode(response);
}

Future<String> getAllProducts() {
  String url = 'https://fakestoreapi.com/products';

  return HttpRequest.httpGet(url);
}

Future<String> getLimitProducts(String limit) {
  String url = 'https://fakestoreapi.com/products?limit=' + limit;

  return HttpRequest.httpGet(url);
}

Future<String> getProduct(String id) {
  String url = 'https://fakestoreapi.com/products/' + id;

  return HttpRequest.httpGet(url);
}

Future<String> sendAddToCart(int userID, String date, Map<String, int> cart) {
  String url = 'https://fakestoreapi.com/carts';
  DevLog.d(DevLog.ADI, 'sendAddToCartMessage : $url');
  Map<String, dynamic> jsonData = {
    "userID": userID,
    "date": date,
    "products": cart,
  };

  return sendMessage(url, jsonData);
}

Future<String> sendMessage(String url, Map<String, dynamic> jsonData) async{
  String messageBody = jsonEncode(jsonData);
  DevLog.d(DevLog.ADI, 'Message Body : $messageBody');
  Response response = await HttpRequest.httpPostFullResponse(url, messageBody, HttpRequest.createHeader());
  if (response != null){
    return response.body;
  }else {
    return '';
  }
}

