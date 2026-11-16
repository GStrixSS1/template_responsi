import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/meal_model.dart';
import '../services/favorite_service.dart';

class FavoriteController extends GetxController {
  final RxList<MealModel> favorites = <MealModel>[].obs;
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

  bool isFavorite(String mealId) {
    return favorites.any((m) => m.id == mealId);
  }

  Future<void> toggleFavorite(MealModel meal) async {
    final alreadyFav = isFavorite(meal.id);

    if (alreadyFav) {
      await FavoriteService.removeFavorite(meal.id);
      favorites.removeWhere((m) => m.id == meal.id);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Favorit Dihapus',
        '${meal.name} dihapus dari daftar menu favorit.',
        backgroundColor: Colors.redAccent.withAlpha(230),
        colorText: Colors.white,
        icon: const Icon(Icons.favorite_border, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      await FavoriteService.addFavorite(meal);
      favorites.add(meal);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Favorit Ditambahkan',
        '${meal.name} berhasil ditambahkan ke menu favorit!',
        backgroundColor: const Color(0xFFF59E0B),
        colorText: Colors.black,
        icon: const Icon(Icons.favorite, color: Colors.redAccent),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> removeFavoriteOnSwipe(MealModel meal) async {
    await FavoriteService.removeFavorite(meal.id);
    favorites.removeWhere((m) => m.id == meal.id);

    Get.closeAllSnackbars();
    Get.snackbar(
      'Favorit Dihapus',
      '${meal.name} berhasil dihapus dari daftar menu favorit.',
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

