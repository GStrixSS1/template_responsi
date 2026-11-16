import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/news_model.dart';

class FavoriteService {
  static const String prefFavoritesKey = 'news_bookmarked_articles';

  static Future<List<NewsModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(prefFavoritesKey) ?? [];
    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return NewsModel.fromJson(map);
    }).toList();
  }

  static Future<void> addFavorite(NewsModel news) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();
    if (!list.any((n) => n.id == news.id)) {
      list.add(news);
      final rawList = list.map((n) => jsonEncode(n.toJson())).toList();
      await prefs.setStringList(prefFavoritesKey, rawList);
    }
  }

  static Future<void> removeFavorite(String newsId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();
    list.removeWhere((n) => n.id == newsId);
    final rawList = list.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(prefFavoritesKey, rawList);
  }

  static Future<bool> isFavorite(String newsId) async {
    final list = await getFavorites();
    return list.any((n) => n.id == newsId);
  }
}
