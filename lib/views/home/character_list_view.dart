// ============================================================================
// FILE: views/home/character_list_view.dart
// ============================================================================
// FUNGSI FILE INI:
// Halaman utama (List View) yang menampilkan daftar data dari API.
// Memiliki fitur Search Bar, Filter Chip, Pull-to-Refresh, Card Item, dan Tombol Favorit.
//
// CARA MANGGIL CONTROLLER DI FILE INI:
// 1. Ambil controller:
//      final characterController = Get.find<CharacterController>();
//      final favoriteController = Get.find<FavoriteController>();
// 2. Tampilkan daftar item:
//      characterController.characters[index]
// 3. Panggil properti item untuk ditampilkan di kartu:
//      character.name, character.image, character.status, character.species
// 4. Pindah ke Halaman Detail (kirim objek item yang diklik):
//      onTap: () => Get.to(() => CharacterDetailView(character: character))
// 5. Tombol Favorit di dalam Card:
//      favoriteController.toggleFavorite(character)
//
// PANDUAN RESPONSI - BAGAIMANA JIKA ASLAB GANTI TEMA? (Misal: Toko Online / E-Commerce):
// 1. Di card: ganti character.name -> item.title
// 2. Ganti character.image -> item.thumbnail
// 3. Ganti character.status -> item.category
// 4. Ganti filter chip di atas sesuai kategori API baru.
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/character_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/character_model.dart';
import '../../utils/app_theme.dart';
import '../detail/character_detail_view.dart';

class CharacterListView extends StatelessWidget {
  const CharacterListView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Mengambil Controller GetX yang aktif
    final characterController = Get.find<CharacterController>();
    final favoriteController = Get.find<FavoriteController>();

    // Controller untuk TextField pencarian
    final searchController = TextEditingController(text: characterController.searchKeyword.value);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ================================================================
            // BAGIAN SEARCH BAR & FILTER CHIPS
            // ================================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  // TEXTFIELD PENCARIAN
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: AppTheme.textLight),
                    textInputAction: TextInputAction.search,
                    // Saat tombol Enter di keyboard ditekan -> Jalankan search
                    onSubmitted: (val) => characterController.searchByName(val),
                    decoration: InputDecoration(
                      hintText: 'Cari nama karakter (mis: Rick, Morty)...',
                      prefixIcon: const Icon(Icons.search),
                      // Suffix icon: tombol silang (clear) jika sedang mencari
                      suffixIcon: Obx(() {
                        if (characterController.searchKeyword.value.isNotEmpty) {
                          return IconButton(
                            icon: const Icon(Icons.close, color: AppTheme.textMuted),
                            onPressed: () {
                              searchController.clear();
                              characterController.clearSearch();
                            },
                          );
                        }
                        return IconButton(
                          icon: const Icon(Icons.arrow_forward, color: AppTheme.primary),
                          onPressed: () => characterController.searchByName(searchController.text),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // FILTER KATEGORI / STATUS (HORIZONTAL SCROLL)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(
                      () => Row(
                        children: [
                          _buildFilterChip('All', characterController),
                          const SizedBox(width: 8),
                          _buildFilterChip('Alive', characterController),
                          const SizedBox(width: 8),
                          _buildFilterChip('Dead', characterController),
                          const SizedBox(width: 8),
                          _buildFilterChip('unknown', characterController, label: 'Unknown'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================================================================
            // BAGIAN DAFTAR DATA (DIBUNGKUS OBX AGAR REAKTIF)
            // ================================================================
            Expanded(
              child: Obx(() {
                // KONDISI 1: Sedang memuat data dari internet -> Tampilkan Loading Spinner
                if (characterController.isLoading.value) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppTheme.primary),
                        SizedBox(height: 16),
                        Text(
                          'Membuka portal dimensi...',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  );
                }

                // KONDISI 2: Terjadi error saat request HTTP -> Tampilkan Error & Tombol Refresh
                if (characterController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 56, color: AppTheme.error),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal Memuat Karakter',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            characterController.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => characterController.fetchCharacters(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // KONDISI 3: Data kosong (pencarian tidak ditemukan)
                if (characterController.characters.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off, size: 64, color: AppTheme.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'Tidak Ada Karakter Ditemukan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Coba ubah kata kunci pencarian atau ganti filter status.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              searchController.clear();
                              characterController.clearSearch();
                              characterController.changeStatusFilter('All');
                            },
                            child: const Text('Reset Filter & Pencarian'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // KONDISI 4: Data berhasil didapat -> Tampilkan ListView dengan Pull-to-Refresh
                return RefreshIndicator(
                  color: AppTheme.primary,
                  backgroundColor: AppTheme.surface,
                  onRefresh: () => characterController.fetchCharacters(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: characterController.characters.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      // Ambil objek 1 karakter berdasarkan index baris
                      final character = characterController.characters[index];
                      return _buildCharacterCard(context, character, favoriteController);
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // WIDGET HELPER: ChoiceChip Filter
  // ==========================================================================
  Widget _buildFilterChip(String value, CharacterController controller, {String? label}) {
    final isSelected = controller.selectedStatus.value.toLowerCase() == value.toLowerCase();
    final displayLabel = label ?? value;

    return ChoiceChip(
      label: Text(displayLabel),
      selected: isSelected,
      selectedColor: AppTheme.primary,
      backgroundColor: AppTheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.black : AppTheme.textLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
      ),
      onSelected: (_) => controller.changeStatusFilter(value),
    );
  }

  // ==========================================================================
  // WIDGET HELPER: Kartu Item Karakter
  // ==========================================================================
  Widget _buildCharacterCard(
    BuildContext context,
    CharacterModel character,
    FavoriteController favoriteController,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        // [PENTING]: CARA PINDAH KE DETAIL DENGAN MENGIRIM OBJEK DATA
        onTap: () => Get.to(() => CharacterDetailView(character: character)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // FOTO / GAMBAR THUMBNAIL
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  character.image,
                  width: 68,
                  height: 68,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 68,
                    height: 68,
                    color: AppTheme.surfaceLight,
                    child: const Icon(Icons.person, color: AppTheme.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // INFORMASI TEKS KARAKTER
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAMA
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
                    const SizedBox(height: 6),

                    // STATUS & SPESIES
                    Row(
                      children: [
                        // Titik indikator warna (Hijau = Alive, Merah = Dead)
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // TOMBOL FAVORIT CEPAT DI DALAM KARTU
              Obx(() {
                final isFav = favoriteController.isFavorite(character.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : AppTheme.textMuted,
                    size: 24,
                  ),
                  onPressed: () => favoriteController.toggleFavorite(character),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
