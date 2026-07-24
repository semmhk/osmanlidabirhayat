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
      final fileDuraklama = File('assets/olaylar/duraklama.json');
      final jsonDuraklama = fileDuraklama.readAsStringSync();

      final gorulenIdler = <String>{};
      final o1 = yukleyici.jsonMetnindenYukle(jsonKurulus, 'kurulus.json', gorulenIdler);
      final o2 = yukleyici.jsonMetnindenYukle(jsonYukselme, 'yukselme.json', gorulenIdler);
      final o3 = yukleyici.jsonMetnindenYukle(jsonDuraklama, 'duraklama.json', gorulenIdler);
      tumOlaylar = [...o1, ...o2, ...o3];
    });

    test('1. kurulus.json (138) + yukselme.json (101) + duraklama.json (95) = 334 olay eksiksiz, benzersiz ID ve alt_donem alanlarıyla yüklenmeli', () {
      expect(tumOlaylar.length, equals(334));
      
      // Benzersiz ID kontrolü
      final idSet = tumOlaylar.map((o) => o.id).toSet();
      expect(idSet.length, equals(334));

      final ahilikOlayi = tumOlaylar.firstWhere((o) => o.id == 'kurulus_001');
      expect(ahilikOlayi.tarihYilMin, equals(1299));
      expect(ahilikOlayi.tarihYilMax, equals(1453));

      final murad2TahtaCikisOlayi = tumOlaylar.firstWhere((o) => o.id == 'kurulus_126');
      expect(murad2TahtaCikisOlayi.altDonem, equals('murad_2'));

      // Fatih Sultan Mehmed Yükselme dönemi olayları kontrolü
      final fatihTahtaCikis = tumOlaylar.firstWhere((o) => o.id == 'fatih_001_ikinci_tahta_cikis');
      expect(fatihTahtaCikis.donem, equals('yukselme'));
      expect(fatihTahtaCikis.altDonem, equals('fatih_sultan_mehmed'));

      final sahnISeman = tumOlaylar.firstWhere((o) => o.id == 'fatih_017_sahn_i_seman');
      expect(sahnISeman.altDonem, equals('fatih_sultan_mehmed'));

      // II. Bayezid Yükselme dönemi olayları kontrolü
      final bayezid2TahtaCikis = tumOlaylar.firstWhere((o) => o.id == 'bayezid2_001_tahta_cikis_yarisi');
      expect(bayezid2TahtaCikis.donem, equals('yukselme'));
      expect(bayezid2TahtaCikis.altDonem, equals('ikinci_bayezid'));

      // Yavuz Sultan Selim Yükselme dönemi olayları kontrolü
      final caldiranSavasi = tumOlaylar.firstWhere((o) => o.id == 'selim1_003_caldiran_savasi');
      expect(caldiranSavasi.donem, equals('yukselme'));
      expect(caldiranSavasi.altDonem, equals('yavuz_selim'));

      // Kanuni I (Yükseliş) dönemi olayları kontrolü
      final mohacZaferi = tumOlaylar.firstWhere((o) => o.id == 'kanuni1_004_mohac_zaferi');
      expect(mohacZaferi.donem, equals('yukselme'));
      expect(mohacZaferi.altDonem, equals('kanuni_1_yukselis'));

      // Kanuni II (Zirve) dönemi olayları kontrolü
      final prevezeZaferi = tumOlaylar.firstWhere((o) => o.id == 'kanuni2_001_preveze_zaferi');
      expect(prevezeZaferi.donem, equals('yukselme'));
      expect(prevezeZaferi.altDonem, equals('kanuni_2_zirve'));

      final budinEyaleti = tumOlaylar.firstWhere((o) => o.id == 'kanuni2_015_budin_eyaleti');
      expect(budinEyaleti.altDonem, equals('kanuni_2_zirve'));

      // Kanuni III (Son Yıllar) dönemi olayları kontrolü
      final kanuniVefati = tumOlaylar.firstWhere((o) => o.id == 'kanuni3_012_kanuni_vefati');
      expect(kanuniVefati.donem, equals('yukselme'));
      expect(kanuniVefati.altDonem, equals('kanuni_3_son_yillar'));

      // II. Selim dönemi olayları kontrolü
      final kibrisFethi = tumOlaylar.firstWhere((o) => o.id == 'selim2_007_kibris_fethi');
      expect(kibrisFethi.donem, equals('yukselme'));
      expect(kibrisFethi.altDonem, equals('ikinci_selim'));

      // III. Murad Duraklama dönemi olayları kontrolü
      final ferhatPasa = tumOlaylar.firstWhere((o) => o.id == 'murad3_007_ferhat_pasa_antlasmasi');
      expect(ferhatPasa.donem, equals('duraklama'));
      expect(ferhatPasa.altDonem, equals('ucuncu_murad'));

      // III. Mehmed Duraklama dönemi olayları kontrolü
      final hacovaZaferi = tumOlaylar.firstWhere((o) => o.id == 'mehmed3_003_hacova_zaferi');
      expect(hacovaZaferi.donem, equals('duraklama'));
      expect(hacovaZaferi.altDonem, equals('ucuncu_mehmed'));

      // I. Ahmed Duraklama dönemi olayları kontrolü
      final sultanahmetTemel = tumOlaylar.firstWhere((o) => o.id == 'ahmed1_007_sultanahmet_camii_temel');
      expect(sultanahmetTemel.donem, equals('duraklama'));
      expect(sultanahmetTemel.altDonem, equals('birinci_ahmed'));

      // I. Mustafa & Genç Osman Duraklama dönemi olayları kontrolü
      final gencOsmanYedikule = tumOlaylar.firstWhere((o) => o.id == 'mustafa1_008_yenicheri_isyani_yedikule');
      expect(gencOsmanYedikule.donem, equals('duraklama'));
      expect(gencOsmanYedikule.altDonem, equals('mustafa1_genc_osman'));

      // IV. Murad Duraklama dönemi olayları kontrolü
      final bagdatFethi = tumOlaylar.firstWhere((o) => o.id == 'murad4_008_bagdat_fethi');
      expect(bagdatFethi.donem, equals('duraklama'));
      expect(bagdatFethi.altDonem, equals('dorduncu_murad'));

      // Sultan İbrahim Duraklama dönemi olayları kontrolü
      final giritSavasiBaslangic = tumOlaylar.firstWhere((o) => o.id == 'ibrahim1_004_girit_savasi_baslangic');
      expect(giritSavasiBaslangic.donem, equals('duraklama'));
      expect(giritSavasiBaslangic.altDonem, equals('sultan_ibrahim'));

      // IV. Mehmed I (Kaos) Duraklama dönemi olayları kontrolü
      final cinarVakasi = tumOlaylar.firstWhere((o) => o.id == 'mehmed4_1_007_cinar_vakasi');
      expect(cinarVakasi.donem, equals('duraklama'));
      expect(cinarVakasi.altDonem, equals('dorduncu_mehmed_1_kaos'));

      // IV. Mehmed II (Köprülüler) Duraklama dönemi olayları kontrolü
      final kahlenbergBozgunu = tumOlaylar.firstWhere((o) => o.id == 'mehmed4_2_013_kahlenberg_bozgunu');
      expect(kahlenbergBozgunu.donem, equals('duraklama'));
      expect(kahlenbergBozgunu.altDonem, equals('dorduncu_mehmed_2_koprululer'));
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
