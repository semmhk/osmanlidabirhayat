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

    test('2. Öncelik ve Gündelik Ağırlıklandırması (oncelikli:true 8x, gundelik_ 1x, tarihi 8x)', () {
      final karakter = Karakter(yas: 20, dogumYili: 1300);

      final oncelikliGundelik = Olay(
        id: 'gundelik_evlilik_01',
        yasMin: 18,
        yasMax: 30,
        oncelikli: true,
        metin: 'Oncelikli Gündelik (Kilometre Taşı Evlilik)',
        secenekler: [Secenek(metin: 'Tamam', etki: Etki(), sonuc: 'Sonuç')],
      );

      final atmosfeicGundelik = Olay(
        id: 'gundelik_kahve_01',
        yasMin: 18,
        yasMax: 30,
        oncelikli: false,
        metin: 'Atmosferik Gündelik Sohbet',
        secenekler: [Secenek(metin: 'Tamam', etki: Etki(), sonuc: 'Sonuç')],
      );

      final tarihiOlay = Olay(
        id: 'kurulus_001',
        yasMin: 18,
        yasMax: 30,
        oncelikli: false,
        metin: 'Bursa Kuşatması Tarihi Olay',
        secenekler: [Secenek(metin: 'Tamam', etki: Etki(), sonuc: 'Sonuç')],
      );

      final motor = OyunMotoru(
        tumOlaylar: [oncelikliGundelik, atmosfeicGundelik, tarihiOlay],
        karakter: karakter,
      );

      final uygunlar = motor.uygunOlaylariGetir();
      expect(uygunlar.length, equals(3));

      // 1000 kez simüle ederek ağırlık oranlarını test et
      int oncelikliSayisi = 0;
      int gundelikSayisi = 0;
      int tarihiSayisi = 0;

      for (int i = 0; i < 1000; i++) {
        final secilen = motor.agirlikliOlaySec(uygunlar);
        if (secilen?.id == 'gundelik_evlilik_01') oncelikliSayisi++;
        if (secilen?.id == 'gundelik_kahve_01') gundelikSayisi++;
        if (secilen?.id == 'kurulus_001') tarihiSayisi++;
      }

      // oncelikliGundelik (8x) ve tarihiOlay (8x) gündelik sohbetten (1x) çok daha sık seçilmeli
      expect(oncelikliSayisi, greaterThan(gundelikSayisi * 3));
      expect(tarihiSayisi, greaterThan(gundelikSayisi * 3));
    });

    test('3. 8-Yıllık Cooldown Mantığı (Tekrarlanabilir olaylar 8 yıl geçmeden aday olamaz)', () {
      final karakter = Karakter(yas: 20, dogumYili: 1300);

      final tekrarOlay = Olay(
        id: 'gundelik_pazar_01',
        yasMin: 18,
        yasMax: 30,
        tekSeferlik: false,
        metin: 'Pazar Gezintisi',
        secenekler: [Secenek(metin: 'Tamam', etki: Etki(), sonuc: 'Sonuç')],
      );

      final motor = OyunMotoru(
        tumOlaylar: [tekrarOlay],
        karakter: karakter,
      );

      // 1. İlk yıl olay tetiklenir ve olaySonGorulmeYili haritasına kaydedilir
      final ilkSecim = motor.agirlikliOlaySec(motor.uygunOlaylariGetir());
      expect(ilkSecim?.id, equals('gundelik_pazar_01'));
      expect(karakter.olaySonGorulmeYili['gundelik_pazar_01'], equals(1320));

      // 2. Takip eden 7 yıl içinde (1321-1327) olay cooldown'dadır ve uygunOlaylariGetir() listesinden ELENİR!
      for (int i = 1; i <= 7; i++) {
        karakter.yas = 20 + i; // 1321 ... 1327
        final adaylar = motor.uygunOlaylariGetir();
        expect(adaylar.contains(tekrarOlay), isFalse, reason: '$i. yılda cooldown ihlal edildi');
      }

      // 3. 8. yılda (1328) cooldown biter ve olay tekrar aday havuzuna girer!
      karakter.yas = 28; // 1328
      final adaylar8 = motor.uygunOlaylariGetir();
      expect(adaylar8.contains(tekrarOlay), isTrue);
    });
  });
}
