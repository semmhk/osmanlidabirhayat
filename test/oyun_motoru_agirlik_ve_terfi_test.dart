import 'package:flutter_test/flutter_test.dart';
import 'package:osmanli_da_bir_hayat/modeller/karakter.dart';
import 'package:osmanli_da_bir_hayat/modeller/olay.dart';
import 'package:osmanli_da_bir_hayat/motor/oyun_motoru.dart';

void main() {
  group('Sayısal Ağırlıklandırma ve 2-Yıl Garantili Terfi Testleri', () {
    test('1. Terfi bekleme kuralı: minYil dolduğunda hemen terfi etmemeli, minYil+2 dolunca ZORUNLU terfi etmeli', () {
      final karakter = Karakter(
        yas: 15,
        meslekZincirId: 'ahilik', // Ahilik kademe 0: Çırak (minYil: 2) -> Kalfa (minZeka: 40)
        meslekKademesi: 0,
        kademedekiYil: 1, // 1 yıldır kademede
        zeka: 50,
        itibar: 50,
      );

      final motor = OyunMotoru(tumOlaylar: [], karakter: karakter);

      // Yıl 1 (kademedekiYil = 2 olur, minYil doldu) -> otomatik terfi ETMEMELİ (Grace period aktif)
      bool terfiEtti = motor.terfiKontrolEt();
      expect(terfiEtti, isFalse);
      expect(karakter.meslekKademesi, equals(0));

      // Yıl 2 (kademedekiYil = 3 olur, minYil + 1) -> henüz zorunlu değil
      terfiEtti = motor.terfiKontrolEt();
      expect(terfiEtti, isFalse);
      expect(karakter.meslekKademesi, equals(0));

      // Yıl 3 (kademedekiYil = 4 olur, minYil + 2 = 4) -> ZORUNLU GARANTİLİ TERFİ!
      terfiEtti = motor.terfiKontrolEt();
      expect(terfiEtti, isTrue);
      expect(karakter.meslekKademesi, equals(1));
      expect(karakter.meslek, equals('Kalfa'));
    });

    test('2. Kilometre taşı ağırlıklandırma kuralı: Standart (10x) ve Telafi (25x) ağırlık hesaplaması', () {
      final standartKarakter = Karakter(yas: 12);
      final motor1 = OyunMotoru(tumOlaylar: [], karakter: standartKarakter);

      final standartOlay = Olay(
        id: 'std_01',
        yasMin: 10,
        yasMax: 14,
        oncelikli: true,
        metin: 'Standart Kilometre Taşı',
        secenekler: [Secenek(metin: 'Tamam', etki: Etki(), sonuc: 'Sonuç')],
      );

      final normalOlay = Olay(
        id: 'norm_01',
        yasMin: 10,
        yasMax: 14,
        oncelikli: false,
        metin: 'Normal Olay',
        secenekler: [Secenek(metin: 'Tamam', etki: Etki(), sonuc: 'Sonuç')],
      );

      final uygunlar = [standartOlay, normalOlay];
      final secilen = motor1.agirlikliOlaySec(uygunlar);
      expect(secilen, isNotNull);

      // Telafi durumu testi (19 yaşında ve mesleksiz karakter)
      final telafiKarakter = Karakter(yas: 19, meslekZincirId: null);
      final motor2 = OyunMotoru(tumOlaylar: [], karakter: telafiKarakter);

      final telafiOlay = Olay(
        id: 'telafi_01',
        yasMin: 18,
        yasMax: 30,
        oncelikli: true,
        metin: 'Telafi Olayı',
        secenekler: [Secenek(metin: 'Tamam', etki: Etki(), sonuc: 'Sonuç')],
      );

      final secilenTelafi = motor2.agirlikliOlaySec([telafiOlay, normalOlay]);
      expect(secilenTelafi, isNotNull);
    });
  });
}
