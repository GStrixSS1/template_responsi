// ============================================================================
// FILE: views/detail/character_detail_view.dart
// ============================================================================
// FUNGSI FILE INI:
// Halaman detail untuk menampilkan informasi lengkap dari 1 item yang dipilih.
//
// CARA MENERIMA DATA DARI HALAMAN LIST (character_list_view.dart):
// 1. Di file pemanggil (List View):
//      Get.to(() => CharacterDetailView(character: itemDipilih));
// 2. Di file ini (Detail View):
//      final CharacterModel character;
//      const CharacterDetailView({super.key, required this.character});
// 3. Cara menampilkan propertinya ke layar:
//      character.name, character.image, character.species, character.status, dll.
//
// CARA MENGHUBUNGKAN DENGAN FAVORITE CONTROLLER:
// 1. Ambil controller: final favoriteController = Get.find<FavoriteController>();
// 2. Bungkus tombol dengan Obx agar icon hati berubah warna otomatis saat ditekan:
//      Obx(() {
//        final isFav = favoriteController.isFavorite(character.id);
//        return IconButton(
//          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
//          color: isFav ? Colors.redAccent : Colors.white,
//          onPressed: () => favoriteController.toggleFavorite(character),
//        );
//      })
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/character_model.dart';
import '../../utils/app_theme.dart';

class CharacterDetailView extends StatelessWidget {
  // Objek data yang dikirim dari halaman list
  final CharacterModel character;

  const CharacterDetailView({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    // Menghubungkan ke FavoriteController
    final favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // APPBAR DENGAN GAMBAR BESAR (PARALLAX EFFECT)
          SliverAppBar(
            expandedHeight: 340,
            pinned: true,
            backgroundColor: AppTheme.surface,
            // Tombol Kembali (Back)
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.background.withAlpha(180),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Get.back(),
            ),
            // Tombol Favorit di pojok kanan atas AppBar
            actions: [
              Obx(() {
                final isFav = favoriteController.isFavorite(character.id);
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.background.withAlpha(180),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.redAccent : Colors.white,
                      size: 26,
                    ),
                    onPressed: () => favoriteController.toggleFavorite(character),
                  ),
                );
              }),
            ],
            // Gambar Hero Karakter
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    character.image,
                    fit: BoxFit.cover,
                    // Fallback jika gambar gagal dimuat dari internet
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppTheme.surfaceLight,
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 64, color: AppTheme.textMuted),
                      ),
                    ),
                  ),
                  // Gradien hitam di bawah gambar agar teks judul terlihat jelas
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withAlpha(80),
                            Colors.transparent,
                            AppTheme.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // KONTEN INFORMASI DETAIL
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NAMA KARAKTER & BADGE STATUS
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          character.name, // <- Cara panggil nama
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textLight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Badge Status (Alive / Dead)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.getStatusColor(character.status).withAlpha(40),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.getStatusColor(character.status),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                              character.status,
                              style: TextStyle(
                                color: AppTheme.getStatusColor(character.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${character.species} • ${character.gender}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SEKSI KARTU INFORMASI LENGKAP
                  _buildSectionHeader('Informasi Karakter'),
                  const SizedBox(height: 12),

                  // [TIPS RESPONSI]: Tambah / ganti info tile di bawah sesuai field di soal ujian!
                  _buildInfoTile(
                    icon: Icons.fingerprint,
                    title: 'Spesies',
                    value: character.species,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoTile(
                    icon: Icons.transgender,
                    title: 'Gender',
                    value: character.gender,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoTile(
                    icon: Icons.public,
                    title: 'Origin (Asal)',
                    value: character.origin,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoTile(
                    icon: Icons.location_on,
                    title: 'Location (Lokasi Terakhir)',
                    value: character.location,
                  ),
                  const SizedBox(height: 28),

                  // TOMBOL BESAR TAMBAH / HAPUS FAVORIT DI BAGIAN BAWAH
                  Obx(() {
                    final isFav = favoriteController.isFavorite(character.id);
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFav ? Colors.redAccent : AppTheme.primary,
                          foregroundColor: isFav ? Colors.white : Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                        label: Text(
                          isFav ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => favoriteController.toggleFavorite(character),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pembantu untuk judul seksi
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textLight,
        letterSpacing: 0.5,
      ),
    );
  }

  // Widget pembantu untuk membuat baris kartu informasi yang rapi
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceLight.withAlpha(128)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
