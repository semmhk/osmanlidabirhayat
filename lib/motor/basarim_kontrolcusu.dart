import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../modeller/basarim.dart';
import '../modeller/karakter.dart';
import '../modeller/meslek.dart';

class BasarimKontrolcu {
  static const String boxName = 'basarimlar_box';

  static Future<Box<String>?> _boxAc() async {
    try {
      if (Hive.isBoxOpen(boxName)) {
        return Hive.box<String>(boxName);
      }
      // Hive path ayarlanmamışsa (örn: test ortamı) hata vermemesi için güvenli açma
      final box = await Hive.openBox<String>(boxName).catchError((Object _) => null as dynamic);
      return box;
    } catch (_) {
      return null;
    }
  }

  /// Statik başarımlar kataloğunu assets/basarimlar.json'dan yükler
  static Future<List<Basarim>> basarimlariYukle({String? jsonMetni}) async {
    final String metin = jsonMetni ?? await rootBundle.loadString('assets/basarimlar.json');
    final List<dynamic> liste = jsonDecode(metin) as List<dynamic>;
    final box = await _boxAc();

    return liste.map((e) {
      final jsonMap = e as Map<String, dynamic>;
      final id = jsonMap['id'] as String;
      final kazanmaTarihi = box?.get(id);
      return Basarim.fromJson(
        jsonMap,
        kazanildi: kazanmaTarihi != null,
        kazanmaTarihi: kazanmaTarihi,
      );
    }).toList();
  }

  /// Karakter canlıyken veya vefat ettiğinde başarımları kontrol eder ve yenileri kaydeder
  static Future<List<Basarim>> kontrolEt(
    Karakter k, {
    List<int>? gecmisHayatYaslari,
    List<Basarim>? yuklenmisBasarimlar,
    bool olumAnimi = false,
  }) async {
    final basarimlar = yuklenmisBasarimlar ?? await basarimlariYukle();
    final box = await _boxAc();
    final bugunIso = DateTime.now().toIso8601String().substring(0, 10);
    final List<Basarim> yeniKazanilanlar = [];

    for (final b in basarimlar) {
      if (b.kazanildi) continue;

      bool kosulSaglandi = false;

      switch (b.id) {
        case 'ilk_nesil':
          kosulSaglandi = olumAnimi;
          break;

        case 'uzun_omur':
          kosulSaglandi = olumAnimi && k.yas >= 80;
          break;

        case 'emektar':
          if (olumAnimi && k.yas >= 60) {
            if (gecmisHayatYaslari != null && gecmisHayatYaslari.length >= 2) {
              final sonIki = gecmisHayatYaslari.take(2).toList();
              if (sonIki.every((y) => y >= 60)) {
                kosulSaglandi = true;
              }
            }
          }
          break;

        case 'lonca_ustabasi':
          if (k.meslekZincirId == 'ahilik') {
            final zincir = MeslekDeposu.zincirGetir('ahilik');
            if (zincir != null && k.meslekKademesi >= (zincir.kademeler.length - 1)) {
              kosulSaglandi = true;
            }
          }
          break;

        case 'divan_efendisi':
          if (k.meslekZincirId == 'kalemiye') {
            final zincir = MeslekDeposu.zincirGetir('kalemiye');
            if (zincir != null && k.meslekKademesi >= (zincir.kademeler.length - 1)) {
              kosulSaglandi = true;
            }
          }
          break;

        case 'kadiasker':
          if (k.meslekZincirId == 'ilmiye') {
            final zincir = MeslekDeposu.zincirGetir('ilmiye');
            if (zincir != null && k.meslekKademesi >= (zincir.kademeler.length - 1)) {
              kosulSaglandi = true;
            }
          }
          break;

        case 'serdar_aga':
          if (k.meslekZincirId == 'seyfiye') {
            final zincir = MeslekDeposu.zincirGetir('seyfiye');
            if (zincir != null && k.meslekKademesi >= (zincir.kademeler.length - 1)) {
              kosulSaglandi = true;
            }
          }
          break;

        case 'zengin_olum':
          kosulSaglandi = olumAnimi && (k.bakiye >= 300 || k.para >= 300);
          break;

        case 'aile_ocagi':
          kosulSaglandi = k.bayraklar.contains('evli') && k.cocukSayisi >= 2;
          break;

        case 'yalniz_kurt':
          kosulSaglandi = !k.bayraklar.contains('evli') && k.yas >= 60;
          break;

        case 'sifirdan_zirveye':
          kosulSaglandi = k.hicVasifsizIsciOldu && k.meslekZincirId != null && k.meslekKademesi > 0;
          break;

        case 'ikinci_bahar':
          kosulSaglandi = k.bayraklar.contains('ikinci_evlilik');
          break;

        case 'ahalinin_gururu':
          kosulSaglandi = k.zirveItibar >= 90;
          break;

        case 'ulu_kisi':
          kosulSaglandi = k.zirveZeka >= 90;
          break;
      }

      if (kosulSaglandi) {
        final guncelBasarim = b.copyWith(
          kazanildi: true,
          kazanmaTarihi: bugunIso,
        );
        box?.put(b.id, bugunIso);
        yeniKazanilanlar.add(guncelBasarim);
      }
    }

    return yeniKazanilanlar;
  }
}
