import 'package:flutter/foundation.dart';
import 'package:restoran_app/helper/db_helper.dart';
import 'package:restoran_app/model/fav_model.dart';

class DbProvider extends ChangeNotifier {
  List<Fav> _fav = [];
  late DbHelper _dbHelper;

  List<Fav> get favlist => _fav;

  DbProvider() {
    _dbHelper = DbHelper();
    _getAllFavList();
  }

  Future<void> addFav(Fav fav) async {
    await _dbHelper.insertFav(fav);
    _getAllFavList();
  }

  void _getAllFavList() async {
    _fav = await _dbHelper.getFavList();
    notifyListeners();
  }

  Future<Fav> getFavById(String id) async {
    return await _dbHelper.getFavById(id);
  }

  void updateFav(Fav fav) async {
    await _dbHelper.updateFav(fav);
    _getAllFavList();
  }

  void deleteFav(String id) async {
    await _dbHelper.deleteFav(id);
    _getAllFavList();
  }
}
