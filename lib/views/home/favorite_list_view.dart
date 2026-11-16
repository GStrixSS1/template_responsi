import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/news_model.dart';
import '../../utils/app_theme.dart';
import '../detail/news_detail_view.dart';

class FavoriteListView extends StatelessWidget {
  const FavoriteListView({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.find<FavoriteController>();

    return Obx(() {
      if (favoriteController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryRed),
        );
      }

      if (favoriteController.favorites.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bookmark_border_rounded,
                  size: 72,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Daftar favorite masih kosong',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Simpan artikel berita menarik dengan menekan ikon bookmark.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return RefreshIndicator(
        color: AppTheme.primaryRed,
        onRefresh: () => favoriteController.loadFavorites(),
        child: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: favoriteController.favorites.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final news = favoriteController.favorites[index];
            return Dismissible(
              key: Key('fav_${news.id}'),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: Colors.red[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.delete, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Hapus',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              onDismissed: (direction) {
                favoriteController.removeFavoriteOnSwipe(news);
              },
              child: _buildFavoriteCard(context, news, favoriteController),
            );
          },
        ),
      );
    });
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    NewsModel news,
    FavoriteController favoriteController,
  ) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Get.to(() => NewsDetailView(news: news));
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: news.thumbnail.isNotEmpty
                    ? Image.network(
                        news.thumbnail,
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 85,
                            height: 85,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 85,
                        height: 85,
                        color: AppTheme.primaryRed.withAlpha(20),
                        child: const Icon(
                          Icons.newspaper,
                          color: AppTheme.primaryRed,
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryRed.withAlpha(20),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            news.category.toUpperCase(),
                            style: const TextStyle(
                              color: AppTheme.primaryRed,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          news.pubDate,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      news.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      news.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 22,
                ),
                onPressed: () {
                  favoriteController.toggleFavorite(news);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
