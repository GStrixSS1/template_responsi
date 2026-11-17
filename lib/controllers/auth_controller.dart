import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../views/auth/login_view.dart';
import '../views/home/main_nav_view.dart';

class AuthController extends GetxController {
  final RxBool isLoggedIn = false.obs;
  final RxString currentUsername = ''.obs;
  final RxString currentFullName = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final loggedIn = await AuthService.isUserLoggedIn();
    isLoggedIn.value = loggedIn;
    if (loggedIn) {
      final info = await AuthService.getCurrentUserInfo();
      currentUsername.value = info['username'] ?? '';
      currentFullName.value = info['fullName'] ?? '';
    }
  }

  Future<void> login(String username, String password) async {
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
      final success = await AuthService.login(
        username: username,
        password: password,
      );

      if (success) {
        final info = await AuthService.getCurrentUserInfo();
        currentUsername.value = info['username'] ?? '';
        currentFullName.value = info['fullName'] ?? '';
        isLoggedIn.value = true;

        Get.snackbar(
          'Selamat Datang!',
          'Login berhasil. Selamat berbelanja di ShoppingHub!',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );

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

  Future<bool> register({
    required String fullName,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
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
          'Akun berhasil dibuat! Silakan masuk.',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
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

  Future<void> logout() async {
    await AuthService.logout();
    isLoggedIn.value = false;
    currentUsername.value = '';
    currentFullName.value = '';

    Get.snackbar(
      'Logout Berhasil',
      'Anda telah keluar dari aplikasi ShoppingHub.',
      backgroundColor: const Color(0xFF3B82F6),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );

    Get.offAll(() => const LoginView());
  }
}

