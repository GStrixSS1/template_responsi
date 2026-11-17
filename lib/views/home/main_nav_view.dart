import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/favorite_controller.dart';
import '../../utils/app_theme.dart';
import 'product_list_view.dart';
import 'wishlist_view.dart';

class MainNavView extends StatefulWidget {
  const MainNavView({super.key});

  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  int _currentIndex = 0;
  final AuthController _authController = Get.find<AuthController>();
  final FavoriteController _favoriteController = Get.find<FavoriteController>();

  final List<String> _titles = const [
    'ShoppingHub',
    'Daftar Wishlist',
  ];

  void _confirmLogout() {
    Get.defaultDialog(
      title: 'Konfirmasi Keluar',
      middleText: 'Apakah Anda yakin ingin keluar dari ShoppingHub?',
      textConfirm: 'Keluar',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: AppTheme.primary,
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
        backgroundColor: AppTheme.primary,
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
              final fullName = _authController.currentFullName.value;
              final username = _authController.currentUsername.value;
              final displayName = fullName.isNotEmpty ? fullName : (username.isNotEmpty ? username : 'User');
              return Text(
                'Halo, $displayName',
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
            icon: const Icon(Icons.favorite),
            tooltip: 'Wishlist',
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
              _favoriteController.loadWishlist();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Keluar',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ProductListView(),
          WishlistView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            _favoriteController.loadWishlist();
          }
        },
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey[500],
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
        ],
      ),
    );
  }
}

