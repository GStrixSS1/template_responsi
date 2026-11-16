import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/movie_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/movie_model.dart';
import '../../utils/app_theme.dart';
import '../detail/movie_detail_view.dart';

class MovieListView extends StatelessWidget {
  const MovieListView({super.key});

  @override
  Widget build(BuildContext context) {
    final movieController = Get.find<MovieController>();
    final favoriteController = Get.find<FavoriteController>();
    final searchController = TextEditingController(text: movieController.searchKeyword.value);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    style: const TextStyle(color: AppTheme.textLight),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (val) => movieController.searchByName(val),
                    decoration: InputDecoration(
                      hintText: 'Cari judul film (misal: Batman, Avatar)...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: Obx(() {
                        if (movieController.searchKeyword.value.isNotEmpty) {
                          return IconButton(
                            icon: const Icon(Icons.close, color: AppTheme.textMuted),
                            onPressed: () {
                              searchController.clear();
                              movieController.clearSearch();
                            },
                          );
                        }
                        return IconButton(
                          icon: const Icon(Icons.arrow_forward, color: AppTheme.primary),
                          onPressed: () => movieController.searchByName(searchController.text),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(
                      () => Row(
                        children: [
                          _buildFilterChip('All', movieController),
                          const SizedBox(width: 8),
                          _buildFilterChip('Running', movieController, label: 'Tayang'),
                          const SizedBox(width: 8),
                          _buildFilterChip('Ended', movieController, label: 'Selesai'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (movieController.isLoading.value) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppTheme.primary),
                        SizedBox(height: 16),
                        Text(
                          'Memuat film bioskop...',
                          style: TextStyle(color: AppTheme.textMuted),
                        ),
                      ],
                    ),
                  );
                }

                if (movieController.errorMessage.value.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 56, color: AppTheme.error),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal Memuat Film',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movieController.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => movieController.fetchMovies(),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (movieController.movies.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.movie_filter_outlined, size: 64, color: AppTheme.textMuted),
                          const SizedBox(height: 12),
                          const Text(
                            'Tidak Ada Film Ditemukan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textLight,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Coba kata kunci pencarian lain atau pilih filter All.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.textMuted),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              searchController.clear();
                              movieController.clearSearch();
                              movieController.changeStatusFilter('All');
                            },
                            child: const Text('Reset Filter & Pencarian'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppTheme.primary,
                  backgroundColor: AppTheme.surface,
                  onRefresh: () => movieController.fetchMovies(),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: movieController.movies.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final movie = movieController.movies[index];
                      return _buildMovieCard(context, movie, favoriteController);
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

  Widget _buildFilterChip(String value, MovieController controller, {String? label}) {
    final isSelected = controller.selectedStatus.value.toLowerCase() == value.toLowerCase();
    final displayLabel = label ?? value;

    return ChoiceChip(
      label: Text(displayLabel),
      selected: isSelected,
      selectedColor: AppTheme.primary,
      backgroundColor: AppTheme.surface,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppTheme.textLight,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppTheme.primary : AppTheme.surfaceLight,
      ),
      onSelected: (_) => controller.changeStatusFilter(value),
    );
  }

  Widget _buildMovieCard(
    BuildContext context,
    MovieModel movie,
    FavoriteController favoriteController,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.to(() => MovieDetailView(movie: movie)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.image,
                  width: 70,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 90,
                    color: AppTheme.surfaceLight,
                    child: const Icon(Icons.movie, color: AppTheme.textMuted),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      movie.genre,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppTheme.secondary, size: 15),
                        const SizedBox(width: 4),
                        Text(
                          movie.rating,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.secondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            movie.status,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.textLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Obx(() {
                final isFav = favoriteController.isFavorite(movie.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : AppTheme.textMuted,
                    size: 24,
                  ),
                  onPressed: () => favoriteController.toggleFavorite(movie),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

