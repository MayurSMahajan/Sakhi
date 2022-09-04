import 'dart:async';

import 'package:http/http.dart' as http;

import 'LatLang.dart';

String apiUrl = "192.168.154.131:4000";
String apiPathPrefix = "/getLatLong";

class ShopServices {
  static Future getShops() async {
    try {
      final response =
          await http.get(Uri.http(apiUrl, "${apiPathPrefix}Shops"));
      if (response.statusCode == 200) {
        print("Shops Fetched");
        List<LatLong> getList = latLongFromJson(response.body);
        return getList;
      } else {
        return "Error: ${response.statusCode} ( ${response.reasonPhrase} ) occured!";
      }
    } catch (err) {
      print(err);
      return [];
    }
  }

  static Future getToilets() async {
    try {
      final response =
          await http.get(Uri.http(apiUrl, "${apiPathPrefix}Toilets"));
      if (response.statusCode == 200) {
        print("Toilets Fetched");
        List<LatLong> getList = latLongFromJson(response.body);
        return getList;
      } else {
        return "Error: ${response.statusCode} ( ${response.reasonPhrase} ) occured!";
      }
    } catch (err) {
      print(err);
      return [];
    }
  }
}
