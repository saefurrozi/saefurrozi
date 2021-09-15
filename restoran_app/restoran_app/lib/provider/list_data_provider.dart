import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:restoran_app/model/list_model.dart';
import 'package:http/http.dart' as http;

class ListDataProvider with ChangeNotifier {
  ListModel post = ListModel(restaurants: [], error: false);
  bool loading = false;
  bool error = true;

  getPostData(context, str, isAll) async {
    loading = true;
    post = await getSinglePostData(context, str, isAll);
    loading = false;
    error = post.error == true ? true : false;

    notifyListeners();
  }

  Future<ListModel> getSinglePostData(context, str, isAll) async {
    ListModel result = new ListModel(restaurants: [], error: false);
    try {
      String urlData = isAll == true
          ? "https://restaurant-api.dicoding.dev/list"
          : "https://restaurant-api.dicoding.dev/search?q=$str";
      final response = await http.get(
        Uri.parse(urlData),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
      if (response.statusCode == 200) {
        final item = json.decode(response.body);
        result = ListModel.fromJson(item);
        log(item.toString());
      }
    } catch (e) {
      log(e.toString());
      result.error = true;
    }
    return result;
  }
}
