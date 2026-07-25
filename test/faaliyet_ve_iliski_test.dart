import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/faaliyet.dart';
import 'package:osmanli_da_bir_hayat/modeller/karakter.dart';
import 'package:osmanli_da_bir_hayat/modeller/olay.dart';
import 'package:osmanli_da_bir_hayat/modeller/cocuk.dart';
import 'package:osmanli_da_bir_hayat/motor/oyun_motoru.dart';

void main() {
  group('🎮 Büyük Oynanış Revizyonu: Faaliyet, İlişki ve Stat Kilitleri Testleri', () {
    test('1. Stat Azalan Getiri Formülü (Diminishing Returns) Doğrulaması', () {
      expect(OyunMotoru.azalanGetiriKazanimi(30, 8), equals(8));
      expect(OyunMotoru.azalanGetiriKazanimi(55, 8), equals(3));
      expect(OyunMotoru.azalanGetiriKazanimi(80, 8), equals(1));
      expect(OyunMotoru.azalanGetiriKazanimi(92, 8), equals(0));
    });

    test('2. Yıllık 2 Faaliyet Hak Sınırı ve Yıl İlerletince Sıfırlanması', () {
      final k = Karakter(yas: 20, para: 200);
      final motor = OyunMotoru(tumOlaylar: [], karakter: k);

      final f = FaaliyetDeposu.tumFaaliyetler.firstWhere((x) => x.id == 'saglik_darussifa');

      // 1. Faaliyet
      bool ok = motor.faaliyetYurut(f);
      expect(ok, isTrue);
      expect(k.aktiviteHakki, equals(1));

      // 2. Faaliyet
      ok = motor.faaliyetYurut(f);
      expect(ok, isTrue);
      expect(k.aktiviteHakki, equals(0));

      // 3. Faaliyet (Hak bitti, başarısız olmalı)
      ok = motor.faaliyetYurut(f);
      expect(ok, isFalse);
      expect(k.aktiviteHakki, equals(0));

      // Yıl ilerlet (Haklar 2'ye resetlenmeli)
      motor.yilYasa();
      expect(k.aktiviteHakki, equals(2));
    });

    test('3. Dükkan Mülk Sert Limiti (Max 2 Dükkan) ve Net Pasif Gelir', () {
      final k = Karakter(yas: 25, para: 1000);
      final motor = OyunMotoru(tumOlaylar: [], karakter: k);

      final dukkan = FaaliyetDeposu.tumFaaliyetler.firstWhere((x) => x.id == 'mulk_dukkan');

      // 1. Dükkan
      expect(motor.faaliyetYurut(dukkan), isTrue);
      expect(k.mulkler.length, equals(1));

      k.aktiviteHakki = 2;

      // 2. Dükkan
      expect(motor.faaliyetYurut(dukkan), isTrue);
      expect(k.mulkler.length, equals(2));

      k.aktiviteHakki = 2;

      // 3. Dükkan (Sert limit 2 mülk, reddedilmeli)
      expect(motor.faaliyetYurut(dukkan), isFalse);
      expect(k.mulkler.length, equals(2));

      // Net Pasif Gelir Testi (+10 Akçe/dükkan x 2 = +20 Akçe/yıl)
      expect(k.mulkYillikNetGeliri, equals(20));
    });

    test('4. İlişki Aşınması (-1/yıl) ve Aile Sofrası (+2 Tüm Hane)', () {
      final k = Karakter(
        yas: 30,
        para: 200,
        esAdi: 'Mihrimah Hatun',
        cocuklar: [Cocuk(ad: 'Ahmet Bey', erkekMi: true, ebeveynYasiDogum: 20)],
      );

      k.iliskiler.add(Iliski(id: 'es', isim: 'Mihrimah Hatun', tip: IliskiTipi.es, yakinlikPuani: 70));
      k.iliskiler.add(Iliski(id: 'cocuk', isim: 'Ahmet Bey', tip: IliskiTipi.cocuk, yakinlikPuani: 70));

      final motor = OyunMotoru(tumOlaylar: [], karakter: k);

      // Yıl İlerlet (Aşınma -1 olmalı)
      motor.yilYasa();
      expect(k.iliskiler.firstWhere((i) => i.isim == 'Mihrimah Hatun').yakinlikPuani, equals(69));
      expect(k.iliskiler.firstWhere((i) => i.isim == 'Ahmet Bey').yakinlikPuani, equals(69));

      // Aile Sofrası Faaliyeti İcra Et (+2 Tüm Hane)
      final sofra = FaaliyetDeposu.tumFaaliyetler.firstWhere((x) => x.id == 'aile_sofrasi');
      expect(motor.faaliyetYurut(sofra), isTrue);

      expect(k.iliskiler.firstWhere((i) => i.isim == 'Mihrimah Hatun').yakinlikPuani, equals(71));
      expect(k.iliskiler.firstWhere((i) => i.isim == 'Ahmet Bey').yakinlikPuani, equals(71));
    });

    test('5. Stat Kilitli Seçenek Modeli Doğrulaması', () {
      const secenek = Secenek(
        metin: 'Sadrazamlığa Talip Ol',
        etki: Etki(),
        sonuc: 'Başarılı',
        gerekliZeka: 75,
        gerekliItibar: 80,
      );

      final kZayif = Karakter(zeka: 50, itibar: 50);
      final kGuclu = Karakter(zeka: 80, itibar: 85);

      final bool zayifYeterli = (secenek.gerekliZeka == null || kZayif.zeka >= secenek.gerekliZeka!) &&
          (secenek.gerekliItibar == null || kZayif.itibar >= secenek.gerekliItibar!);
      final bool gucluYeterli = (secenek.gerekliZeka == null || kGuclu.zeka >= secenek.gerekliZeka!) &&
          (secenek.gerekliItibar == null || kGuclu.itibar >= secenek.gerekliItibar!);

      expect(zayifYeterli, isFalse);
      expect(gucluYeterli, isTrue);
    });

    test('6. Nesil Devamı Miras Tavanı (Max 1.000 Akçe) ve Stat Bonus', () {
      final k = Karakter(
        yas: 60,
        para: 5000,
        bakiye: 5000.0,
        cocuklar: [Cocuk(ad: 'Mehmed', erkekMi: true, ebeveynYasiDogum: 30)],
      );

      k.iliskiler.add(Iliski(id: 'c1', isim: 'Mehmed', tip: IliskiTipi.cocuk, yakinlikPuani: 90, egitimPuani: 80));

      final motor = OyunMotoru(tumOlaylar: [], karakter: k);

      final yeniKarakter = motor.nesilDevamEt(k.cocuklar.first);

      // Miras 5000 Akçe x %60 = 3000 Akçe ham miras -> Sert Tavan 1000 Akçe olmalı
      expect(yeniKarakter.bakiye, equals(1000.0));

      // Stat Bonus: Zeka = 50 + (80 * 0.15) = 62, İtibar = 50 + (90 * 0.10) = 59
      expect(yeniKarakter.zeka, equals(62));
      expect(yeniKarakter.itibar, equals(59));
    });

    test('7. Geriye Dönük Uyumluluk (Eski JSON Kayıtlarında Çökme Olmamalı)', () {
      final eskiJson = {
        'ad': 'Osman',
        'soyad': 'Gazi',
        'yas': 30,
        'saglik': 80,
        'zeka': 50,
      };

      final k = Karakter.fromJson(eskiJson);

      expect(k.ad, equals('Osman'));
      expect(k.aktiviteHakki, equals(2));
      expect(k.mulkler, isEmpty);
      expect(k.iliskiler, isEmpty);
    });
  });
}
