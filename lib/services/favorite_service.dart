import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_model.dart';

class FavoriteService {
  static const String prefFavoritesKey = 'cinema_favorite_movies';

  static Future<List<MovieModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(prefFavoritesKey) ?? [];
    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return MovieModel.fromJson(map);
    }).toList();
  }

  static Future<void> addFavorite(MovieModel movie) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();
    if (!list.any((m) => m.id == movie.id)) {
      list.add(movie);
      final rawList = list.map((m) => jsonEncode(m.toJson())).toList();
      await prefs.setStringList(prefFavoritesKey, rawList);
    }
  }

  static Future<void> removeFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();
    list.removeWhere((m) => m.id == movieId);
    final rawList = list.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(prefFavoritesKey, rawList);
  }

  static Future<bool> isFavorite(int movieId) async {
    final list = await getFavorites();
    return list.any((m) => m.id == movieId);
  }
}

