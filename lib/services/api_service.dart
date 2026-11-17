// ============================================================================
// FILE: services/api_service.dart
// ============================================================================
// FUNGSI FILE INI:
// Jembatan komunikasi ke internet (HTTP Client) untuk mengambil data dari REST API.
// Menggunakan package `http`.
//
// HUBUNGAN DENGAN FILE LAIN:
// 1. character_controller.dart -> Memanggil: ApiService.getCharacters(...)
// 2. episode_controller.dart   -> Memanggil: ApiService.getEpisodes()
// 3. character_model.dart      -> Digunakan untuk menampung data hasil decode JSON
//
// PANDUAN RESPONSI - JIKA GANTI URL API BESOK:
// 1. Ganti baseUrl di bawah:
//      static const String baseUrl = 'https://api-dari-aslab.com/v1';
// 2. Perhatikan FORMAT RESPONSE JSON DARI ASLAB (Buka link di Chrome / Postman):
//    - Tipe A: Response dibungkus Object (seperti Rick&Morty / DummyJSON):
//        { "results": [ {...}, {...} ] }
//        -> Cara ambil: final List results = data['results'] ?? data['products'] ?? [];
//    - Tipe B: Response langsung berupa List array murni (seperti TVMaze):
//        [ {...}, {...} ]
//        -> Cara ambil: final List results = jsonDecode(response.body);
// 3. Ubah nama model yang dipanggil:
//        results.map((item) => NamaModel.fromJson(item)).toList();
// ============================================================================

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character_model.dart';
import '../models/episode_model.dart';

class ApiService {
  // Ganti baseUrl ini sesuai endpoint yang diberikan Aslab saat ujian
  static const String baseUrl = 'https://rickandmortyapi.com/api';

  // ==========================================================================
  // METHOD 1: Mengambil List Data Utama (dengan Filter Status & Search Nama)
  // Dipanggil oleh: CharacterController.fetchCharacters()
  // ==========================================================================
  static Future<List<CharacterModel>> getCharacters({
    String? status,
    String? name,
  }) async {
    // Menyiapkan query parameter untuk search & filter (?status=alive&name=rick)
    final queryParams = <String, String>{};
    if (status != null && status.isNotEmpty && status.toLowerCase() != 'all') {
      queryParams['status'] = status.toLowerCase();
    }
    if (name != null && name.trim().isNotEmpty) {
      queryParams['name'] = name.trim();
    }

    // Menggabungkan baseUrl dengan endpoint '/character' dan parameter
    final uri = Uri.parse('$baseUrl/character').replace(
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    // Melakukan HTTP GET request ke server
    final response = await http.get(uri);

    // Cek status response dari server
    if (response.statusCode == 200) {
      // jsonDecode mengubah teks JSON mentah menjadi Map<String, dynamic>
      final data = jsonDecode(response.body);

      // Mengambil array list data (sesuaikan key 'results' dengan struktur JSON aslab)
      final List results = data['results'] ?? [];

      // Melakukan loop mapping setiap item JSON menjadi objek CharacterModel
      return results.map((item) => CharacterModel.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      // Jika hasil pencarian tidak ditemukan (404), kembalikan list kosong
      return [];
    } else {
      // Jika terjadi error lain (contoh 500 server down), lempar Exception
      throw Exception('Gagal memuat data karakter (${response.statusCode})');
    }
  }

  // ==========================================================================
  // METHOD 2: Mengambil Detail 1 Data berdasarkan ID
  // Dipanggil jika halaman detail butuh fetch data terpisah dari internet
  // ==========================================================================
  static Future<CharacterModel> getCharacterDetail(int id) async {
    final uri = Uri.parse('$baseUrl/character/$id');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CharacterModel.fromJson(data);
    } else {
      throw Exception('Gagal memuat detail karakter (${response.statusCode})');
    }
  }

  // ==========================================================================
  // METHOD 3: Mengambil Data Sekunder (Contoh: Episode / Kategori)
  // Dipanggil oleh: EpisodeController.fetchEpisodes()
  // ==========================================================================
  static Future<List<EpisodeModel>> getEpisodes() async {
    final uri = Uri.parse('$baseUrl/episode');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List results = data['results'] ?? [];
      return results.map((item) => EpisodeModel.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat data episode (${response.statusCode})');
    }
  }
}

