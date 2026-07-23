import 'package:flutter/material.dart';

abstract class Renkler {
  static const Color kagit = Color(0xFFF2ECDD);
  static const Color kagitKoyu = Color(0xFFE7DFC9);
  static const Color murekkep = Color(0xFF22314A);
  static const Color murekkepSoluk = Color(0xFF5A6A85);
  static const Color damga = Color(0xFFA32638);
  static const Color onay = Color(0xFF2E6B4F);
  static const Color cizgi = Color(0xFFC9BFA3);
  static const Color beyazKutucuk = Color(0x66FFFFFF);

  // Yaşa göre ton varyasyonları (Ferman / Parşömen Sararması)
  static const Color kagitCocukluk = Color(0xFFF9F5EA);
  static const Color kagitOkul = Color(0xFFF2ECDD);
  static const Color kagitGenclik = Color(0xFFEDE5CF);
  static const Color kagitKariyer = Color(0xFFE8DEBF);
  static const Color kagitYaslilik = Color(0xFFE1D4B0);

  static const Color kagitKoyuCocukluk = Color(0xFFEDE5D5);
  static const Color kagitKoyuOkul = Color(0xFFE7DFC9);
  static const Color kagitKoyuGenclik = Color(0xFFE0D7BF);
  static const Color kagitKoyuKariyer = Color(0xFFD9CCAF);
  static const Color kagitKoyuYaslilik = Color(0xFFD0C1A0);

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
