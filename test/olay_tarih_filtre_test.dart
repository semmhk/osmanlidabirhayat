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

    test('1. kurulus.json 15 olay eksiksiz ve tarih_yil_min/max alanlarıyla yüklenmeli', () {
      expect(kurulusOlaylari.length, equals(15));
      
      final ahilikOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_01_ahilik_giris');
      expect(ahilikOlayi.tarihYilMin, equals(1299));
      expect(ahilikOlayi.tarihYilMax, equals(1453));

      final vebaOlayi = kurulusOlaylari.firstWhere((o) => o.id == 'kurulus_13_salgin_veba');
      expect(vebaOlayi.tarihYilMin, equals(1348));
      expect(vebaOlayi.tarihYilMax, equals(1352));
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
      // - kurulus_13_salgin_veba (tarih: 1348-1352, yas: 1-80) HAVUZA GİRMELİ!
      expect(uygunIdler, contains('kurulus_13_salgin_veba'));

      // - kurulus_03_osman_gazi_gaza (tarih: 1299-1326) HAVUZA GİRMEMELİ! (1350 > 1326)
      expect(uygunIdler, isNot(contains('kurulus_03_osman_gazi_gaza')));

      // - kurulus_15_istanbul_kusatmasi_hazirligi (tarih: 1451-1453) HAVUZA GİRMEMELİ! (1350 < 1451)
      expect(uygunIdler, isNot(contains('kurulus_15_istanbul_kusatmasi_hazirligi')));
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

      expect(uygunIdler, contains('kurulus_15_istanbul_kusatmasi_hazirligi'));
    });
  });
}
