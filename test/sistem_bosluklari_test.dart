import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:osmanli_da_bir_hayat/modeller/cocuk.dart';
import 'package:osmanli_da_bir_hayat/modeller/karakter.dart';
import 'package:osmanli_da_bir_hayat/modeller/olay.dart';
import 'package:osmanli_da_bir_hayat/motor/basarim_kontrolcusu.dart';
import 'package:osmanli_da_bir_hayat/motor/olay_yukleyici.dart';
import 'package:osmanli_da_bir_hayat/motor/oyun_motoru.dart';

void main() {
  group('3 Sistem Boşluğu Kapatma Testleri', () {
    late OlayYukleyici yukleyici;
    late List<Olay> kurulusOlaylari;

    setUpAll(() {
      final tempDir = Directory.systemTemp.createTempSync('hive_test');
      Hive.init(tempDir.path);
    });

    setUp(() {
      yukleyici = OlayYukleyici();
      final file = File('assets/olaylar/kurulus.json');
      final jsonString = file.readAsStringSync();
      kurulusOlaylari = yukleyici.jsonMetnindenYukle(jsonString, 'kurulus.json');
    });

    test('1. Toplam 385 olay (Kuruluş 138 + Yükselme 101 + Duraklama 118 + Gerileme 28) yüklenmeli ve benzersiz ID\'lere sahip olmalı', () {
      final fileKurulus = File('assets/olaylar/kurulus.json');
      final fileYukselme = File('assets/olaylar/yukselme.json');
      final fileDuraklama = File('assets/olaylar/duraklama.json');
      final fileGerileme = File('assets/olaylar/gerileme.json');
      final idSet = <String>{};
      final o1 = yukleyici.jsonMetnindenYukle(fileKurulus.readAsStringSync(), 'kurulus.json', idSet);
      final o2 = yukleyici.jsonMetnindenYukle(fileYukselme.readAsStringSync(), 'yukselme.json', idSet);
      final o3 = yukleyici.jsonMetnindenYukle(fileDuraklama.readAsStringSync(), 'duraklama.json', idSet);
      final o4 = yukleyici.jsonMetnindenYukle(fileGerileme.readAsStringSync(), 'gerileme.json', idSet);
      expect(o1.length + o2.length + o3.length + o4.length, equals(385));
      expect(idSet.length, equals(385));
    });

    test('2. Kalemiye meslek atama olayı (kurulus_073) doğru çalışmalı', () {
      final kalemiyeOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_073');
      expect(kalemiyeOlayi.altDonem, equals('orhan_gazi'));
      expect(kalemiyeOlayi.secenekler.first.meslekAtama, equals('kalemiye'));

      final k = Karakter(yas: 20);
      OyunMotoru.secenekUygula(k, kalemiyeOlayi.secenekler.first);
      expect(k.meslekZincirId, equals('kalemiye'));
      expect(k.bayraklar.contains('meslek_kalemiye'), isTrue);
    });

    test('3. Boşanma -> İkinci Nikah zinciri doğru çalışmalı', () {
      final talakOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_074');
      final ikinciNikahOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_076');

      final k = Karakter(yas: 30, bayraklar: {'evli'});
      expect(k.bayraklar.contains('evli'), isTrue);

      // Talak secenegi sec
      OyunMotoru.secenekUygula(k, talakOlayi.secenekler.first);
      expect(k.bayraklar.contains('evli'), isFalse);
      expect(k.bayraklar.contains('dul_bosanmis'), isTrue);

      // Ikinci nikah secenegi sec
      OyunMotoru.secenekUygula(k, ikinciNikahOlayi.secenekler.first);
      expect(k.bayraklar.contains('dul_bosanmis'), isFalse);
      expect(k.bayraklar.contains('evli'), isTrue);
      expect(k.bayraklar.contains('ikinci_evlilik'), isTrue);
    });

    test('4. 14 Başarımın tamamı doğru koşullarda tetiklenmeli (İndeks bazlı meslek kontrolleri dahil)', () async {
      final basarimlarJson = File('assets/basarimlar.json').readAsStringSync();
      final tumBasarimlar = await BasarimKontrolcu.basarimlariYukle(jsonMetni: basarimlarJson);
      expect(tumBasarimlar.length, equals(14));

      // Test 4.1: lonca_ustabasi (Ahilik max level)
      final kAhilik = Karakter(meslekZincirId: 'ahilik', meslekKademesi: 3);
      final bAhilik = await BasarimKontrolcu.kontrolEt(kAhilik, yuklenmisBasarimlar: tumBasarimlar);
      expect(bAhilik.any((b) => b.id == 'lonca_ustabasi'), isTrue);

      // Test 4.2: divan_efendisi (Kalemiye max level)
      final kKalemiye = Karakter(meslekZincirId: 'kalemiye', meslekKademesi: 3);
      final bKalemiye = await BasarimKontrolcu.kontrolEt(kKalemiye, yuklenmisBasarimlar: tumBasarimlar);
      expect(bKalemiye.any((b) => b.id == 'divan_efendisi'), isTrue);

      // Test 4.3: kadiasker (Ilmiye max level)
      final kIlmiye = Karakter(meslekZincirId: 'ilmiye', meslekKademesi: 3);
      final bIlmiye = await BasarimKontrolcu.kontrolEt(kIlmiye, yuklenmisBasarimlar: tumBasarimlar);
      expect(bIlmiye.any((b) => b.id == 'kadiasker'), isTrue);

      // Test 4.4: serdar_aga (Seyfiye max level)
      final kSeyfiye = Karakter(meslekZincirId: 'seyfiye', meslekKademesi: 3);
      final bSeyfiye = await BasarimKontrolcu.kontrolEt(kSeyfiye, yuklenmisBasarimlar: tumBasarimlar);
      expect(bSeyfiye.any((b) => b.id == 'serdar_aga'), isTrue);

      // Test 4.5: sifirdan_zirveye
      final kSifirdan = Karakter(meslekZincirId: 'ahilik', meslekKademesi: 1)..hicVasifsizIsciOldu = true;
      final bSifirdan = await BasarimKontrolcu.kontrolEt(kSifirdan, yuklenmisBasarimlar: tumBasarimlar);
      expect(bSifirdan.any((b) => b.id == 'sifirdan_zirveye'), isTrue);

      // Test 4.6: ikinci_bahar
      final kIkinciBahar = Karakter(bayraklar: {'ikinci_evlilik'});
      final bIkinciBahar = await BasarimKontrolcu.kontrolEt(kIkinciBahar, yuklenmisBasarimlar: tumBasarimlar);
      expect(bIkinciBahar.any((b) => b.id == 'ikinci_bahar'), isTrue);

      // Test 4.7: ahalinin_gururu & ulu_kisi
      final kZirve = Karakter(itibar: 95, zeka: 92);
      final bZirve = await BasarimKontrolcu.kontrolEt(kZirve, yuklenmisBasarimlar: tumBasarimlar);
      expect(bZirve.any((b) => b.id == 'ahalinin_gururu'), isTrue);
      expect(bZirve.any((b) => b.id == 'ulu_kisi'), isTrue);

      // Test 4.8: aile_ocagi & yalniz_kurt
      final kAile = Karakter(bayraklar: {'evli'}, cocuklar: [
        Cocuk(ad: 'Ahmet', erkekMi: true, ebeveynYasiDogum: 20),
        Cocuk(ad: 'Ayşe', erkekMi: false, ebeveynYasiDogum: 22),
      ]);
      final bAile = await BasarimKontrolcu.kontrolEt(kAile, yuklenmisBasarimlar: tumBasarimlar);
      expect(bAile.any((b) => b.id == 'aile_ocagi'), isTrue);

      final kYalniz = Karakter(yas: 65, bayraklar: {});
      final bYalniz = await BasarimKontrolcu.kontrolEt(kYalniz, yuklenmisBasarimlar: tumBasarimlar);
      expect(bYalniz.any((b) => b.id == 'yalniz_kurt'), isTrue);

      // Test 4.9: ÖLÜM ANİ BAŞARIMLARI (ilk_nesil, uzun_omur, zengin_olum, emektar)
      final kOlum = Karakter(yas: 85, bakiye: 350);
      final bOlum = await BasarimKontrolcu.kontrolEt(
        kOlum,
        olumAnimi: true,
        gecmisHayatYaslari: [65, 70],
        yuklenmisBasarimlar: tumBasarimlar,
      );
      expect(bOlum.any((b) => b.id == 'ilk_nesil'), isTrue);
      expect(bOlum.any((b) => b.id == 'uzun_omur'), isTrue);
      expect(bOlum.any((b) => b.id == 'zengin_olum'), isTrue);
      expect(bOlum.any((b) => b.id == 'emektar'), isTrue);
    });
  });
}
