import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:restoran_app/model/list_model.dart';

class ApiService {
  final Client client;

  ApiService(this.client);

  Future<ListModel> getListRestaurant() async {
    String urlData = "https://restaurant-api.dicoding.dev/list";
    final response = await client.get(Uri.parse(urlData));
    if (response.statusCode == 200) {
      return ListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant info');
    }
  }
}
