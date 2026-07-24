import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/padisah_deposu.dart';
import 'package:osmanli_da_bir_hayat/servisler/ses_servisi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('🎶 SesServisi & Dönemsel Müzik Haritalama Testleri', () {
    test('1. SesServisi tüm 5 Osmanlı dönemi için tanımlı müzik yollarına sahip olmalı', () {
      const donemler = ['kurulus', 'yukselme', 'duraklama', 'gerileme', 'dagilma'];

      for (final donemId in donemler) {
        final muzikYolu = SesServisi.donemMuzikleri[donemId];
        expect(muzikYolu, isNotNull, reason: '$donemId dönemi için müzik yolu bulunamadı!');
        expect(muzikYolu, startsWith('muzikler/'));
      }
    });

    test('2. Farklı takvim yıllarındaki padişah dönemleri SesServisi müzik haritasıyla eşleşmeli', () {
      // 1350 Kuruluş dönemi
      final donem1350 = PadisahDeposu.donemBul(1350);
      expect(donem1350?.id, equals('kurulus'));
      expect(SesServisi.donemMuzikleri[donem1350!.id], equals('muzikler/kurulus.wav'));

      // 1500 Yükselme dönemi
      final donem1500 = PadisahDeposu.donemBul(1500);
      expect(donem1500?.id, equals('yukselme'));
      expect(SesServisi.donemMuzikleri[donem1500!.id], equals('muzikler/yukselme.wav'));

      // 1620 Duraklama dönemi
      final donem1620 = PadisahDeposu.donemBul(1620);
      expect(donem1620?.id, equals('duraklama'));
      expect(SesServisi.donemMuzikleri[donem1620!.id], equals('muzikler/duraklama.ogg'));

      // 1750 Gerileme dönemi
      final donem1750 = PadisahDeposu.donemBul(1750);
      expect(donem1750?.id, equals('gerileme'));
      expect(SesServisi.donemMuzikleri[donem1750!.id], equals('muzikler/gerileme.wav'));

      // 1900 Dağılma dönemi
      final donem1900 = PadisahDeposu.donemBul(1900);
      expect(donem1900?.id, equals('dagilma'));
      expect(SesServisi.donemMuzikleri[donem1900!.id], equals('muzikler/dagilma.ogg'));
    });

    test('3. SesServisi tekil (singleton) yapısı ve mute/unmute durumu doğru çalışmalı', () {
      final s1 = SesServisi();
      final s2 = SesServisi();
      expect(s1, equals(s2));

      expect(s1.sesAcik, isTrue);
      s1.sesDurumunuDegistir();
      expect(s1.sesAcik, isFalse);
      s1.sesDurumunuDegistir();
      expect(s1.sesAcik, isTrue);
    });

    test('4. assets/muzikler/CREDITS.md belgesi diskte var olmalı ve tüm dönemleri içermeli', () {
      final creditsFile = File('assets/muzikler/CREDITS.md');
      expect(creditsFile.existsSync(), isTrue);

      final content = creditsFile.readAsStringSync();
      expect(content, contains('Kuruluş'));
      expect(content, contains('Yükselme'));
      expect(content, contains('Duraklama'));
      expect(content, contains('Gerileme'));
      expect(content, contains('Dağılma'));
      expect(content, contains('Donizetti'));
    });
  });
}
