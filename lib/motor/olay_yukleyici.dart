import 'dart:convert';
import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:flutter/foundation.dart';
import '../modeller/olay.dart';

class OlayYukleyici {
  static const List<String> olayDosyalari = [
    'assets/olaylar/kurulus.json',
    'assets/olaylar/yukselme.json',
    'assets/olaylar/duraklama.json',
    'assets/olaylar/gerileme.json',
    'assets/olaylar/dagilma.json',
  ];

  static const Set<String> gecerliStatlar = {
    'saglik',
    'mutluluk',
    'zeka',
    'para',
    'itibar',
  };

  static const Set<String> gecerliBayraklar = {
    'evli',
    'cocuklu',
    'medrese_mezunu',
    'meslek_ahilik',
    'meslek_ilmiye',
    'meslek_seyfiye',
    'meslek_kalemiye',
    'terfi_edildi',
    'calisaniyor',
    'dul_bosanmis',
    'ikinci_evlilik',
    'salgin_maruz',
    'savas_cebhe',
  };

  static const Set<String> gecerliMeslekler = {
    'ahilik',
    'ilmiye',
    'seyfiye',
    'kalemiye',
    'rastgele_degistir',
  };

  Future<List<Olay>> tumunuYukle({AssetBundle? bundle}) async {
    final targetBundle = bundle ?? rootBundle;
    final List<Olay> tumOlaylar = [];
    final Set<String> gorulenIdler = {};

    for (final dosyaYolu in olayDosyalari) {
      try {
        final jsonString = await targetBundle.loadString(dosyaYolu);
        final olaylar = jsonMetnindenYukle(jsonString, dosyaYolu, gorulenIdler);
        tumOlaylar.addAll(olaylar);
      } catch (e) {
        debugPrint('[OlayYukleyici] Hata! Dosya okunamadı: $dosyaYolu -> $e');
      }
    }

    return tumOlaylar;
  }

  List<Olay> jsonMetnindenYukle(
    String jsonString,
    String dosyaAdi, [
    Set<String>? gorulenIdler,
  ]) {
    final List<Olay> yuklenenler = [];
    final idSet = gorulenIdler ?? <String>{};

    dynamic jsonList;
    try {
      jsonList = json.decode(jsonString);
    } catch (e) {
      debugPrint('[OlayYukleyici] Hata! Geçersiz JSON yapısı [$dosyaAdi]: $e');
      return yuklenenler;
    }

    if (jsonList is! List) {
      debugPrint('[OlayYukleyici] Hata! JSON liste değil [$dosyaAdi]');
      return yuklenenler;
    }

    for (var i = 0; i < jsonList.length; i++) {
      final item = jsonList[i];
      if (item is! Map<String, dynamic>) {
        debugPrint('[OlayYukleyici] Hata! Olay bir obje/Map değil [$dosyaAdi, indeks $i]');
        continue;
      }

      final olayId = item['id']?.toString() ?? 'BILINMEYEN_ID';
      final hata = dogrulaOlaySemasi(item, idSet);

      if (hata != null) {
        debugPrint('[OlayYukleyici] Şema Hatası! Dosya: $dosyaAdi, ID: $olayId -> Hata: $hata');
        continue;
      }

      try {
        final olay = Olay.fromJson(item);
        yuklenenler.add(olay);
        idSet.add(olay.id);
      } catch (e) {
        debugPrint('[OlayYukleyici] Parse Hatası! Dosya: $dosyaAdi, ID: $olayId -> $e');
      }
    }

    return yuklenenler;
  }

  String? dogrulaOlaySemasi(Map<String, dynamic> json, Set<String> mevcutIdler) {
    if (!json.containsKey('id') || json['id'] is! String || (json['id'] as String).trim().isEmpty) {
      return 'Geçersiz veya boş "id"';
    }

    final id = json['id'] as String;
    if (mevcutIdler.contains(id)) {
      return 'Çift (duplicate) ID: "$id" zaten kullanılmış!';
    }

    if (!json.containsKey('yas_min') || json['yas_min'] is! num) {
      return '"yas_min" eksik veya sayı değil';
    }

    if (!json.containsKey('yas_max') || json['yas_max'] is! num) {
      return '"yas_max" eksik veya sayı değil';
    }

    final yasMin = (json['yas_min'] as num).toInt();
    final yasMax = (json['yas_max'] as num).toInt();

    if (yasMin < 0) {
      return '"yas_min" negatif olamaz ($yasMin)';
    }

    if (yasMin > yasMax) {
      return '"yas_min" ($yasMin), "yas_max" ($yasMax) değerinden büyük olamaz';
    }

    // Tarih Yılı Min ve Max Doğrulaması
    if (json.containsKey('tarih_yil_min') && json['tarih_yil_min'] != null) {
      if (json['tarih_yil_min'] is! num) {
        return '"tarih_yil_min" sayı olmak zorundadır';
      }
    }

    if (json.containsKey('tarih_yil_max') && json['tarih_yil_max'] != null) {
      if (json['tarih_yil_max'] is! num) {
        return '"tarih_yil_max" sayı olmak zorundadır';
      }
    }

    if (json.containsKey('tarih_yil_min') &&
        json['tarih_yil_min'] != null &&
        json.containsKey('tarih_yil_max') &&
        json['tarih_yil_max'] != null) {
      final tMin = (json['tarih_yil_min'] as num).toInt();
      final tMax = (json['tarih_yil_max'] as num).toInt();
      if (tMin > tMax) {
        return '"tarih_yil_min" ($tMin), "tarih_yil_max" ($tMax) değerinden büyük olamaz';
      }
    }

    // Alt Dönem Doğrulaması (Opsiyonel String)
    if (json.containsKey('alt_donem') && json['alt_donem'] != null) {
      if (json['alt_donem'] is! String) {
        return '"alt_donem" metin (String) olmak zorundadır';
      }
    }

    if (!json.containsKey('metin') || json['metin'] is! String || (json['metin'] as String).trim().isEmpty) {
      return '"metin" alanı eksik veya boş';
    }

    if (!json.containsKey('secenekler') || json['secenekler'] is! List || (json['secenekler'] as List).isEmpty) {
      return '"secenekler" listesi eksik veya boş';
    }

    final secenekler = json['secenekler'] as List;
    for (var i = 0; i < secenekler.length; i++) {
      final secenek = secenekler[i];
      if (secenek is! Map<String, dynamic>) {
        return 'Seçenek #$i bir obje/Map değil';
      }

      if (!secenek.containsKey('metin') || secenek['metin'] is! String || (secenek['metin'] as String).trim().isEmpty) {
        return 'Seçenek #$i "metin" alanı eksik veya boş';
      }

      if (!secenek.containsKey('sonuc') || secenek['sonuc'] is! String || (secenek['sonuc'] as String).trim().isEmpty) {
        return 'Seçenek #$i "sonuc" alanı eksik veya boş';
      }
    }

    return null;
  }
}
