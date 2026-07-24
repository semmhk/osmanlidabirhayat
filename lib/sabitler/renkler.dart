import 'package:flutter/material.dart';

abstract class Renkler {
  static const Color kagit = Color(0xFFF4EBD9); // Eskitme ferman kremi
  static const Color kagitKoyu = Color(0xFF2C221B); // Koyu sepya
  static const Color murekkep = Color(0xFF1F140E); // Koyu kahve mürekkep
  static const Color murekkepSoluk = Color(0xFF6E594F); // Soluk kahve
  static const Color damga = Color(0xFF8B0000); // Osmanlı kırmızısı mühür
  static const Color altin = Color(0xFFD4AF37); // Altın varak vurgu
  static const Color onay = Color(0xFF2E6B4F); // Dergah yeşili
  static const Color cizgi = Color(0xFFB5A07B); // Eskitme parşömen çizgisi
  static const Color beyazKutucuk = Color(0x66FFFFFF);

  // Yaşa göre parşömen sararma tonları
  static const Color kagitCocukluk = Color(0xFFFAF5EA);
  static const Color kagitOkul = Color(0xFFF4EBD9);
  static const Color kagitGenclik = Color(0xFFEBDCBD);
  static const Color kagitKariyer = Color(0xFFE2CFA8);
  static const Color kagitYaslilik = Color(0xFFD8C6A6);

  static const Color kagitKoyuCocukluk = Color(0xFF3B2E25);
  static const Color kagitKoyuOkul = Color(0xFF2C221B);
  static const Color kagitKoyuGenclik = Color(0xFF241B15);
  static const Color kagitKoyuKariyer = Color(0xFF1F1711);
  static const Color kagitKoyuYaslilik = Color(0xFF18110B);

  static Color kagitGetirYasaGore(int yas) {
    if (yas <= 6) return kagitCocukluk;
    if (yas <= 17) return kagitOkul;
    if (yas <= 25) return kagitGenclik;
    if (yas <= 59) return kagitKariyer;
    return kagitYaslilik;
  }

  static Color kagitKoyuGetirYasaGore(int yas) {
    if (yas <= 6) return kagitKoyuCocukluk;
    if (yas <= 17) return kagitKoyuOkul;
    if (yas <= 25) return kagitKoyuGenclik;
    if (yas <= 59) return kagitKoyuKariyer;
    return kagitKoyuYaslilik;
  }
}
