import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/karakter.dart';

void main() {
  group('AvatarGenleri Geriye Dönük Uyumluluk ve Rastgele Gen Testleri', () {
    test('1. AvatarGenleri.fromJson eski/eksik JSON yapılarında varsayılan değerlerle çökmeksizin yüklenmeli', () {
      final eskiJson = <String, dynamic>{
        'tenTonu': 'bugday',
        'sacRengi': 'siyah',
        'sacStili': 'kisa',
        'yuzSekli': 'oval',
        'gozlukVar': false,
        'biyikSakalVar': true,
        'cinsiyet': 'erkek',
        // gozRengi, biyikSakalStili, basGiyimi eksik (eski kayit)
      };

      final genler = AvatarGenleri.fromJson(eskiJson);
      expect(genler.tenTonu, equals(TenTonu.bugday));
      expect(genler.gozRengi, equals(GozRengi.kahverengi));
      expect(genler.biyikSakalStili, equals(BiyikSakalStili.palaBiyik));
      expect(genler.basGiyimi, equals(BasGiyimi.fes));
    });

    test('2. AvatarGenleri.rastgele cinsiyete uygun baş giyimi ve gen üretmeli', () {
      final erkekGenler = AvatarGenleri.rastgele(null, Cinsiyet.erkek);
      expect(erkekGenler.cinsiyet, equals(Cinsiyet.erkek));
      expect(erkekGenler.basGiyimi, isNot(equals(BasGiyimi.yasmakHotoz)));

      final kadinGenler = AvatarGenleri.rastgele(null, Cinsiyet.kadin);
      expect(kadinGenler.cinsiyet, equals(Cinsiyet.kadin));
      expect(kadinGenler.basGiyimi, equals(BasGiyimi.yasmakHotoz));
    });
  });
}
