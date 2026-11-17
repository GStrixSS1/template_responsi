// ============================================================================
// FILE: views/home/favorite_list_view.dart
// ============================================================================
// FUNGSI FILE INI:
// Halaman untuk menampilkan daftar karakter favorit yang disimpan di SharedPreferences.
// Dilengkapi fitur Dismissible (Swipe to Delete / Geser kartu ke kiri untuk menghapus).
//
// CARA KERJA & PENGHUBUNG ANTAR FILE:
// 1. Mengambil controller:
//      final favoriteController = Get.find<FavoriteController>();
// 2. Mengecek apakah daftar favorit kosong:
//      if (favoriteController.favorites.isEmpty) -> Tampilkan pesan 'Daftar favorite masih kosong'
// 3. Menggunakan Dismissible untuk menghapus item dengan animasi geser:
//      Dismissible(
//        key: Key('fav_${character.id}'),
//        direction: DismissDirection.endToStart, // Geser dari kanan ke kiri
//        onDismissed: (_) => favoriteController.removeFavoriteOnSwipe(character),
//        child: Card(...),
//      )
// 4. Klik kartu untuk melihat detail:
//      onTap: () => Get.to(() => CharacterDetailView(character: character));
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/character_model.dart';
import '../../utils/app_theme.dart';
import '../detail/character_detail_view.dart';

class FavoriteListView extends StatelessWidget {
  const FavoriteListView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Mengambil FavoriteController
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // KONDISI 1: Loading membaca SharedPreferences
          if (favoriteController.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primary),
            );
          }

          // KONDISI 2: Daftar favorit masih kosong
          if (favoriteController.favorites.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.redAccent.withAlpha(40),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 64,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Teks wajib sesuai panduan ujian
                    const Text(
                      'Daftar favorite masih kosong',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jelajahi karakter di tab Characters dan ketuk ikon hati untuk menambahkannya ke daftar favorit Anda.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textMuted,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // KONDISI 3: Ada data favorit -> Tampilkan ListView dengan info total
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Favorit: ${favoriteController.favorites.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      'Geser kartu untuk menghapus',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: favoriteController.favorites.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final character = favoriteController.favorites[index];
                    return _buildDismissibleCard(context, character, favoriteController);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ==========================================================================
  // WIDGET HELPER: Kartu Favorit dengan Fitur Swipe-to-Delete (Dismissible)
  // ==========================================================================
  Widget _buildDismissibleCard(
    BuildContext context,
    CharacterModel character,
    FavoriteController favoriteController,
  ) {
    return Dismissible(
      // Key unik WAJIB ada di Dismissible agar Flutter tahu kartu mana yang digeser
      key: Key('fav_${character.id}'),
      // Arah geser: hanya dari kanan ke kiri
      direction: DismissDirection.endToStart,
      // Tampilan latar belakang merah saat kartu digeser ke kiri
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Hapus',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.delete_outline, color: Colors.white, size: 28),
          ],
        ),
      ),
      // Method yang dijalankan ketika kartu selesai digeser sampai hilang
      onDismissed: (direction) {
        favoriteController.removeFavoriteOnSwipe(character);
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // Klik kartu untuk membuka halaman detail
          onTap: () => Get.to(() => CharacterDetailView(character: character)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    character.image,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 64,
                      height: 64,
                      color: AppTheme.surfaceLight,
                      child: const Icon(Icons.person, color: AppTheme.textMuted),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.getStatusColor(character.status),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${character.status} - ${character.species}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Asal: ${character.origin}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Icon Hati Merah solid menandakan status favorit
                const Icon(
                  Icons.favorite,
                  color: Colors.redAccent,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

