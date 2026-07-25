import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/padisah_deposu.dart';

void main() {
  group('👑 Osmanlı Padişah Portreleri %100 Benzersizlik Testleri', () {
    test('1. Tüm 38 padişah/dönem kaydı için (Fetret Devri ve I. Mustafa 2. dönem hariç) %100 BENZERSİZ portre dosyaları tanımlı olmalı', () {
      final benzersizGorseller = <String>{};
      int toplamPadisahCount = 0;
      int portresiOlanCount = 0;

      for (final donem in PadisahDeposu.donemler.values) {
        for (final p in donem.padisahlar) {
          toplamPadisahCount++;
          if (p.portreGorsel != null) {
            portresiOlanCount++;
            // I. Mustafa 2. dönem aynı kişi olduğu için set kontrolü dışında tutulabilir
            if (p.id != 'mustafa1_2') {
              expect(benzersizGorseller.contains(p.portreGorsel), isFalse,
                  reason: 'TEKRAR EDEN PORTRE TESPİT EDİLDİ! ${p.isim} için ${p.portreGorsel} zaten başka bir padişaha atanmış!');
              benzersizGorseller.add(p.portreGorsel!);
            }
            // Dosyanın diskte var olduğunu doğrula
            final file = File(p.portreGorsel!);
            expect(file.existsSync(), isTrue, reason: '${p.isim} için ${p.portreGorsel} dosyası bulunamadı!');
          }
        }
      }

      expect(toplamPadisahCount, equals(38));
      expect(portresiOlanCount, equals(37));
      // 36 benzersiz görsel (35 hükümdar için %100 ayrı görsel dosyaları)
      expect(benzersizGorseller.length, equals(36));
    });

    test('2. Fetret Devri için portre görseli NULL olmalı (Tek bir hükümdar yok)', () {
      final fetretDevri = PadisahDeposu.padisahBul(1405);
      expect(fetretDevri, isNotNull);
      expect(fetretDevri!.isim, contains('Fetret Devri'));
      expect(fetretDevri.portreGorsel, isNull);
    });
  });
}
