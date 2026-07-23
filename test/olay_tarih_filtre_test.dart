import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/karakter.dart';
import 'package:osmanli_da_bir_hayat/modeller/olay.dart';
import 'package:osmanli_da_bir_hayat/motor/olay_yukleyici.dart';
import 'package:osmanli_da_bir_hayat/motor/oyun_motoru.dart';

void main() {
  group('Osmanlı Takvim Yılı ve Olay Filtreleme Testleri', () {
    late OlayYukleyici yukleyici;
    late List<Olay> tumOlaylar;

    setUp(() {
      yukleyici = OlayYukleyici();
      final fileKurulus = File('assets/olaylar/kurulus.json');
      final jsonKurulus = fileKurulus.readAsStringSync();
      final fileYukselme = File('assets/olaylar/yukselme.json');
      final jsonYukselme = fileYukselme.readAsStringSync();

      final gorulenIdler = <String>{};
      final o1 = yukleyici.jsonMetnindenYukle(jsonKurulus, 'kurulus.json', gorulenIdler);
      final o2 = yukleyici.jsonMetnindenYukle(jsonYukselme, 'yukselme.json', gorulenIdler);
      tumOlaylar = [...o1, ...o2];
    });

    test('1. kurulus.json (138) + yukselme.json (16) = 154 olay eksiksiz, benzersiz ID ve alt_donem alanlarıyla yüklenmeli', () {
      expect(tumOlaylar.length, equals(154));
      
      // Benzersiz ID kontrolü
      final idSet = tumOlaylar.map((o) => o.id).toSet();
      expect(idSet.length, equals(154));

      final ahilikOlayi = tumOlaylar.firstWhere((o) => o.id == 'kurulus_001');
      expect(ahilikOlayi.tarihYilMin, equals(1299));
      expect(ahilikOlayi.tarihYilMax, equals(1453));

      final murad2TahtaCikisOlayi = tumOlaylar.firstWhere((o) => o.id == 'kurulus_126');
      expect(murad2TahtaCikisOlayi.altDonem, equals('murad_2'));

      // Fatih Sultan Mehmed Yükselme dönemi olayları kontrolü
      final fatihTahtaCikis = tumOlaylar.firstWhere((o) => o.id == 'fatih_001_ikinci_tahta_cikis');
      expect(fatihTahtaCikis.donem, equals('yukselme'));
      expect(fatihTahtaCikis.altDonem, equals('fatih_sultan_mehmed'));

      final fatihVefat = tumOlaylar.firstWhere((o) => o.id == 'fatih_016_fatih_vefati');
      expect(fatihVefat.donem, equals('yukselme'));
      expect(fatihVefat.altDonem, equals('fatih_sultan_mehmed'));
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
        tumOlaylar: tumOlaylar,
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
        tumOlaylar: tumOlaylar,
        karakter: karakter,
      );

      final uygunlar = motor.uygunOlaylariGetir();
      final uygunIdler = uygunlar.map((o) => o.id).toList();

      expect(uygunIdler, contains('kurulus_015'));
    });
  });
}
