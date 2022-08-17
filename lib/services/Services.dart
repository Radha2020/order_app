import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/model/mybanner.dart';
import 'package:order_app/model/category.dart';

import 'package:order_app/model/items.dart';
import 'package:order_app/model/history.dart';

import 'package:order_app/DBHelp.dart';

class Services {
  static Future<List<MyBanner>> fetchBanner() async {
    print("fetching BannerImages");

    String url = 'http://techmugavari.co.in/hosp/Apiorder/flutbanners';

    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      http.Response response = await http.get(url, headers: headers);
      print(response.body.toString());
      var jsonBody = response.body;
      var jsonData = json.decode(jsonBody);
      print(jsonData);
      List<MyBanner> bannerList = parseBanners(response.body);
      return bannerList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<Category>> fetchCategory() async {
    print("fetching CategoryImages");
    String url = 'http://techmugavari.co.in/hosp/Apiorder/flutcategories';

    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      http.Response response = await http.get(url, headers: headers);
      print(response.body.toString());
      var jsonBody = response.body;
      var jsonData = json.decode(jsonBody);
      print(jsonData);
      List<Category> categoryList = parseCategories(response.body);
      return categoryList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<MyBanner>> fetchProductsPerId(catid) async {
    print("CATID:");
    print(catid);
    String b = json.encode({'catid': catid});

    print("fetching BannerImages");

    String url = 'https://techmugavari.co.in/hosp/Apiorder/flutbannersperId';

    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      http.Response response = await http.post(url, headers: headers, body: b);
      print(response.body.toString());
      var jsonBody = response.body;
      var jsonData = json.decode(jsonBody);
      print(jsonData);
      List<MyBanner> bannerList = parseBanners(response.body);
      return bannerList;
    } catch (e) {
      //throw Exception(e.toString());
    }

    /* String url = 'http://techmugavari.co.in/hosp/Apiorder/flutitemsperid';

    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      http.Response response = await http.post(url, headers: headers);
      //body: b,

      print("response");
      print(response.body.toString());
      var jsonBody = response.body;
      var jsonData = json.decode(jsonBody);
      print(jsonData);
      //List<MyBanner> bannerList = parseBanners(response.body);
      //return bannerList;
    } catch (e) {
      throw Exception(e.toString());
    }*/
  }

  static Future<List<Items>> fetchData() async {
    print("fetching data");
    String url = 'http://techmugavari.co.in/hosp/Apiorder/flutitems';

    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonBody = response.body;
        var jsonData = json.decode(jsonBody);
        print(jsonData);
        //print(response.toString());
        List<Items> items = parseItems(response.body);
        return items;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<List<History>> fetchHistory() async {
    print("fetching data");
    String url = 'http://techmugavari.co.in/hosp/Apiorder/orderhistory';

    Map<String, String> headers = {"Content-type": "application/json"};
    try {
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        var jsonBody = response.body;
        var jsonData = json.decode(jsonBody);
        print(jsonData);
        //print(response.toString());
        List<History> history = parseHistory(response.body);
        return history;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<MyBanner> parseBanners(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<MyBanner>((json) => MyBanner.fromJson(json)).toList();
  }

  static List<Category> parseCategories(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Category>((json) => Category.fromJson(json)).toList();
  }

  static List<Items> parseItems(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Items>((json) => Items.fromJson(json)).toList();
  }

  static List<History> parseHistory(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<History>((json) => History.fromJson(json)).toList();
  }
}
