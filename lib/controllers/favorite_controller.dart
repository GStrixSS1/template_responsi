import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/favorite_service.dart';

class FavoriteController extends GetxController {
  final RxList<ProductModel> wishlist = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    isLoading.value = true;
    try {
      final list = await FavoriteService.getWishlist();
      wishlist.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  bool isWishlist(int productId) {
    return wishlist.any((p) => p.id == productId);
  }

  Future<void> toggleWishlist(ProductModel product) async {
    final alreadyInWishlist = isWishlist(product.id);

    if (alreadyInWishlist) {
      await FavoriteService.removeFromWishlist(product.id);
      wishlist.removeWhere((p) => p.id == product.id);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Wishlist',
        '${product.title} dihapus dari wishlist!',
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        icon: const Icon(Icons.favorite_border, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      await FavoriteService.addToWishlist(product);
      wishlist.add(product);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Wishlist',
        '${product.title} berhasil ditambahkan ke wishlist!',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        icon: const Icon(Icons.favorite, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> removeWishlistOnSwipe(ProductModel product) async {
    await FavoriteService.removeFromWishlist(product.id);
    wishlist.removeWhere((p) => p.id == product.id);

    Get.closeAllSnackbars();
    Get.snackbar(
      'Wishlist',
      '${product.title} berhasil dihapus dari wishlist.',
      backgroundColor: const Color(0xFFEF4444),
      colorText: Colors.white,
      icon: const Icon(Icons.delete_outline, color: Colors.white),
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}

