import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/news_model.dart';
import '../services/favorite_service.dart';

class FavoriteController extends GetxController {
  final RxList<NewsModel> favorites = <NewsModel>[].obs;
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

  bool isFavorite(String newsId) {
    return favorites.any((n) => n.id == newsId);
  }

  Future<void> toggleFavorite(NewsModel news) async {
    final alreadyFav = isFavorite(news.id);

    if (alreadyFav) {
      await FavoriteService.removeFavorite(news.id);
      favorites.removeWhere((n) => n.id == news.id);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Bookmark Dihapus',
        'Berita dihapus dari daftar bookmark.',
        backgroundColor: Colors.redAccent.withAlpha(230),
        colorText: Colors.white,
        icon: const Icon(Icons.bookmark_border, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      await FavoriteService.addFavorite(news);
      favorites.add(news);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Disimpan ke Bookmark',
        'Berita berhasil disimpan untuk dibaca nanti!',
        backgroundColor: const Color(0xFFDC2626),
        colorText: Colors.white,
        icon: const Icon(Icons.bookmark, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> removeFavoriteOnSwipe(NewsModel news) async {
    await FavoriteService.removeFavorite(news.id);
    favorites.removeWhere((n) => n.id == news.id);

    Get.closeAllSnackbars();
    Get.snackbar(
      'Bookmark Dihapus',
      'Berita berhasil dihapus dari bookmark.',
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
