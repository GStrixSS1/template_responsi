// ============================================================================
// FILE: controllers/favorite_controller.dart
// ============================================================================
// FUNGSI FILE INI:
// State Management (GetX) untuk fitur FAVORIT / BOOKMARK / WISHLIST.
// Mengatur penambahan, penghapusan, pengecekan status favorit, dan animasi snackbar.
//
// CARA MANGGIL CONTROLLER INI DARI FILE SEBELAH (VIEW):
// 1. Ambil controller:
//      final FavoriteController favoriteController = Get.find<FavoriteController>();
// 2. Tombol Hati (Favorite Icon Button) di List / Detail View:
//      Obx(() {
//        final isFav = favoriteController.isFavorite(item.id);
//        return IconButton(
//          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
//          color: isFav ? Colors.redAccent : Colors.grey,
//          onPressed: () {
//            favoriteController.toggleFavorite(item); // <- Tambah/Hapus otomatis
//          },
//        );
//      })
// 3. Pada halaman FavoriteListView (Swipe to Remove):
//      Dismissible(
//        key: Key(item.id.toString()),
//        onDismissed: (_) => favoriteController.removeFavoriteOnSwipe(item),
//        child: Card(...),
//      )
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/character_model.dart';
import '../services/favorite_service.dart';

class FavoriteController extends GetxController {
  // List favorit yang reaktif (.obs), otomatis memperbarui tampilan di FavoriteListView
  final RxList<CharacterModel> favorites = <CharacterModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  // ==========================================================================
  // METHOD: Membaca data favorit dari SharedPreferences saat aplikasi start
  // ==========================================================================
  Future<void> loadFavorites() async {
    isLoading.value = true;
    try {
      final list = await FavoriteService.getFavorites();
      favorites.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================================================
  // METHOD: Cek apakah item sudah difavoritkan
  // Digunakan untuk menentukan icon (Icons.favorite vs Icons.favorite_border)
  // ==========================================================================
  bool isFavorite(int characterId) {
    return favorites.any((c) => c.id == characterId);
  }

  // ==========================================================================
  // METHOD: Toggle Favorit (Jika sudah ada -> Hapus, Jika belum ada -> Tambah)
  // Dipanggil saat ikon hati di Card atau di halaman Detail ditekan
  // ==========================================================================
  Future<void> toggleFavorite(CharacterModel character) async {
    final alreadyFav = isFavorite(character.id);

    if (alreadyFav) {
      // Jika sudah favorit -> Hapus dari SharedPreferences & List lokal
      await FavoriteService.removeFavorite(character.id);
      favorites.removeWhere((c) => c.id == character.id);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Favorit Dihapus',
        '${character.name} dihapus dari daftar favorit.',
        backgroundColor: Colors.redAccent.withAlpha(230),
        colorText: Colors.white,
        icon: const Icon(Icons.favorite_border, color: Colors.white),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      // Jika belum favorit -> Tambahkan ke SharedPreferences & List lokal
      await FavoriteService.addFavorite(character);
      favorites.add(character);

      Get.closeAllSnackbars();
      Get.snackbar(
        'Favorit Ditambahkan',
        '${character.name} berhasil ditambahkan ke favorit!',
        backgroundColor: const Color(0xFF00E599),
        colorText: Colors.black,
        icon: const Icon(Icons.favorite, color: Colors.redAccent),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  // ==========================================================================
  // METHOD: Hapus item saat di-swipe (Dismissible)
  // Dipanggil dari: views/home/favorite_list_view.dart
  // ==========================================================================
  Future<void> removeFavoriteOnSwipe(CharacterModel character) async {
    await FavoriteService.removeFavorite(character.id);
    favorites.removeWhere((c) => c.id == character.id);

    Get.closeAllSnackbars();
    Get.snackbar(
      'Favorit Dihapus',
      '${character.name} berhasil dihapus dari daftar favorit.',
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

