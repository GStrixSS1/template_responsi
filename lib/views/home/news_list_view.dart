import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/favorite_controller.dart';
import '../../controllers/news_controller.dart';
import '../../models/news_model.dart';
import '../../utils/app_theme.dart';
import '../detail/news_detail_view.dart';

class NewsListView extends StatefulWidget {
  const NewsListView({super.key});

  @override
  State<NewsListView> createState() => _NewsListViewState();
}

class _NewsListViewState extends State<NewsListView> {
  final NewsController _newsController = Get.find<NewsController>();
  final FavoriteController _favoriteController = Get.find<FavoriteController>();
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _categories = const [
    {'id': 'terbaru', 'name': 'Terbaru'},
    {'id': 'politik', 'name': 'Politik'},
    {'id': 'hukum', 'name': 'Hukum'},
    {'id': 'ekonomi', 'name': 'Ekonomi'},
    {'id': 'olahraga', 'name': 'Olahraga'},
    {'id': 'otomotif', 'name': 'Otomotif'},
    {'id': 'hiburan', 'name': 'Hiburan'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          color: Colors.white,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Cari berita terkini...',
              prefixIcon: const Icon(Icons.search, color: AppTheme.primaryRed),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _newsController.clearSearch();
                        setState(() {});
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryRed, width: 1.5),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            onChanged: (val) {
              setState(() {});
              _newsController.searchByKeyword(val);
            },
          ),
        ),
        Container(
          height: 48,
          color: Colors.white,
          child: Obx(() {
            final activeCategory = _newsController.selectedCategory.value;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final item = _categories[index];
                final isSelected = activeCategory == item['id'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: ChoiceChip(
                    label: Text(item['name']!),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryRed,
                    backgroundColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    showCheckmark: false,
                    onSelected: (selected) {
                      if (selected) {
                        _newsController.changeCategoryFilter(item['id']!);
                      }
                    },
                  ),
                );
              },
            );
          }),
        ),
        const Divider(height: 1),
        Expanded(
          child: Obx(() {
            if (_newsController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryRed),
              );
            }

            if (_newsController.errorMessage.value.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _newsController.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _newsController.fetchNews(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Coba Lagi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryRed,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (_newsController.newsList.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tidak ada berita ditemukan.',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              color: AppTheme.primaryRed,
              onRefresh: () => _newsController.fetchNews(),
              child: ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _newsController.newsList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final news = _newsController.newsList[index];
                  return _buildNewsCard(context, news);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildNewsCard(BuildContext context, NewsModel news) {
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
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 90,
                            height: 90,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 90,
                        height: 90,
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
              Obx(() {
                final isFav = _favoriteController.isFavorite(news.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.bookmark : Icons.bookmark_border,
                    color: isFav ? AppTheme.primaryRed : Colors.grey,
                    size: 20,
                  ),
                  onPressed: () {
                    _favoriteController.toggleFavorite(news);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
