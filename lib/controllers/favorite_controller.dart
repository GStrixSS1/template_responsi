import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/favorite_service.dart';

class FavoriteController extends GetxController {
  final RxList<ProductModel> favorites = <ProductModel>[].obs;
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

  bool isFavorite(int productId) {
    return favorites.any((p) => p.id == productId);
  }

  Future<void> toggleFavorite(ProductModel product) async {
    final alreadyFav = isFavorite(product.id);

    if (alreadyFav) {
      await FavoriteService.removeFavorite(product.id);
      favorites.removeWhere((p) => p.id == product.id);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Wishlist Dihapus',
        '${product.title} dihapus dari wishlist favorit.',
        backgroundColor: Colors.redAccent.withAlpha(230),
        colorText: Colors.white,
        icon: const Icon(Icons.favorite_border, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      await FavoriteService.addFavorite(product);
      favorites.add(product);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Ditambahkan ke Wishlist',
        '${product.title} berhasil ditambahkan ke wishlist!',
        backgroundColor: const Color(0xFF6366F1),
        colorText: Colors.white,
        icon: const Icon(Icons.favorite, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> removeFavoriteOnSwipe(ProductModel product) async {
    await FavoriteService.removeFavorite(product.id);
    favorites.removeWhere((p) => p.id == product.id);

    Get.closeAllSnackbars();
    Get.snackbar(
      'Wishlist Dihapus',
      '${product.title} berhasil dihapus dari wishlist.',
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
