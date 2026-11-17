// ============================================================================
// FILE: models/episode_model.dart
// ============================================================================
// FUNGSI FILE INI:
// Model data kedua (sekunder) dalam aplikasi.
// Seringkali aslab memberikan 2 tab data (misal: Daftar Produk & Kategori,
// atau Daftar Film & Jadwal Tayang, atau Karakter & Episode).
//
// HUBUNGAN DENGAN FILE LAIN:
// 1. api_service.dart        -> Mengambil data dari endpoint kedua: ApiService.getEpisodes()
// 2. episode_controller.dart -> Menampung datanya dalam RxList<EpisodeModel> episodeList
// 3. episode_list_view.dart  -> Menampilkan list di tab Navigasi ketiga
//
// PANDUAN RESPONSI:
// Perhatikan nama key di JSON API:
// Seringkali di API menggunakan format snake_case (seperti 'air_date'),
// sedangkan di Dart kita gunakan camelCase ('airDate').
// Mapping-nya dilakukan di factory fromJson:
// airDate: json['air_date'] ?? ''
// ============================================================================

class EpisodeModel {
  final int id;
  final String name;
  final String airDate;
  final String episode;

  EpisodeModel({
    required this.id,
    required this.name,
    required this.airDate,
    required this.episode,
  });

  // Factory fromJson: Mengonversi Map JSON ke EpisodeModel
  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? '',
      // Mapping snake_case dari JSON API ke variabel camelCase Dart
      airDate: json['air_date'] ?? '',
      episode: json['episode'] ?? '',
    );
  }

  // Method toJson: Mengonversi objek ke Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'air_date': airDate,
      'episode': episode,
    };
  }
}

