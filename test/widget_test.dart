import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/padisah_deposu.dart';

void main() {
  test('PadisahDeposu donem ve padisah bulma testleri', () {
    final donem = PadisahDeposu.donemBul(1300);
    expect(donem, isNotNull);
    expect(donem!.id, equals('kurulus'));

    final padisah = PadisahDeposu.padisahBul(1300);
    expect(padisah, isNotNull);
    expect(padisah!.isim, equals('Osman Gazi'));

    final fetret = PadisahDeposu.padisahBul(1405);
    expect(fetret, isNotNull);
    expect(fetret!.isim, contains('Fetret'));
  });
}
