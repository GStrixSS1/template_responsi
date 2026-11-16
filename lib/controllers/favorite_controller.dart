import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/movie_model.dart';
import '../services/favorite_service.dart';

class FavoriteController extends GetxController {
  final RxList<MovieModel> favorites = <MovieModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    isLoading.value = true;
    try {
      final list = await FavoriteService.getFavorites();
      favorites.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavorite(int movieId) {
    return favorites.any((m) => m.id == movieId);
  }

  Future<void> toggleFavorite(MovieModel movie) async {
    final alreadyFav = isFavorite(movie.id);

    if (alreadyFav) {
      await FavoriteService.removeFavorite(movie.id);
      favorites.removeWhere((m) => m.id == movie.id);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Favorit Dihapus',
        '${movie.title} dihapus dari daftar favorit.',
        backgroundColor: Colors.redAccent.withAlpha(230),
        colorText: Colors.white,
        icon: const Icon(Icons.favorite_border, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      await FavoriteService.addFavorite(movie);
      favorites.add(movie);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Favorit Ditambahkan',
        '${movie.title} berhasil ditambahkan ke favorit!',
        backgroundColor: const Color(0xFFE50914),
        colorText: Colors.white,
        icon: const Icon(Icons.favorite, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> removeFavoriteOnSwipe(MovieModel movie) async {
    await FavoriteService.removeFavorite(movie.id);
    favorites.removeWhere((m) => m.id == movie.id);

    Get.closeAllSnackbars();
    Get.snackbar(
      'Favorit Dihapus',
      '${movie.title} berhasil dihapus dari daftar favorit.',
      backgroundColor: Colors.redAccent.withAlpha(230),
      colorText: Colors.white,
      icon: const Icon(Icons.delete_sweep, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}

