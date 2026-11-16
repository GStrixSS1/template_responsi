import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorite_controller.dart';
import '../../models/news_model.dart';
import '../../utils/app_theme.dart';

class NewsDetailView extends StatelessWidget {
  final NewsModel news;

  const NewsDetailView({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final FavoriteController favoriteController = Get.find<FavoriteController>();

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        title: const Text('Detail Berita'),
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        actions: [
          Obx(() {
            final isFav = favoriteController.isFavorite(news.id);
            return IconButton(
              icon: Icon(
                isFav ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
              ),
              onPressed: () {
                favoriteController.toggleFavorite(news);
              },
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (news.thumbnail.isNotEmpty)
              Image.network(
                news.thumbnail,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 220,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        size: 54,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              )
            else
              Container(
                height: 200,
                color: AppTheme.primaryRed.withAlpha(20),
                child: const Center(
                  child: Icon(
                    Icons.newspaper,
                    size: 64,
                    color: AppTheme.primaryRed,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withAlpha(25),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          news.category.toUpperCase(),
                          style: const TextStyle(
                            color: AppTheme.primaryRed,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            news.pubDate,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  const Text(
                    'Ringkasan Berita',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.description,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey[850],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.link,
                                size: 18,
                                color: AppTheme.primaryRed,
                              ),
                              SizedBox(width: 6),
                              Text(
                                'Tautan Sumber Asli',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          SelectableText(
                            news.link.isNotEmpty ? news.link : 'https://antaranews.com',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        final isFav = favoriteController.isFavorite(news.id);
        return FloatingActionButton.extended(
          onPressed: () {
            favoriteController.toggleFavorite(news);
          },
          backgroundColor: isFav ? Colors.red[700] : AppTheme.primaryRed,
          icon: Icon(
            isFav ? Icons.bookmark : Icons.bookmark_border,
            color: Colors.white,
          ),
          label: Text(
            isFav ? 'Tersimpan' : 'Simpan Berita',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}
