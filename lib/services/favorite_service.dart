import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';

class FavoriteService {
  static const String prefWishlistKey = 'shoppinghub_wishlist_products';

  static Future<List<ProductModel>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(prefWishlistKey) ?? [];
    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return ProductModel.fromJson(map);
    }).toList();
  }

  static Future<void> addToWishlist(ProductModel product) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getWishlist();
    if (!list.any((p) => p.id == product.id)) {
      list.add(product);
      final rawList = list.map((p) => jsonEncode(p.toJson())).toList();
      await prefs.setStringList(prefWishlistKey, rawList);
    }
  }

  static Future<void> removeFromWishlist(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getWishlist();
    list.removeWhere((p) => p.id == productId);
    final rawList = list.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(prefWishlistKey, rawList);
  }

  static Future<bool> isWishlist(int productId) async {
    final list = await getWishlist();
    return list.any((p) => p.id == productId);
  }
}

