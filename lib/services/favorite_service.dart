// ============================================================================
// FILE: services/favorite_service.dart
// ============================================================================
// FUNGSI FILE INI:
// Mengelola data FAVORITE / BOOKMARK / WISHLIST secara offline menggunakan SharedPreferences.
//
// KONSEP PENTING (SERING DITANYAKAN DOSEN/ASLAB):
// Bagaimana cara SharedPreferences menyimpan List Objek?
// JAWABAN:
// 1. Saat SIMPAN (Save): Objek Dart diubah jadi Map via .toJson(), lalu diubah jadi
//    teks JSON String via jsonEncode(). Disimpan sebagai List<String>.
// 2. Saat BACA (Read): Teks JSON String diuraikan jadi Map via jsonDecode(),
//    lalu diubah kembali jadi Objek Dart via .fromJson().
//
// HUBUNGAN DENGAN FILE LAIN:
// 1. character_model.dart     -> Membutuhkan toJson() dan fromJson()
// 2. favorite_controller.dart -> Memanggil FavoriteService untuk update UI secara reaktif
// 3. favorite_list_view.dart  -> Menampilkan list data yang sudah difavoritkan
// ============================================================================

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/character_model.dart';

class FavoriteService {
  // Kunci unik untuk menyimpan data favorit di SharedPreferences
  static const String prefFavoritesKey = 'rick_morty_favorite_characters';

  // ==========================================================================
  // METHOD 1: Mengambil semua data favorit dari SharedPreferences
  // ==========================================================================
  static Future<List<CharacterModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil list string mentah. Jika belum ada data, kembalikan list kosong []
    final rawList = prefs.getStringList(prefFavoritesKey) ?? [];

    // Loop setiap string JSON -> ubah jadi Map -> ubah jadi CharacterModel
    return rawList.map((item) {
      final map = jsonDecode(item) as Map<String, dynamic>;
      return CharacterModel.fromJson(map);
    }).toList();
  }

  // ==========================================================================
  // METHOD 2: Menambahkan item ke daftar favorit
  // ==========================================================================
  static Future<void> addFavorite(CharacterModel character) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();

    // Cek agar tidak ada data ganda (duplikat ID)
    if (!list.any((c) => c.id == character.id)) {
      list.add(character);

      // Konversi semua objek di list menjadi JSON String
      final rawList = list.map((c) => jsonEncode(c.toJson())).toList();

      // Simpan kembali ke SharedPreferences
      await prefs.setStringList(prefFavoritesKey, rawList);
    }
  }

  // ==========================================================================
  // METHOD 3: Menghapus item dari favorit berdasarkan ID
  // ==========================================================================
  static Future<void> removeFavorite(int characterId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getFavorites();

    // Hapus item yang memiliki id yang sama
    list.removeWhere((c) => c.id == characterId);

    // Simpan kembali list yang sudah bersih
    final rawList = list.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(prefFavoritesKey, rawList);
  }

  // ==========================================================================
  // METHOD 4: Mengecek apakah suatu ID sudah tersimpan di favorit
  // ==========================================================================
  static Future<bool> isFavorite(int characterId) async {
    final list = await getFavorites();
    return list.any((c) => c.id == characterId);
  }
}
