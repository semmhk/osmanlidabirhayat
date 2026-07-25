import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:osmanli_da_bir_hayat/ekranlar/ana_menu_ekrani.dart';
import 'package:osmanli_da_bir_hayat/ekranlar/basarimlar_ekrani.dart';
import 'package:osmanli_da_bir_hayat/ekranlar/gecmis_hayatlar_ekrani.dart';
import 'package:osmanli_da_bir_hayat/modeller/hayat_kaydi.dart';
import 'package:osmanli_da_bir_hayat/modeller/karakter.dart';
import 'package:osmanli_da_bir_hayat/motor/oyun_motoru.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    Hive.init('./test_hive_cache');
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  group('🏛️ Navigasyon ve Geçmiş Hayatlar (Şecere) Testleri', () {
    test('1. HayatKaydi modeli Karakter nesnesinden doğru oluşturulmalı ve serileşmeli', () {
      final k = Karakter(
        ad: 'Orhan',
        soyad: 'Bey',
        cinsiyet: Cinsiyet.erkek,
        dogumYili: 1350,
        yas: 62,
        saglik: 0,
        mutluluk: 50,
        zeka: 50,
        itibar: 50,
        bakiye: 3500.0,
        olu: true,
        meslek: 'Hekim',
      );
      k.kazanilanBasarimlar.add('ilk_adim');

      final kayit = HayatKaydi.karakterden(k, olumNedeniOverride: 'Yaşlılık');
      expect(kayit.isim, equals(k.isim));
      expect(kayit.unvan, equals('Hekim'));
      expect(kayit.bakiye, equals(3500.0));
      expect(kayit.olumNedeni, equals('Yaşlılık'));

      final jsonStr = kayit.toJson();
      final decoded = HayatKaydi.fromJson(jsonStr);
      expect(decoded.isim, equals(kayit.isim));
      expect(decoded.bakiye, equals(3500.0));
    });

    testWidgets('2. AnaMenuEkrani render edilmeli ve menü butonları görünmeli', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AnaMenuEkrani(),
        ),
      );

      expect(find.text("OSMANLI'DA BİR HAYAT"), findsOneWidget);
      expect(find.text('YENİ HAYAT BAŞLAT'), findsOneWidget);
      expect(find.text('GEÇMİŞ HAYATLAR (ŞECERE)'), findsOneWidget);
      expect(find.text('NİŞAN VE BAŞARIMLAR'), findsOneWidget);
    });

    testWidgets('3. GecmisHayatlarEkrani render edilmeli', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: GecmisHayatlarEkrani(),
        ),
      );

      expect(find.text('GEÇMİŞ HAYATLAR (ŞECERE)'), findsOneWidget);
    });

    testWidgets('4. BasarimlarEkrani render edilmeli', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: BasarimlarEkrani(),
        ),
      );

      expect(find.text('NİŞAN VE BAŞARIMLAR'), findsOneWidget);
    });

    test('5. 1922 yılına ulaşıldığında karakterin hikayesi tamamlanmalı ve olumNedeni 1922 olarak kaydedilmeli', () {
      final k = Karakter(
        ad: 'Mehmed',
        soyad: 'Efendi',
        dogumYili: 1860,
        yas: 62, // 1860 + 62 = 1922
        saglik: 80,
      );
      final motor = OyunMotoru(tumOlaylar: [], karakter: k);

      final devamEdebilir = motor.yilYasa();
      expect(devamEdebilir, isFalse);
      expect(k.hikayesiTamamlandi, isTrue);
      expect(k.olu, isTrue);
      expect(k.olumNedeni, contains('1922'));
      final kayit = HayatKaydi.karakterden(k);
      expect(kayit.hikayesiTamamlandi, isTrue);
      expect(motor.nesilDevamEdebilirMi(), isFalse);
    });
  });
}
