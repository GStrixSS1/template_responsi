// ============================================================================
// FILE: views/auth/login_view.dart
// ============================================================================
// FUNGSI FILE INI:
// Halaman antarmuka (UI) untuk form login pengguna.
//
// CARA KERJA & PENGHUBUNG ANTAR FILE:
// 1. Mengambil AuthController menggunakan GetX:
//      final AuthController _authController = Get.find<AuthController>();
// 2. Mengambil input dari TextField menggunakan TextEditingController:
//      _usernameController.text  -> Berisi teks username yang diketik
//      _passwordController.text  -> Berisi teks password yang diketik
// 3. Memanggil fungsi login saat tombol ditekan:
//      _authController.login(user, pass);
// 4. Memantau status loading:
//      Obx(() => _authController.isLoading.value ? Loading() : TombolMasuk())
// 5. Pindah ke halaman pendaftaran (Register):
//      Get.to(() => const RegisterView());
// ============================================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/app_theme.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Controller untuk membaca teks dari input field
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Menghubungkan ke AuthController yang sudah didaftarkan di main.dart
  final AuthController _authController = Get.find<AuthController>();

  // State lokal untuk sembunyikan / tampilkan password
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Wajib dispose controller saat halaman ditutup agar memori HP hemat
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Method bantuan saat tombol Masuk ditekan
  void _handleLogin() {
    _authController.login(
      _usernameController.text,
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO APLIKASI
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        AppTheme.primary,
                        AppTheme.secondary,
                        AppTheme.background,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withAlpha(100),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.travel_explore,
                    size: 48,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Rick & Morty',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Character Explorer • Masuk ke Akun Anda',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                  ),
                ),
                const SizedBox(height: 36),

                // KARTU FORM LOGIN
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textLight,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // INPUT USERNAME
                        TextField(
                          controller: _usernameController,
                          style: const TextStyle(color: AppTheme.textLight),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // INPUT PASSWORD
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: AppTheme.textLight),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppTheme.textMuted,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // TOMBOL MASUK (DIBUNGKUS OBX AGAR RESPONSIF TERHADAP LOADING)
                        Obx(
                          () => ElevatedButton(
                            onPressed: _authController.isLoading.value
                                ? null
                                : _handleLogin,
                            child: _authController.isLoading.value
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.black,
                                    ),
                                  )
                                : const Text(
                                    'Masuk Sekarang',
                                    style: TextStyle(fontSize: 16),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // PETUNJUK AKUN BAWAAN (DEMO RESPONSI)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.surfaceLight),
                  ),
                  child: const Text(
                    'Akun Bawaan: admin / admin123',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // LINK PINDAH KE REGISTER VIEW
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(color: AppTheme.textMuted),
                    ),
                    GestureDetector(
                      onTap: () => Get.to(() => const RegisterView()),
                      child: const Text(
                        'Daftar di sini',
                        style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

