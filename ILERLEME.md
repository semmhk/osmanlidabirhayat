# OSMANLI'DA BİR HAYAT — ILERLEME.md

> Her oturum sonunda güncellenir. Format: tarih + biten işler + kalan işler + bilinen sorunlar.

## MEVCUT DURUM

**Aktif Faz:** Adım 1 & Adım 4 (Proje İskeleti + 76 Olaylık Kuruluş Dönemi & Orhan Gazi Alt-Dönemi + 14 Başarım Sistemi + Kalemiye & Boşanma Zincirleri + Birim Testleri + GitHub Entegrasyonu) ✅
**Son güncelleme:** 23 Temmuz 2026

---

## TAMAMLANANLAR

### Ön Hazırlık & Mimarı Tasarım (23 Temmuz 2026)
- [x] Mevcut "Türkiye'de Bir Hayat" projesi incelendi ve motor mimarisi uyarlandı (`C:\Users\STUDYO\Desktop\turkiyede_bir_hayat`).
- [x] Takvim yılı sistemi mimarisi kuruldu (`dogumYili` 1299-1900, `takvimYili`, `PadisahDeposu`).
- [x] Osmanlı meslek zincirleri tasarlandı (`ahilik`, `ilmiye`, `seyfiye`, `kalemiye` — 1.0x-8.0x dengeli çarpanlar).
- [x] Tarihsel ölüm riski formülü ve öncelikli/kilometre taşı olay seçimi kuralları netleştirildi (2 yıl bekleme sonrası garantili terfi kuralı).
- [x] Soyut "Akçe" ekonomi birimi modeli uygulandı.
- [x] Koyu sepya, ferman/parşömen ve Tuğra mührü görsel tema iskeleti oluşturuldu.

### Adım 1 & Adım 4 — Proje Kurulumu, Motor Entegrasyonu ve Kuruluş Dönemi Olayları (TAMAMLANDI ✅)
- [x] Flutter projesi oluşturuldu (`osmanli_da_bir_hayat`).
- [x] `pubspec.yaml` bağımlılıkları ve asset tanımları yapılandırıldı (`assets/basarimlar.json` dahil).
- [x] `Karakter` modeli `dogumYili`, `takvimYili`, `Akçe` para sistemi, `zirveZeka`, `zirveItibar`, `hicVasifsizIsciOldu` ve `cocukSayisi` alanları eklenerek yazıldı (`lib/modeller/karakter.dart`).
- [x] `Olay` ve `Secenek` modellerine `tarih_yil_min` ve `tarih_yil_max` alanları ile birlikte **`alt_donem`** (opsiyonel padişah alt-donem etiketi) eklendi (`lib/modeller/olay.dart`).
- [x] `PadisahDeposu` ve `Donem` depoları Kuruluş dönemi (1299-1453) doğrulanmış padişah listesiyle yazıldı (`lib/modeller/padisah_deposu.dart`).
- [x] Osmanlı meslek depoları yazıldı (`lib/modeller/meslek.dart`).
- [x] `OlayYukleyici` tarih yılı min/max ve `alt_donem` şema doğrulayıcısı ile yazıldı (`lib/motor/olay_yukleyici.dart`).
- [x] `OyunMotoru` takvim yılı ilerletme, tarihsel ölüm riski, `agirlikliOlaySec` (10x-25x), statik `secenekUygula` ve 2 yıl toleranslı garantili terfi kuralı ile yazıldı (`lib/motor/oyun_motoru.dart`).
- [x] **Sistem boşlukları kapatıldı: kalemiye, 14 başarım, boşanma/nesil içeriği**:
  - **14 Osmanlı-uyumlu Başarım sistemi** eklendi (`assets/basarimlar.json`, `lib/modeller/basarim.dart`, `lib/motor/basarim_kontrolcusu.dart`). İndeks bazlı en üst kademe meslek kontrolleri (`lonca_ustabasi`, `divan_efendisi`, `kadiasker`, `serdar_aga`), `sifirdan_zirveye`, `ikinci_bahar`, `ahalinin_gururu`, `ulu_kisi`, `aile_ocagi`, `yalniz_kurt`, `zengin_olum`, `emektar`, `uzun_omur`, `ilk_nesil` doğrulandı.
  - **Kalemiye Meslek Zinciri**: Divan kâtipliği olayı eklendi (`kurulus_073`, `meslekAtama: "kalemiye"`).
  - **Boşanma / Eşin Vefatı / İkinci Nikah Zinciri**: 3 olay eklendi (`kurulus_074`, `kurulus_075`, `kurulus_076` — `dul_bosanmis` -> `ikinci_evlilik` uçtan uca).
  - **UI Ekranları**: `BasarimlarEkrani` ve `OlumEkrani` ("Yeni Başarım" bildirimi ve Ferman-ı Vefat özeti) oluşturuldu (`lib/ekranlar/`).
- [x] **Kuruluş dönemi: 76 olay TAMAMLANDI** (`assets/olaylar/kurulus.json` - 76 benzersiz ID'li, tarih ve yaş filtreli olay).
- [x] Birim testleri yazıldı (`test/sistem_bosluklari_test.dart` & `test/olay_tarih_filtre_test.dart` — 76 olay, Kalemiye ataması, 14 başarım koşulu ve boşanma/ikinci nikah zinciri). Toplam **11/11 test YEŞİL ✅**. `flutter analyze` **0 hata / 0 uyarı ✅**.
- [x] GitHub Reposu: `https://github.com/semmhk/osmanlidabirhayat.git` (main branch).

---

## KALAN İŞLER / SONRAKİ ADIMLAR

- [ ] Yükselme, Duraklama, Gerileme ve Dağılma dönemi padişah listelerinin doğrulanarak eklenmesi.
- [ ] UI Ekranlarının (Ana Menü, Oyun Ekranı) ferman estetiğiyle entegrasyonunun tamamlanması.
- [ ] Hive entegrasyonu ve geçmiş hayatlar kaydı.
