# OSMANLI'DA BİR HAYAT — ILERLEME.md

> Her oturum sonunda güncellenir. Format: tarih + biten işler + kalan işler + bilinen sorunlar.

## MEVCUT DURUM

**Aktif Faz:** Adım 1 & Adım 4 (Proje İskeleti + 105 Olaylık Kuruluş Dönemi & 4 Padişah Alt-Dönemi TAMAMLANDI + 14 Başarım Sistemi + Kalemiye & Boşanma Zincirleri + Birim Testleri + GitHub Entegrasyonu) ✅
**Son güncelleme:** 24 Temmuz 2026

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
- [x] **Padişah Alt-Dönemleri (4/7 Padişah TAMAMLANDI)**:
  - **Osman Gazi (1299-1326)**: 17 Olay TAMAMLANDI (`alt_donem: "osman_gazi"` — İlk Hutbe & Dursun Fakih Kadılığı dahil).
  - **Orhan Gazi (1326-1362)**: 20 Olay TAMAMLANDI (`alt_donem: "orhan_gazi"` — İlk Divan, Yaya-Müsellem, Gümüş Akçe, İznik Medresesi, Maltepe Savaşı, Karesi katılımı, Karamürsel tersanesi ve Vefat köprüsü).
  - **I. Murad Hüdavendigâr (1362-1389)**: 18 Olay TAMAMLANDI (`alt_donem: "murad_1"` — Edirne fethi, Pençik sistemi, Acemi Oğlanlar Ocağı & Yeniçerilik, Rumeli Beylerbeyliği, Tımar sistemi, Enderun Mektebi, Germiyan çeyizi, Çirmen savaşı, Veraset değişimi, Savcı Bey isyanı, ilk Sadrazamlık, Selanik seferi, Bulgar tabiiyeti, Gelibolu iadesi, Sancak eğitimi ve Kosova şehadeti).
  - **Yıldırım Bayezid (1389-1402)**: 12 yeni + mevcut ~7 = ~19 Olay TAMAMLANDI (`kurulus_094` - `kurulus_105`, `alt_donem: "yildirim_bayezid"` — Anadolu beylikleri ilhakı, Anadolu Beylerbeyliği, Kırkdilim yenilgisi & Şehzade Ertuğrul şehadeti, Akçay zaferi, Sultan-ı İklim-i Rum unvanı, Gelibolu tersanesi & Kaptan-ı Derya, Sırp prenses Despina evliliği, Bosna tabiiyeti, Timur gerginliği & Kara Yusuf kabulü, Sivas katliamı, İlk İstanbul kuşatması, Doğu-Batı kıskacı).
- [x] **Sistem boşlukları kapatıldı: kalemiye, 14 başarım, boşanma/nesil içeriği**:
  - 14 Osmanlı-uyumlu Başarım sistemi eklendi (`assets/basarimlar.json`, `lib/modeller/basarim.dart`, `lib/motor/basarim_kontrolcusu.dart`).
  - Kalemiye Meslek Zinciri eklendi (`kurulus_073`).
  - Boşanma / Eşin Vefatı / İkinci Nikah Zinciri eklendi (`kurulus_074`, `kurulus_075`, `kurulus_076`).
  - UI Ekranları: `BasarimlarEkrani` ve `OlumEkrani` eklendi (`lib/ekranlar/`).
- [x] **Kuruluş dönemi: 105 olay TAMAMLANDI** (`assets/olaylar/kurulus.json` - 105 benzersiz ID'li, tarih ve yaş filtreli olay).
- [x] Birim testleri yazıldı (`test/sistem_bosluklari_test.dart` & `test/olay_tarih_filtre_test.dart` — 105 olay, Kalemiye ataması, 14 başarım koşulu ve boşanma/ikinci nikah zinciri). Toplam **11/11 test YEŞİL ✅**. `flutter analyze` **0 hata / 0 uyarı ✅**.
- [x] GitHub Reposu: `https://github.com/semmhk/osmanlidabirhayat.git` (main branch).

---

## KALAN İŞLER / SONRAKİ ADIMLAR

- [ ] Çelebi Mehmed (Fetret Devri sonu), II. Murad ve II. Mehmed (Fatih) alt-dönem olaylarının eklenmesi.
- [ ] Yükselme, Duraklama, Gerileme ve Dağılma dönemi padişah listelerinin doğrulanarak eklenmesi.
- [ ] UI Ekranlarının (Ana Menü, Oyun Ekranı) ferman estetiğiyle entegrasyonunun tamamlanması.
- [ ] Hive entegrasyonu ve geçmiş hayatlar kaydı.
