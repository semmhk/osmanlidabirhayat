import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/padisah_deposu.dart';

void main() {
  group('👑 Osmanlı Padişah Tuğraları Testleri', () {
    test('1. Tüm 5 dönemdeki padişahlar eksiksiz yüklenmeli ve 35 padişah için gerçek tuğra dosyası tanımlı olmalı', () {
      int toplamPadisahCount = 0;
      int tugrasiOlanCount = 0;
      int tugrasiOlmayanCount = 0;

      for (final donem in PadisahDeposu.donemler.values) {
        for (final p in donem.padisahlar) {
          toplamPadisahCount++;
          if (p.tugraGorsel != null) {
            tugrasiOlanCount++;
            // Dosyanın diskte var olduğunu doğrula
            final file = File(p.tugraGorsel!);
            expect(file.existsSync(), isTrue, reason: '${p.isim} için ${p.tugraGorsel} dosyası bulunamadı!');
          } else {
            tugrasiOlmayanCount++;
          }
        }
      }

      // Toplam 38 padisah/dönem kaydı (36 padişah + 1 I. Mustafa 2. dönem + 1 Fetret devri)
      expect(toplamPadisahCount, equals(38));
      expect(tugrasiOlanCount, equals(36));
      expect(tugrasiOlmayanCount, equals(2)); // Osman Gazi ve Fetret Devri
    });

    test('2. Osman Gazi ve Fetret Devri için tuğra görseli NULL olmalı (Uydurma tuğra yok)', () {
      final osmanGazi = PadisahDeposu.padisahBul(1300);
      expect(osmanGazi, isNotNull);
      expect(osmanGazi!.isim, equals('Osman Gazi'));
      expect(osmanGazi.tugraGorsel, isNull);

      final fetretDevri = PadisahDeposu.padisahBul(1405);
      expect(fetretDevri, isNotNull);
      expect(fetretDevri!.isim, contains('Fetret Devri'));
      expect(fetretDevri.tugraGorsel, isNull);
    });

    test('3. Tarihteki önemli padişahların (Orhan Gazi, Fatih, Kanuni, II. Abdülhamid) tuğra yolları doğru eşleşmeli', () {
      final orhanGazi = PadisahDeposu.padisahBul(1330);
      expect(orhanGazi?.tugraGorsel, equals('assets/tugralar/orhan.png'));

      final fatih = PadisahDeposu.padisahBul(1460);
      expect(fatih?.tugraGorsel, equals('assets/tugralar/mehmed2.png'));

      final kanuni = PadisahDeposu.padisahBul(1530);
      expect(kanuni?.tugraGorsel, equals('assets/tugralar/suleyman1.png'));

      final abdulhamid2 = PadisahDeposu.padisahBul(1890);
      expect(abdulhamid2?.tugraGorsel, equals('assets/tugralar/abdulhamid2.png'));
    });
  });
}
