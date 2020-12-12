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
}

List<dynamic> parseResponse(String response){
  return jsonDecode(response);
}


Future<String> getAllProducts(String limit) {
  String url = 'https://fakestoreapi.com/products?limit=' + limit;

  return HttpRequest.httpGet(url);
}

