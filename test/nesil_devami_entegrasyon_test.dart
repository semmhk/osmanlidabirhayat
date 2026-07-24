import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:osmanli_da_bir_hayat/ekranlar/olum_ekrani.dart';
import 'package:osmanli_da_bir_hayat/modeller/cocuk.dart';
import 'package:osmanli_da_bir_hayat/modeller/karakter.dart';
import 'package:osmanli_da_bir_hayat/modeller/olay.dart';
import 'package:osmanli_da_bir_hayat/motor/oyun_motoru.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Hive.init('./test_hive_cache');
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  group('📜 Nesil Devamı & Ölüm Ekranı Entegrasyon Testleri', () {
    testWidgets('Karakter vefat ettiğinde OlumEkrani görünmeli, çocuk seçildiğinde %40 miras ve temiz sayfa ile nesil devam etmeli', (WidgetTester tester) async {
      // 1. Birinci Nesil Karakter Kurulumu (1300 doğumlu, 40 yaşında -> 1340 takvim yılı)
      final baba = Karakter(
        ad: 'Ahmet',
        soyad: 'Efendi',
        yas: 40,
        dogumYili: 1300,
        nesil: 1,
        bakiye: 500.0,
        meslekZincirId: 'ahilik',
        meslekKademesi: 2,
        meslek: 'Usta Bakırcı',
        bayraklar: {'evli', 'cocuklu', 'meslek_ahilik', 'calisaniyor'},
      );

      final ogul = Cocuk(ad: 'Orhan', erkekMi: true, ebeveynYasiDogum: 20);
      baba.cocuklar.add(ogul);

      final tumOlaylar = [
        const Olay(
          id: 'test_cocukluk_olayi',
          yasMin: 5,
          yasMax: 15,
          tekSeferlik: true,
          metin: 'Eski çocukluk olayı',
          secenekler: [],
        )
      ];

      final motor = OyunMotoru(tumOlaylar: tumOlaylar, karakter: baba);

      // Karakter vefat ediyor
      baba.olu = true;
      baba.olumNedeni = 'Ecel / Doğal vefat';

      Karakter? yeniNesilKarakter;

      // 2. OlumEkrani Widget'ını Render Et
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OlumEkrani(
              karakter: motor.karakter,
              onYeniHayat: () {},
              onNesilDevamEt: (cocuk) {
                yeniNesilKarakter = motor.nesilDevamEt(cocuk);
              },
            ),
          ),
        ),
      );

      // FERMAN-I VEFAT ve SOYUNU DEVAM ETTİR butonlarının gösterildiğini kontrol et
      expect(find.text('FERMAN-I VEFAT (RUHUNA FATİHA)'), findsOneWidget);
      final soyButon = find.text('SOYUNU DEVAM ETTİR 📜');
      expect(soyButon, findsOneWidget);

      // 3. SOYUNU DEVAM ETTİR butonuna tıkla
      await tester.tap(soyButon);
      await tester.pumpAndSettle(); // Modal açılmasını bekle

      // Modal içinde çocuk "👦 Orhan Efendi" butonunu bul
      final ogulSecim = find.textContaining('Orhan Efendi');
      expect(ogulSecim, findsOneWidget);

      // Çocuğu seç
      await tester.tap(ogulSecim);
      await tester.pumpAndSettle();

      // 4. Doğrulamalar (Assertler):
      expect(yeniNesilKarakter, isNotNull);
      final yeniK = yeniNesilKarakter!;

      // a) Karakter hayatta ve 2. Nesil olmalı
      expect(yeniK.olu, isFalse);
      expect(yeniK.nesil, equals(2));
      expect(yeniK.ad, equals('Orhan'));
      expect(yeniK.soyad, equals('Efendi'));

      // b) Çocuğun yaşı 40 - 20 = 20 yaşında olmalı
      expect(yeniK.yas, equals(20));

      // c) Çocuğun doğum yılı 1300 + 20 = 1320 olmalı
      expect(yeniK.dogumYili, equals(1320));

      // d) Çocuğun takvim yılı babanın vefat yılı ile birebir aynı (1340) olmalı
      expect(yeniK.takvimYili, equals(1340));

      // e) Miras %40 hesaplanmalı: 500 Akçe * %40 = 200.0 Akçe
      expect(yeniK.bakiye, equals(200.0));

      // f) Meslek ve bayraklar sıfırlanmış olmalı (Temiz sayfa)
      expect(yeniK.meslekZincirId, isNull);
      expect(yeniK.meslek, equals('Vasıfsız İşçi'));
      expect(yeniK.bayraklar.contains('evli'), isFalse);
      expect(yeniK.bayraklar.contains('meslek_ahilik'), isFalse);

      // g) Yaşının altındaki (5-15 yaş) tek seferlik olaylar egzoz edilmiş olmalı
      expect(yeniK.kullanilanOlaylar.contains('test_cocukluk_olayi'), isTrue);

      // h) Dönemsel ölüm riski 1340 yılı için doğru hesaplanmalı (70 yaşında: 0.20 * 1.30 = 0.26)
      yeniK.yas = 70;
      final olumRiski70 = OyunMotoru.toplamOlumRiskiHesapla(yeniK);
      expect(olumRiski70, closeTo(0.26, 0.01));
    });
  });
}
