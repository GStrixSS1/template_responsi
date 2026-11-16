import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class FavoriteService {
  static const String prefFavoritesKey = 'ecommerce_favorite_products';

  static Future<List<ProductModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(prefFavoritesKey) ?? [];
    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return ProductModel.fromJson(map);
    }).toList();
  }

  static Future<void> addFavorite(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();
    if (!list.any((p) => p.id == product.id)) {
      list.add(product);
      final rawList = list.map((p) => jsonEncode(p.toJson())).toList();
      await prefs.setStringList(prefFavoritesKey, rawList);
    }
  }

  static Future<void> removeFavorite(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();
    list.removeWhere((p) => p.id == productId);
    final rawList = list.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(prefFavoritesKey, rawList);
  }

  static Future<bool> isFavorite(int productId) async {
    final list = await getFavorites();
    return list.any((p) => p.id == productId);
  }
}
