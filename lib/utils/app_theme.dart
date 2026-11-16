// ============================================================================
// FILE: utils/app_theme.dart
// ============================================================================
// FUNGSI FILE INI:
// Pusat konfigurasi tema, warna, dan gaya tampilan seluruh aplikasi.
// Menggunakan Material 3 Dark Theme bernuansa Cyber/Portal Rick & Morty.
//
// CARA MENGGUNAKANNYA DI FILE LAIN:
// 1. Di main.dart:
//      theme: AppTheme.darkTheme
// 2. Di file View manapun (untuk mengambil warna konsisten):
//      color: AppTheme.primary  // Hijau Neon
//      color: AppTheme.surface  // Abu gelap kartu
// ============================================================================

import 'package:flutter/material.dart';

class AppTheme {
  // Palet Warna Utama
  static const Color primary = Color(0xFF00E599);      // Hijau Neon Portal
  static const Color primaryDark = Color(0xFF059669);
  static const Color secondary = Color(0xFF38BDF8);    // Biru Muda Aksen
  static const Color background = Color(0xFF0F172A);   // Latar belakang gelap (Dark Slate)
  static const Color surface = Color(0xFF1E293B);      // Warna Kartu (Card)
  static const Color surfaceLight = Color(0xFF334155); // Warna Field Input
  static const Color textLight = Color(0xFFF8FAFC);    // Teks Putih
  static const Color textMuted = Color(0xFF94A3B8);    // Teks Abu-abu redup
  static const Color error = Color(0xFFEF4444);        // Merah Error

  // Indikator Status Karakter
  static const Color alive = Color(0xFF22C55E);        // Hijau
  static const Color dead = Color(0xFFEF4444);         // Merah
  static const Color unknown = Color(0xFF94A3B8);      // Abu-abu

  // Tema Gelap Lengkap (Material 3)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: textLight),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceLight.withAlpha(100),
        hintStyle: const TextStyle(color: textMuted),
        labelStyle: const TextStyle(color: textMuted),
        prefixIconColor: primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: surfaceLight.withAlpha(150)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.black,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Method pembantu untuk memberikan warna badge status (Alive = Hijau, Dead = Merah)
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return alive;
      case 'dead':
        return dead;
      default:
        return unknown;
    }
  }
}
