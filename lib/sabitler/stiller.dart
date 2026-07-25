import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Osmanlı'da Bir Hayat — Merkezi Tasarım Sistemi ve Stil Sabitleri
class Stiller {
  // --- RENK PALETİ ---
  static const Color koyuKahve = Color(0xFF1F140E);
  static const Color ortaKahve = Color(0xFF3D271D);
  static const Color sepyaArkaplan = Color(0xFF2A1C15);
  static const Color parsomen = Color(0xFFF4EAD5);
  static const Color koyuParsomen = Color(0xFFE5D3B3);
  static const Color altinSarisi = Color(0xFFD4AF37);
  static const Color parlakAltin = Color(0xFFFFD700);
  static const Color altinKoyu = Color(0xFFAA820A);
  static const Color kirmiziOsmanli = Color(0xFF8B0000);
  static const Color yesilOsmanli = Color(0xFF1B4D3E);
  static const Color bordo = Color(0xFF58111A);

  // --- Koyu Sepya Gölgeler (Siyah Değil!) ---
  static List<BoxShadow> get kartGolge => [
        BoxShadow(
          color: const Color(0xFF0F0A07).withAlpha(165),
          blurRadius: 10,
          offset: const Offset(0, 5),
          spreadRadius: 1,
        ),
        BoxShadow(
          color: altinSarisi.withAlpha(40),
          blurRadius: 1,
          offset: const Offset(0, 0),
          spreadRadius: 1,
        ),
      ];

  static List<BoxShadow> get altinGolge => [
        BoxShadow(
          color: parlakAltin.withAlpha(90),
          blurRadius: 12,
          offset: const Offset(0, 0),
          spreadRadius: 2,
        ),
        BoxShadow(
          color: const Color(0xFF0F0A07).withAlpha(200),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get butonGolge => [
        BoxShadow(
          color: const Color(0xFF0A0705).withAlpha(180),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  // --- KENARLAR VE ÇERÇEVELER ---
  static BoxDecoration get altinKartStili => BoxDecoration(
        color: sepyaArkaplan,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: altinSarisi, width: 1.5),
        boxShadow: kartGolge,
      );

  static BoxDecoration get madalyonCerceve => BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: parlakAltin, width: 2.5),
        boxShadow: altinGolge,
      );

  // --- TİPOGRAFİ (Cinzel & Lora) ---
  static TextStyle baslikStili({
    double fontSize = 20,
    Color color = parlakAltin,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return GoogleFonts.cinzel(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      letterSpacing: 0.8,
    );
  }

  static TextStyle padisahIsimStili({
    double fontSize = 16,
    Color color = parlakAltin,
  }) {
    return GoogleFonts.cinzel(
      fontSize: fontSize,
      color: color,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle govdeStili({
    double fontSize = 14,
    Color color = parsomen,
    FontWeight fontWeight = FontWeight.normal,
    double height = 1.4,
  }) {
    return GoogleFonts.lora(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height,
    );
  }

  static TextStyle altMetinStili({
    double fontSize = 12,
    Color color = koyuParsomen,
  }) {
    return GoogleFonts.lora(
      fontSize: fontSize,
      color: color,
      fontStyle: FontStyle.italic,
    );
  }
}
