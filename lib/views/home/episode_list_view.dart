// ============================================================================
// FILE: views/home/episode_list_view.dart
// ============================================================================
// FUNGSI FILE INI:
// Halaman untuk menampilkan data sekunder (Episode / Kategori / Jadwal).
//
// CARA KERJA & PENGHUBUNG ANTAR FILE:
// 1. Mengambil EpisodeController yang sudah di-inject di main.dart:
//      final episodeController = Get.find<EpisodeController>();
// 2. Membungkus UI dengan Obx agar otomatis update saat API selesai download data:
//      Obx(() => ListView.builder(... episodeController.episodes[index]))
// 3. Menampilkan properti: episode.name, episode.airDate, episode.episode
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/episode_controller.dart';
import '../../models/episode_model.dart';
import '../../utils/app_theme.dart';

class EpisodeListView extends StatelessWidget {
  const EpisodeListView({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Menghubungkan ke EpisodeController
    final episodeController = Get.find<EpisodeController>();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          // KONDISI 1: Loading
          if (episodeController.isLoading.value) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppTheme.primary),
                  SizedBox(height: 16),
                  Text(
                    'Memuat daftar episode...',
                    style: TextStyle(color: AppTheme.textMuted),
                  ),
                ],
              ),
            );
          }

          // KONDISI 2: Error
          if (episodeController.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 56, color: AppTheme.error),
                    const SizedBox(height: 12),
                    const Text(
                      'Gagal Memuat Episode',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      episodeController.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppTheme.textMuted),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => episodeController.fetchEpisodes(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          // KONDISI 3: Kosong
          if (episodeController.episodes.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada episode tersedia.',
                style: TextStyle(color: AppTheme.textMuted),
              ),
            );
          }

          // KONDISI 4: Berhasil memuat daftar episode
          return RefreshIndicator(
            color: AppTheme.primary,
            backgroundColor: AppTheme.surface,
            onRefresh: () => episodeController.fetchEpisodes(),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: episodeController.episodes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final episode = episodeController.episodes[index];
                return _buildEpisodeCard(episode);
              },
            ),
          );
        }),
      ),
    );
  }

  // WIDGET HELPER: Kartu Episode
  Widget _buildEpisodeCard(EpisodeModel episode) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.movie_outlined,
                color: AppTheme.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    episode.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textLight,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: AppTheme.secondary),
                      const SizedBox(width: 6),
                      Text(
                        episode.airDate,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.primary.withAlpha(80)),
              ),
              child: Text(
                episode.episode,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

