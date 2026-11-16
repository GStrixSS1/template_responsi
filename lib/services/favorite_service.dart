import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal_model.dart';

class FavoriteService {
  static const String prefFavoritesKey = 'restaurant_favorite_meals';

  static Future<List<MealModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(prefFavoritesKey) ?? [];
    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return MealModel.fromJson(map);
    }).toList();
  }

  static Future<void> addFavorite(MealModel meal) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();
    if (!list.any((m) => m.id == meal.id)) {
      list.add(meal);
      final rawList = list.map((m) => jsonEncode(m.toJson())).toList();
      await prefs.setStringList(prefFavoritesKey, rawList);
    }
  }

  static Future<void> removeFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();
    list.removeWhere((m) => m.id == mealId);
    final rawList = list.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(prefFavoritesKey, rawList);
  }

  static Future<bool> isFavorite(String mealId) async {
    final list = await getFavorites();
    return list.any((m) => m.id == mealId);
  }
}

