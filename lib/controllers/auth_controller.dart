// ============================================================================
// FILE: controllers/auth_controller.dart
// ============================================================================
// FUNGSI FILE INI:
// State Management (GetX) untuk Autentikasi Pengguna.
// Mengatur status loading, validasi form login & register, serta perpindahan halaman.
//
// CARA MANGGIL CONTROLLER INI DARI FILE LAIN (VIEW):
// 1. Inisialisasi di main.dart:
//      Get.put(AuthController());
// 2. Cara ambil / panggil di halaman LoginView / RegisterView:
//      final AuthController authController = Get.find<AuthController>();
// 3. Cara jalankan method login saat tombol ditekan:
//      authController.login(userController.text, passController.text);
// 4. Cara pantau variabel reaktif di UI (agar otomatis berubah tanpa setState):
//      Obx(() => authController.isLoading.value ? CircularProgressIndicator() : Text('Masuk'))
//
// FITUR GETX YANG DIGUNAKAN:
// - .obs               -> Membuat variabel menjadi Reactive (otomatis update UI saat nilai berubah)
// - Get.snackbar(...)  -> Menampilkan pesan popup notifikasi modern di atas/bawah layar
// - Get.offAll(...)    -> Pindah ke halaman baru & MENGHAPUS riwayat back button
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../views/auth/login_view.dart';
import '../views/home/main_nav_view.dart';

class AuthController extends GetxController {
  // Variabel-variabel reaktif (.obs)
  final RxBool isLoggedIn = false.obs;
  final RxString currentUsername = ''.obs;
  final RxString currentFullName = ''.obs;
  final RxBool isLoading = false.obs;

  // onInit: Dijalankan otomatis pertama kali saat Controller ini dibuat oleh GetX
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  // ==========================================================================
  // METHOD: Cek Session Login
  // ==========================================================================
  Future<void> checkLoginStatus() async {
    final loggedIn = await AuthService.isUserLoggedIn();
    isLoggedIn.value = loggedIn;
    if (loggedIn) {
      final info = await AuthService.getCurrentUserInfo();
      currentUsername.value = info['username'] ?? '';
      currentFullName.value = info['fullName'] ?? '';
    }
  }

  // ==========================================================================
  // METHOD: Login
  // Dipanggil dari: views/auth/login_view.dart
  // ==========================================================================
  Future<void> login(String username, String password) async {
    // 1. Validasi input form kosong
    if (username.trim().isEmpty || password.trim().isEmpty) {
      Get.snackbar(
        'Gagal Login',
        'Username dan password wajib diisi!',
        backgroundColor: Colors.redAccent.withAlpha(230),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isLoading.value = true;
    try {
      // 2. Panggil AuthService untuk cek database lokal Hive
      final success = await AuthService.login(
        username: username,
        password: password,
      );

      if (success) {
        // Ambil info nama user untuk ditampilkan di AppBar
        final info = await AuthService.getCurrentUserInfo();
        currentUsername.value = info['username'] ?? '';
        currentFullName.value = info['fullName'] ?? '';
        isLoggedIn.value = true;

        Get.snackbar(
          'Selamat Datang!',
          'Login berhasil. Selamat menjelajah multiverse!',
          backgroundColor: const Color(0xFF00E599),
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

        // Get.offAll: Pindah ke Home dan hapus halaman Login dari stack navigasi
        Get.offAll(() => const MainNavView());
      } else {
        Get.snackbar(
          'Login Gagal',
          'Username atau password salah, atau belum terdaftar.',
          backgroundColor: Colors.redAccent.withAlpha(230),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================================================
  // METHOD: Register Akun Baru
  // Dipanggil dari: views/auth/register_view.dart
  // ==========================================================================
  Future<bool> register({
    required String fullName,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    // Validasi semua kolom harus terisi
    if (fullName.trim().isEmpty || username.trim().isEmpty || password.trim().isEmpty) {
      Get.snackbar(
        'Pendaftaran Gagal',
        'Semua kolom wajib diisi!',
        backgroundColor: Colors.redAccent.withAlpha(230),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }

    // Validasi konfirmasi password
    if (password != confirmPassword) {
      Get.snackbar(
        'Pendaftaran Gagal',
        'Konfirmasi password tidak cocok!',
        backgroundColor: Colors.redAccent.withAlpha(230),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    }

    isLoading.value = true;
    try {
      final success = await AuthService.register(
        username: username,
        password: password,
        fullName: fullName,
      );

      if (success) {
        Get.snackbar(
          'Registrasi Berhasil',
          'Akun berhasil dibuat! Silakan login.',
          backgroundColor: const Color(0xFF00E599),
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return true;
      } else {
        Get.snackbar(
          'Registrasi Gagal',
          'Username "$username" sudah terdaftar. Gunakan username lain.',
          backgroundColor: Colors.redAccent.withAlpha(230),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        return false;
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ==========================================================================
  // METHOD: Logout
  // Menghapus session dan mengembalikan user ke halaman LoginView
  // ==========================================================================
  Future<void> logout() async {
    await AuthService.logout();
    isLoggedIn.value = false;
    currentUsername.value = '';
    currentFullName.value = '';

    Get.snackbar(
      'Logout Berhasil',
      'Anda telah keluar dari aplikasi.',
      backgroundColor: const Color(0xFF00B4D8),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );

    Get.offAll(() => const LoginView());
  }
}

