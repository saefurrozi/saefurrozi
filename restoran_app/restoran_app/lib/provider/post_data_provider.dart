import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:restoran_app/model/post_model.dart';
import 'package:http/http.dart' as http;

class PostDataProvider with ChangeNotifier {
  PostModel post = PostModel(
      message: '',
      restaurant: PostModelRestaurant(
          pictureId: '',
          id: '',
          rating: 0,
          customerReviews: [],
          address: '',
          city: '',
          menus: PostModelRestaurantMenus(foods: [], drinks: []),
          categories: [],
          name: '',
          description: ''),
      error: true);
  bool loading = false;
  bool error = true;

  getPostData(context, str) async {
    loading = true;
    post = await getSinglePostData(context, str);
    loading = false;
    error = post.message == "no connection" ? true : false;

    notifyListeners();
  }

  Future<PostModel> getSinglePostData(context, str) async {
    PostModel result = new PostModel(
        message: '',
        restaurant: PostModelRestaurant(
            pictureId: '',
            id: '',
            rating: 0,
            customerReviews: [],
            address: '',
            city: '',
            menus: PostModelRestaurantMenus(foods: [], drinks: []),
            categories: [],
            name: '',
            description: ''),
        error: true);
    try {
      final response = await http.get(
        Uri.parse("https://restaurant-api.dicoding.dev/detail/$str"),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
      if (response.statusCode == 200) {
        final item = json.decode(response.body);
        result = PostModel.fromJson(item);
        log(item.toString());
      }
    } catch (e) {
      log(e.toString());
      result.message = "no connection";
    }
    return result;
  }
}
