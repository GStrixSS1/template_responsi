// ============================================================================
// FILE: models/character_model.dart
// ============================================================================
// FUNGSI FILE INI:
// Cetak biru (blueprint) data utama aplikasi. Mengubah teks JSON mentah dari API
// menjadi Object Dart yang mudah dipanggil dengan titik (.) di UI (contoh: item.name).
//
// HUBUNGAN DENGAN FILE LAIN:
// 1. api_service.dart          -> Mengubah list json menjadi list CharacterModel:
//                                 CharacterModel.fromJson(jsonItem)
// 2. character_controller.dart -> Menampung datanya dalam RxList<CharacterModel> characterList
// 3. character_list_view.dart  -> Membaca datanya untuk card: character.name, character.image
// 4. character_detail_view.dart-> Menerima objek ini sebagai parameter halaman detail
// 5. favorite_service.dart     -> Mengubah objek ini jadi teks string via toJson() & jsonEncode()
//
// PANDUAN RESPONSI - JIKA ASLAB MEMBERIKAN API BERBEDA BESOK:
// 1. Lihat contoh response JSON dari Aslab di browser/Postman.
// 2. Samakan key di json['...'] dengan nama key dari Aslab:
//    - Jika API berita: json['title'], json['description'], json['thumbnail']
//    - Jika API produk: json['title'], json['price'], json['thumbnail'], json['category']
//    - Jika API resto:  json['strMeal'], json['strMealThumb'], json['strCategory']
// 3. Selalu beri nilai fallback (?? '' atau ?? 0) agar aplikasi tidak crash jika data null!
// ============================================================================

class CharacterModel {
  // 1. DEFINISI PROPERTY / ATRIBUT
  // Property ini yang akan Anda panggil di file UI (contoh: widget.character.name)
  final int id;
  final String name;
  final String status;
  final String species;
  final String gender;
  final String origin;
  final String location;
  final String image;

  // 2. CONSTRUCTOR
  // Digunakan untuk inisialisasi semua variabel wajib di atas
  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
  });

  // 3. FACTORY FROMJSON
  // Bagian paling krusial saat Responsi!
  // Fungsi ini bertugas membaca Map JSON dari API dan memasukkannya ke variabel Dart.
  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      // [TIPS RESPONSI]: Gunakan int.tryParse jika id dari API kadang berupa string "1" bukan integer 1
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,

      // [TIPS RESPONSI]: Jika aslab ganti nama field (misal 'title' bukan 'name'),
      // Anda tinggal ganti menjadi: name: json['title'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 'unknown',
      species: json['species'] ?? 'Unknown',
      gender: json['gender'] ?? 'Unknown',

      // [TIPS RESPONSI]: Cara menangani JSON bertingkat (nested object):
      // Jika di JSON bentuknya: "origin": { "name": "Earth" }, maka cara ambilnya:
      // json['origin']['name']
      origin: json['origin'] is Map
          ? (json['origin']['name'] ?? 'Unknown')
          : (json['origin']?.toString() ?? 'Unknown'),

      location: json['location'] is Map
          ? (json['location']['name'] ?? 'Unknown')
          : (json['location']?.toString() ?? 'Unknown'),

      // [TIPS RESPONSI]: Jika nama key gambar di API adalah 'poster', 'thumbnail', atau 'avatar',
      // ganti: image: json['thumbnail'] ?? json['poster'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // 4. METHOD TOJSON
  // Digunakan untuk mengubah Object Dart kembali menjadi Map/JSON.
  // Wajib ada untuk fitur FAVORITE (karena SharedPreferences hanya bisa menyimpan String).
  // Nanti di favorite_service.dart: jsonEncode(character.toJson())
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'gender': gender,
      'origin': origin,
      'location': location,
      'image': image,
    };
  }
}
