# OSMANLI'DA BİR HAYAT — ILERLEME.md

> Her oturum sonunda güncellenir. Format: tarih + biten işler + kalan işler + bilinen sorunlar.

## MEVCUT DURUM

**Aktif Faz:** Adım 1 & Adım 4 (Proje İskeleti + Tarihsel Düzeltmeler + Birim Testleri + GitHub Entegrasyonu) ✅
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

### Adım 1 & Adım 4 — Proje Kurulumu ve Motor Entegrasyonu (TAMAMLANDI ✅)
- [x] Flutter projesi oluşturuldu (`osmanli_da_bir_hayat`).
- [x] `pubspec.yaml` bağımlılıkları ve asset tanımları yapılandırıldı.
- [x] `Karakter` modeli `dogumYili`, `takvimYili` ve `Akçe` para sistemi eklenerek yazıldı (`lib/modeller/karakter.dart`).
- [x] `Olay` ve `Secenek` modellerine `tarih_yil_min` ve `tarih_yil_max` alanları eklendi (`lib/modeller/olay.dart`).
- [x] `PadisahDeposu` ve `Donem` depoları Kuruluş dönemi (1299-1453) doğrulanmış padişah listesiyle yazıldı (`lib/modeller/padisah_deposu.dart`).
- [x] Osmanlı meslek depoları yazıldı (`lib/modeller/meslek.dart`).
- [x] `OlayYukleyici` tarih yılı min/max şema doğrulayıcısı ile yazıldı (`lib/motor/olay_yukleyici.dart`).
- [x] `OyunMotoru` takvim yılı ilerletme, tarihsel ölüm riski, `agirlikliOlaySec` (10x-25x) ve 2 yıl toleranslı garantili terfi kuralı ile yazıldı (`lib/motor/oyun_motoru.dart`).
- [x] `assets/olaylar/kurulus.json` dosyasına 15 adet araştırılmış Kuruluş dönemi olayı eklendi.
- [x] **Tarihsel İnceleme Güncellemeleri**:
  - `kurulus_06_rumeliye_gecis`: Çimpe Kalesi tarihi 1352-1357 olarak düzeltildi.
  - `kurulus_04_bursa_fethi_sevinci`: Doğrulanmamış "poyraz kapısı" ifadesi metinden temizlendi.
- [x] `VesikalikAvatar` görsel mühürlü Osmanlı çizimiyle güncellendi (`lib/bilesenler/vesikalik_avatar.dart`).
- [x] Birim testleri yazıldı (`test/olay_tarih_filtre_test.dart`, `test/oyun_motoru_agirlik_ve_terfi_test.dart` & `test/widget_test.dart`). Toplam **7/7 test YEŞİL ✅**. `flutter analyze` **0 hata / 0 uyarı ✅**.
- [x] GitHub Reposu: `https://github.com/semmhk/osmanlidabirhayat.git` (main branch).

---

## KALAN İŞLER / SONRAKİ ADIMLAR

- [ ] Yükselme, Duraklama, Gerileme ve Dağılma dönemi padişah listelerinin doğrulanarak eklenmesi.
- [ ] UI Ekranlarının (Ana Menü, Oyun Ekranı, Ferman/Berat kağıdı temalı Ölüm Ekranı) ferman estetiğiyle geliştirilmesi.
- [ ] Hive entegrasyonu ve geçmiş hayatlar kaydı.
