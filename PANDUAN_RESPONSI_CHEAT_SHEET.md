# 🚀 CHEAT SHEET & PANDUAN CEPAT RESPONSI PRAKTIKUM MOBILE

Dokumen ini adalah rangkuman kilat jika besok saat ujian praktikum / responsi, Aslab memberikan tema atau API baru.

---

## 🧭 URUTAN MODIFIKASI FILE (JANGAN DIBALIK!)
Saat mendapat API baru dari Aslab, ikuti urutan 5 langkah ini:
```
1. Model (models/)        -> Tentukan struktur data & parse JSON
2. ApiService (services/) -> Ubah URL endpoint & mapping ke Model
3. Controller (controllers/) -> Panggil ApiService & simpan ke RxList
4. View (views/)          -> Tampilkan ke layar dengan Obx & ListView
5. Detail & Favorite      -> Sesuaikan field yang ditampilkan & simpan ke SharedPreferences
```

---

## 1. LANGKAH 1: LIHAT JSON DARI ASLAB
Buka link endpoint API yang diberikan Aslab di browser (Chrome / Edge).
Perhatikan strukturnya:

### Tipe A: Dibungkus Object (Contoh: Rick & Morty / DummyJSON)
```json
{
  "results": [
    {
      "id": 1,
      "name": "Rick Sanchez",
      "image": "https://..."
    }
  ]
}
```
👉 Cara ambil di `api_service.dart`:
```dart
final data = jsonDecode(response.body);
final List results = data['results'] ?? []; // atau data['products'] / data['data']
return results.map((item) => NamaModel.fromJson(item)).toList();
```

### Tipe B: Langsung Array / List Murni (Contoh: TVMaze)
```json
[
  {
    "id": 1,
    "name": "Under the Dome",
    "image": { "medium": "https://..." }
  }
]
```
👉 Cara ambil di `api_service.dart`:
```dart
final List results = jsonDecode(response.body);
return results.map((item) => NamaModel.fromJson(item)).toList();
```

---

## 2. LANGKAH 2: CARA UBAH MODEL (`models/character_model.dart`)
Sesuaikan nama property dan key `json['...']`:
```dart
class ProdukModel {
  final int id;
  final String title;
  final String price;
  final String thumbnail;

  ProdukModel({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
  });

  factory ProdukModel.fromJson(Map<String, dynamic> json) {
    return ProdukModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title'] ?? '',
      price: json['price']?.toString() ?? '0',
      thumbnail: json['thumbnail'] ?? '',
    );
  }

  // Wajib untuk fitur favorit SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'thumbnail': thumbnail,
    };
  }
}
```

---

## 3. LANGKAH 3: CARA MANGGIL CONTROLLER DI FILE SEBELAH (VIEW)
Banyak yang bingung: *"Gimana cara View manggil Controller?"*

### A. Di dalam Widget `build(BuildContext context)`:
```dart
// 1. Ambil instance controller yang sudah didaftarkan
final NamaController controller = Get.find<NamaController>();
final FavoriteController favController = Get.find<FavoriteController>();
```

### B. Tampilkan data secara reaktif dengan `Obx`:
```dart
Obx(() {
  // Cek loading
  if (controller.isLoading.value) {
    return const Center(child: CircularProgressIndicator());
  }

  // Cek data kosong
  if (controller.items.isEmpty) {
    return const Center(child: Text('Data tidak ditemukan'));
  }

  // Tampilkan ListView
  return ListView.builder(
    itemCount: controller.items.length,
    itemBuilder: (context, index) {
      final item = controller.items[index];

      return ListTile(
        leading: Image.network(item.thumbnail),
        title: Text(item.title),
        subtitle: Text('Rp ${item.price}'),
        // CARA PINDAH KE DETAIL DENGAN MENGIRIM DATA:
        onTap: () {
          Get.to(() => DetailView(item: item));
        },
      );
    },
  );
})
```

---

## 4. LANGKAH 4: CARA KERJA FITUR FAVORIT (DISMISSIBLE)
### A. Tombol Hati di Card atau Halaman Detail:
```dart
Obx(() {
  final isFav = favController.isFavorite(item.id);
  return IconButton(
    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
    color: isFav ? Colors.redAccent : Colors.grey,
    onPressed: () {
      favController.toggleFavorite(item);
    },
  );
})
```

### B. Geser untuk Hapus (Swipe to Delete) di `FavoriteListView`:
```dart
Dismissible(
  key: Key('fav_${item.id}'),
  direction: DismissDirection.endToStart, // Geser dari kanan ke kiri
  background: Container(
    color: Colors.redAccent,
    alignment: Alignment.centerRight,
    padding: const EdgeInsets.only(right: 20),
    child: const Icon(Icons.delete, color: Colors.white),
  ),
  onDismissed: (direction) {
    favController.removeFavoriteOnSwipe(item);
  },
  child: Card(...),
)
```

---

## 5. LANGKAH 5: AUTENTIKASI (HIVE & SESSION)
- **Akun Bawaan (Default)**:
  - Username: `admin`
  - Password: `admin123` (atau `password123`)
- **Tabel User**: Disimpan di Hive Box (`users_box`).
- **Session Login**: Disimpan di SharedPreferences (`is_logged_in: true`).
- **Logout**: Menghapus flag di SharedPreferences dan `Get.offAll(() => const LoginView())`.

---

## 🎯 DAFTAR TEMPLATE YANG SUDAH SIAP DIPAKAI
Jika besok tema soalnya sesuai tebakan, langsung buka folder / branch berikut:
1. **Rick & Morty**  -> `list tema\template_rickandmorty` (Lengkap dengan komentar panduan)
2. **E-Commerce**    -> `list tema\template_ecommerce` (Branch: `tema-ecommerce`)
3. **Berita**        -> `list tema\template_berita` (Branch: `tema-berita`)
4. **Restoran**      -> `list tema\template_restoran` (Branch: `tema-restoran`)
5. **Bioskop/Film**  -> `list tema\template_bioskop` (Branch: `tema-bioskop`)

