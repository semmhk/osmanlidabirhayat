import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/padisah_deposu.dart';

void main() {
  group('👑 Osmanlı Padişah Portreleri Testleri', () {
    test('1. Tüm 5 dönemdeki padişahlar eksiksiz yüklenmeli ve 37 padişah için portre dosyası tanımlı olmalı', () {
      int toplamPadisahCount = 0;
      int portresiOlanCount = 0;
      int portresiOlmayanCount = 0;

      for (final donem in PadisahDeposu.donemler.values) {
        for (final p in donem.padisahlar) {
          toplamPadisahCount++;
          if (p.portreGorsel != null) {
            portresiOlanCount++;
            // Dosyanın diskte var olduğunu doğrula
            final file = File(p.portreGorsel!);
            expect(file.existsSync(), isTrue, reason: '${p.isim} için ${p.portreGorsel} dosyası bulunamadı!');
          } else {
            portresiOlmayanCount++;
          }
        }
      }

      // Toplam 38 padisah/dönem kaydı (37 padişah kaydı + 1 Fetret devri)
      expect(toplamPadisahCount, equals(38));
      expect(portresiOlanCount, equals(37));
      expect(portresiOlmayanCount, equals(1)); // Fetret Devri portresizdir
    });

    test('2. Fetret Devri için portre görseli NULL olmalı (Tek bir hükümdar yok)', () {
      final fetretDevri = PadisahDeposu.padisahBul(1405);
      expect(fetretDevri, isNotNull);
      expect(fetretDevri!.isim, contains('Fetret Devri'));
      expect(fetretDevri.portreGorsel, isNull);
    });

    test('3. Tarihteki padişahların (Osman Gazi, I. Murad, Yıldırım Bayezid, Fatih, Kanuni, II. Abdülhamid) portre yolları doğru eşleşmeli', () {
      final osmanGazi = PadisahDeposu.padisahBul(1300);
      expect(osmanGazi?.portreGorsel, equals('assets/padisahlar/osman_gazi.jpg'));

      final murad1 = PadisahDeposu.padisahBul(1370);
      expect(murad1?.portreGorsel, equals('assets/padisahlar/murad1.jpg'));

      final yildirim = PadisahDeposu.padisahBul(1395);
      expect(yildirim?.portreGorsel, equals('assets/padisahlar/bayezid1.jpg'));

      final fatih = PadisahDeposu.padisahBul(1460);
      expect(fatih?.portreGorsel, equals('assets/padisahlar/fatih_mehmed.jpg'));

      final kanuni = PadisahDeposu.padisahBul(1530);
      expect(kanuni?.portreGorsel, equals('assets/padisahlar/kanuni_suleyman.jpg'));

      final abdulhamid2 = PadisahDeposu.padisahBul(1890);
      expect(abdulhamid2?.portreGorsel, equals('assets/padisahlar/abdulhamid2.jpg'));
    });
  });
}
