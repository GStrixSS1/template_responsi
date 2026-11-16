import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../controllers/news_controller.dart';
import '../../utils/app_theme.dart';
import 'category_list_view.dart';
import 'favorite_list_view.dart';
import 'news_list_view.dart';

class MainNavView extends StatefulWidget {
  const MainNavView({super.key});

  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  int _currentIndex = 0;
  final AuthController _authController = Get.find<AuthController>();
  final NewsController _newsController = Get.find<NewsController>();
  final FavoriteController _favoriteController = Get.find<FavoriteController>();

  final List<String> _titles = const [
    'Kabar Nusantara',
    'Berita Tersimpan',
    'Kanal Informasi',
  ];

  void _confirmLogout() {
    Get.defaultDialog(
      title: 'Konfirmasi Keluar',
      middleText: 'Apakah Anda yakin ingin keluar dari akun ini?',
      textConfirm: 'Keluar',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: AppTheme.primaryRed,
      onConfirm: () {
        Get.back();
        _authController.logout();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryRed,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _titles[_currentIndex],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Obx(() {
              final name = _authController.currentFullName.value;
              final user = _authController.currentUsername.value;
              final displayName = name.isNotEmpty ? name : user;
              return Text(
                'Halo, ${displayName.isNotEmpty ? displayName : "Pembaca"}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              );
            }),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const NewsListView(),
          const FavoriteListView(),
          CategoryListView(
            onSelectCategory: (slug) {
              _newsController.changeCategoryFilter(slug);
              setState(() {
                _currentIndex = 0;
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            _favoriteController.loadFavorites();
          }
        },
        selectedItemColor: AppTheme.primaryRed,
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_outlined),
            activeIcon: Icon(Icons.newspaper),
            label: 'Berita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Kanal',
          ),
        ],
      ),
    );
  }
}
