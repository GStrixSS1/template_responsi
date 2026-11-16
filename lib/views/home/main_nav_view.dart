// ============================================================================
// FILE: views/home/main_nav_view.dart
// ============================================================================
// FUNGSI FILE INI:
// Halaman pembungkus utama setelah login yang mengelola navigasi bawah (BottomNavigationBar).
// Menyatukan 3 halaman:
// 1. Tab 0: CharacterListView (Daftar Karakter dari API)
// 2. Tab 1: FavoriteListView (Daftar Karakter Favorit dari SharedPreferences)
// 3. Tab 2: EpisodeListView (Daftar Episode dari API)
//
// FITUR PENTING:
// - IndexedStack: Menyimpan status scroll halaman saat pindah-pindah tab (tidak reload ulang)
// - Tombol Logout di AppBar dengan Dialog Konfirmasi GetX (Get.dialog)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_theme.dart';
import 'character_list_view.dart';
import 'favorite_list_view.dart';
import 'episode_list_view.dart';

class MainNavView extends StatefulWidget {
  const MainNavView({super.key});

  @override
  State<MainNavView> createState() => _MainNavViewState();
}

class _MainNavViewState extends State<MainNavView> {
  // Index tab aktif (0 = Characters, 1 = Favorites, 2 = Episodes)
  int _currentIndex = 0;

  // Menghubungkan ke AuthController untuk tombol Logout & greeting nama
  final AuthController authController = Get.find<AuthController>();

  // Daftar halaman yang sesuai dengan tab bawah
  final List<Widget> _pages = const [
    CharacterListView(),
    FavoriteListView(),
    EpisodeListView(),
  ];

  // Daftar judul AppBar yang berubah dinamis sesuai tab aktif
  final List<String> _titles = const [
    'Rick & Morty',
    'Favorites',
    'Episodes View',
  ];

  // ==========================================================================
  // METHOD: Menampilkan Popup Konfirmasi Logout (Get.dialog)
  // ==========================================================================
  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 10),
            Text('Konfirmasi Logout', style: TextStyle(color: AppTheme.textLight)),
          ],
        ),
        content: Text(
          'Halo ${authController.currentFullName.value.isNotEmpty ? authController.currentFullName.value : authController.currentUsername.value}, apakah Anda yakin ingin keluar dari aplikasi?',
          style: const TextStyle(color: AppTheme.textMuted),
        ),
        actions: [
          // Tombol Batal
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textMuted)),
          ),
          // Tombol Keluar -> Panggil authController.logout()
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Get.back(); // Tutup dialog
              authController.logout(); // Hapus session & kembali ke LoginView
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        actions: [
          // Tombol Logout di pojok kanan atas
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      // IndexedStack: Menjaga state scroll setiap halaman agar tidak direset saat ganti tab
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(80),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Characters',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              activeIcon: Icon(Icons.play_circle),
              label: 'Episodes',
            ),
          ],
        ),
      ),
    );
  }
}
