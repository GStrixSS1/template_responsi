// ============================================================================
// FILE: models/user_model.dart
// ============================================================================
// FUNGSI FILE INI:
// Model data untuk menyimpan informasi akun pengguna (User) ke Hive Database (Database Lokal).
//
// CARA KERJA HIVE:
// Hive adalah database lokal NoSQL berupa Key-Value. Agar class UserModel bisa
// disimpan langsung ke dalam Box Hive tanpa error, kita butuh TypeAdapter (UserModelAdapter).
//
// HUBUNGAN DENGAN FILE LAIN:
// 1. main.dart          -> Wajib mendaftarkan adapter ini: Hive.registerAdapter(UserModelAdapter())
// 2. auth_service.dart  -> Menggunakan Box<UserModel> untuk simpan (register) & baca (login)
// 3. auth_controller.dart -> Memanggil auth_service untuk validasi input form
//
// PANDUAN RESPONSI - BAGAIMANA JIKA ASLAB MINTA FIELD TAMBAHAN? (Misal: email / NIM):
// 1. Tambah property di class UserModel:
//      @HiveField(3)
//      final String nim;
// 2. Tambah parameter di constructor UserModel({..., required this.nim});
// 3. Update UserModelAdapter:
//      Di method read(): nim: fields[3] as String
//      Di method write(): ..writeByte(4) ... ..writeByte(3)..write(obj.nim)
// ============================================================================

import 'package:hive/hive.dart';

// typeId: Identifier unik untuk Hive TypeAdapter (gunakan angka 0, 1, 2, dst)
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  // @HiveField(index): Urutan binary field di Hive. Jangan ubah index yang sudah ada.
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String fullName;

  UserModel({
    required this.username,
    required this.password,
    required this.fullName,
  });
}

// ============================================================================
// TYPE ADAPTER MANUAL:
// Dibuat manual agar TIDAK PERLU menjalankan build_runner (flutter pub run build_runner build)
// yang sering lemot/error saat ujian responsi.
// ============================================================================
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  // Method read: Membaca data binary dari Hive disk dan mengubahnya jadi objek UserModel
  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      username: fields[0] as String,
      password: fields[1] as String,
      fullName: fields[2] as String,
    );
  }

  // Method write: Mengubah objek UserModel menjadi binary untuk disimpan di disk
  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(3) // Jumlah total field yang ditulis (ada 3: username, password, fullName)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.fullName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

