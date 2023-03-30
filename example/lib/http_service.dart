import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class HttpService {
  final String postsURL = "https://freshfood-api.dexbytes.in/api/";
  final String searchApi = "search/suggestions";
  var headers = {
    'Content-type' : 'application/json',
    'Accept' : 'application/json'
  };

  Future<String> getPosts(Map<String,dynamic> requestData) async {
    var requestBody = json.encode(requestData);
    String fullUrl = postsURL+searchApi;
    Response res = await post(Uri.parse(fullUrl), headers: headers, body: requestBody,)
        .timeout(const Duration(seconds: 30));
    if (res.statusCode == 200) {
      try {
       // var body = jsonDecode(res.body);
        String body = res.body;
        return body;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return "";
      }
    } else {
      return "";
    }
  }

}

final HttpService httpService = HttpService();