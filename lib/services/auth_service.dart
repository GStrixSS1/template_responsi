// ============================================================================
// FILE: services/auth_service.dart
// ============================================================================
// FUNGSI FILE INI:
// Mengelola autentikasi (Register, Login, Logout, dan Session Login).
// Menggabungkan 2 teknologi penyimpanan lokal:
// 1. Hive: Database lokal untuk menyimpan tabel banyak user terdaftar
// 2. SharedPreferences: Key-Value cepat untuk menyimpan session (apakah user sedang login)
//
// HUBUNGAN DENGAN FILE LAIN:
// 1. main.dart            -> Memanggil: AuthService.seedDefaultUserIfEmpty() dan AuthService.isUserLoggedIn()
// 2. auth_controller.dart -> Memanggil: AuthService.login(), register(), logout()
// 3. main_nav_view.dart   -> Memanggil: AuthService.getCurrentUserInfo() untuk menampilkan nama di header
//
// PANDUAN RESPONSI:
// - Default user: username 'admin', password 'admin123' (atau 'password123')
// - Jika ingin menambah field akun (misal email), tambahkan di parameter register()
//   dan simpan ke UserModel.
// ============================================================================

import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  // Nama box penyimpanan di Hive
  static const String userBoxName = 'rick_morty_users_box';

  // Kunci-kunci penyimpanan session di SharedPreferences
  static const String prefIsLoggedIn = 'is_logged_in';
  static const String prefUsername = 'logged_in_username';
  static const String prefFullName = 'logged_in_fullname';

  // Getter pembantu untuk mengakses box Hive
  static Box<UserModel> get _userBox => Hive.box<UserModel>(userBoxName);

  // ==========================================================================
  // METHOD REGISTER: Mendaftarkan akun baru ke dalam Hive Box
  // Return true jika sukses, return false jika username sudah dipakai orang lain
  // ==========================================================================
  static Future<bool> register({
    required String username,
    required String password,
    required String fullName,
  }) async {
    final cleanUsername = username.trim();

    // Cek apakah username sudah ada di database Hive
    if (_userBox.containsKey(cleanUsername)) {
      return false; // Username sudah terdaftar
    }

    // Buat objek UserModel baru
    final newUser = UserModel(
      username: cleanUsername,
      password: password,
      fullName: fullName.trim(),
    );

    // Simpan ke Hive dengan key = cleanUsername
    await _userBox.put(cleanUsername, newUser);
    return true;
  }

  // ==========================================================================
  // METHOD SEED DEFAULT USER:
  // Membuat akun bawaan jika database Hive masih kosong saat aplikasi pertama kali dibuka.
  // Sangat berguna saat demo ke Aslab agar tidak perlu registrasi manual tiap kali install ulang.
  // ==========================================================================
  static Future<void> seedDefaultUserIfEmpty() async {
    if (_userBox.isEmpty) {
      await register(
        username: 'admin',
        password: 'admin123',
        fullName: 'Admin Rick',
      );
    }
  }

  // ==========================================================================
  // METHOD LOGIN: Memvalidasi username & password di Hive.
  // Jika cocok, simpan status login ke SharedPreferences.
  // ==========================================================================
  static Future<bool> login({
    required String username,
    required String password,
  }) async {
    final cleanUsername = username.trim();

    // Ambil data user dari Hive berdasarkan key username
    final user = _userBox.get(cleanUsername);

    // Cek apakah user ada dan password cocok
    if (user != null && (user.password == password || (user.username == 'admin' && password == 'password123'))) {
      // Simpan session login ke SharedPreferences agar tidak logout saat aplikasi ditutup
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(prefIsLoggedIn, true);
      await prefs.setString(prefUsername, user.username);
      await prefs.setString(prefFullName, user.fullName);
      return true;
    }
    return false; // Login gagal
  }

  // ==========================================================================
  // METHOD LOGOUT: Menghapus data session dari SharedPreferences
  // ==========================================================================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(prefIsLoggedIn);
    await prefs.remove(prefUsername);
    await prefs.remove(prefFullName);
  }

  // ==========================================================================
  // METHOD CEK LOGIN: Mengecek apakah user saat ini sedang dalam keadaan login
  // Digunakan oleh main.dart untuk menentukan halaman awal (LoginView atau MainNavView)
  // ==========================================================================
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(prefIsLoggedIn) ?? false;
  }

  // ==========================================================================
  // METHOD INFO USER: Mengambil data user yang sedang login untuk ditampilkan di AppBar
  // ==========================================================================
  static Future<Map<String, String>> getCurrentUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'username': prefs.getString(prefUsername) ?? '',
      'fullName': prefs.getString(prefFullName) ?? 'Traveler',
    };
  }
}

