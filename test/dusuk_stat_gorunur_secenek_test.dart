import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/karakter.dart';
import 'package:osmanli_da_bir_hayat/motor/olay_yukleyici.dart';
import 'package:osmanli_da_bir_hayat/motor/oyun_motoru.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('🔒 Düşük Stat & Kilitli Şık Gizleme Testleri', () {
    test('Düşük statlı bir karakter için TÜM 821 olayda EN AZ 2 ŞIK görünür olmalı (Çıkmaz Koruması)', () async {
      final yukleyici = OlayYukleyici();
      final tumOlaylar = await yukleyici.tumunuYukle();
      expect(tumOlaylar.length, equals(821));

      // Düşük statlı karakter (zeka 20, itibar 20, saglik 30, mutluluk 30, para 0)
      final dusukStatKarakter = Karakter(
        ad: 'Ahmet',
        soyad: 'Çelebi',
        yas: 25,
        dogumYili: 1400,
        zeka: 20,
        itibar: 20,
        saglik: 30,
        mutluluk: 30,
        bakiye: 0.0,
      );

      int yetersizSecenekliOlaySayisi = 0;

      for (final olay in tumOlaylar) {
        final gorunurler = OyunMotoru.gorunurSecenekleriGetir(dusukStatKarakter, olay);
        if (gorunurler.length < 2) {
          yetersizSecenekliOlaySayisi++;
        }
        expect(
          gorunurler.length,
          greaterThanOrEqualTo(2),
          reason: 'Olay [${olay.id}] için düşük statta bile en az 2 şık görünür olmalıydı!',
        );
      }

      expect(yetersizSecenekliOlaySayisi, equals(0));
    });
  });
}
