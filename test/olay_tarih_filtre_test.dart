import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/karakter.dart';
import 'package:osmanli_da_bir_hayat/modeller/olay.dart';
import 'package:osmanli_da_bir_hayat/motor/olay_yukleyici.dart';
import 'package:osmanli_da_bir_hayat/motor/oyun_motoru.dart';

void main() {
  group('Osmanlı Takvim Yılı ve Olay Filtreleme Testleri', () {
    late OlayYukleyici yukleyici;
    late List<Olay> kurulusOlaylari;

    setUp(() {
      yukleyici = OlayYukleyici();
      final file = File('assets/olaylar/kurulus.json');
      final jsonString = file.readAsStringSync();
      kurulusOlaylari = yukleyici.jsonMetnindenYukle(jsonString, 'kurulus.json');
    });

    test('1. kurulus.json 57 olay eksiksiz, benzersiz ID, alt_donem ve tarih_yil_min/max alanlarıyla yüklenmeli', () {
      expect(kurulusOlaylari.length, equals(57));
      
      // Benzersiz ID kontrolü
      final idSet = kurulusOlaylari.map((o) => o.id).toSet();
      expect(idSet.length, equals(57));

      final ahilikOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_001');
      expect(ahilikOlayi.tarihYilMin, equals(1299));
      expect(ahilikOlayi.tarihYilMax, equals(1453));

      final rumeliOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_006');
      expect(rumeliOlayi.tarihYilMin, equals(1352));
      expect(rumeliOlayi.tarihYilMax, equals(1357));

      final vebaOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_013');
      expect(vebaOlayi.tarihYilMin, equals(1348));
      expect(vebaOlayi.tarihYilMax, equals(1352));

      final gaziOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_040');
      expect(gaziOlayi.gerekliBayrak, equals('meslek_seyfiye'));

      // alt_donem kontrolü
      final osmanGaziOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_041');
      expect(osmanGaziOlayi.altDonem, equals('osman_gazi'));

      final ilkHutbeOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_056');
      expect(ilkHutbeOlayi.altDonem, equals('osman_gazi'));
    });

    test('2. Şema doğrulayıcı hatalı tarih_yil_min > tarih_yil_max durumunu yakalamalı', () {
      final hataliJson = [
        {
          "id": "hatali_tarih_olayi",
          "yas_min": 10,
          "yas_max": 20,
          "tarih_yil_min": 1400,
          "tarih_yil_max": 1300, // Min > Max Hatalı!
          "metin": "Test metni",
          "secenekler": [
            {"metin": "Evet", "sonuc": "Tamam"}
          ]
        }
      ];

      final yuklenen = yukleyici.jsonMetnindenYukle(
        List<dynamic>.from(hataliJson).toString(),
        'test.json',
      );
      expect(yuklenen, isEmpty);

      final hata = yukleyici.dogrulaOlaySemasi(hataliJson.first, {});
      expect(hata, contains('değerinden büyük olamaz'));
    });

    test('3. Karakterin takvim yılına göre tarih filtrelemesi doğru çalışmalı', () {
      // 1340 yılında doğan bir karakter
      final karakter = Karakter(
        dogumYili: 1340,
        yas: 10, // takvimYili = 1350
        saglik: 80,
      );

      final motor = OyunMotoru(
        tumOlaylar: kurulusOlaylari,
        karakter: karakter,
      );

      final uygunlar = motor.uygunOlaylariGetir();
      final uygunIdler = uygunlar.map((o) => o.id).toList();

      // 1350 yılında (takvimYili = 1350, yas = 10):
      // - kurulus_013 (tarih: 1348-1352, yas: 1-80) HAVUZA GİRMELİ!
      expect(uygunIdler, contains('kurulus_013'));

      // - kurulus_003 (tarih: 1299-1326) HAVUZA GİRMEMELİ! (1350 > 1326)
      expect(uygunIdler, isNot(contains('kurulus_003')));

      // - kurulus_015 (tarih: 1451-1453) HAVUZA GİRMEMELİ! (1350 < 1451)
      expect(uygunIdler, isNot(contains('kurulus_015')));
    });

    test('4. 1452 yılındaki bir karakter İstanbul Kuşatması olayını görebilmeli', () {
      final karakter = Karakter(
        dogumYili: 1430,
        yas: 22, // takvimYili = 1452
        saglik: 80,
      );

      final motor = OyunMotoru(
        tumOlaylar: kurulusOlaylari,
        karakter: karakter,
      );

      final uygunlar = motor.uygunOlaylariGetir();
      final uygunIdler = uygunlar.map((o) => o.id).toList();

      expect(uygunIdler, contains('kurulus_015'));
    });
  });
}
