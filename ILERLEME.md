# OSMANLI'DA BİR HAYAT — ILERLEME.md

> Her oturum sonunda güncellenir. Format: tarih + biten işler + kalan işler + bilinen sorunlar.

## MEVCUT DURUM

**Aktif Faz:** 🎉 **BÜYÜK OYNANIŞ REVİZYONU & DENGELENMİŞ ÜÇ SİSTEM TAMAMLANDI!** 🎉 (Aktiviteler Menüsü + Stat Kilitli Seçenekler + Gerçek İlişki ve Nesil Mirası Sistemi + 35/35 Yeşillenen Testler + 0 Hata/0 Uyarı `flutter analyze`) ✅  
**Son güncelleme:** 25 Temmuz 2026

---

## TAMAMLANANLAR

### Ön Hazırlık & Mimarı Tasarım (23 Temmuz 2026)
- [x] Mevcut "Türkiye'de Bir Hayat" projesi incelendi ve motor mimarisi uyarlandı (`C:\Users\STUDYO\Desktop\turkiyede_bir_hayat`).
- [x] Takvim yılı sistemi mimarisi kuruldu (`dogumYili` 1299-1900, `takvimYili`, `PadisahDeposu`).
- [x] Osmanlı meslek zincirleri tasarlandı (`ahilik`, `ilmiye`, `seyfiye`, `kalemiye` — 1.0x-8.0x dengeli çarpanlar).
- [x] Tarihsel ölüm riski formülü ve öncelikli/kilometre taşı olay seçimi kuralları netleştirildi (2 yıl bekleme sonrası garantili terfi kuralı).
- [x] Soyut "Akçe" ekonomi birimi modeli uygulandı.

### Büyük Oynanış Revizyonu — 3 Sistem (25 Temmuz 2026 - TAMAMLANDI 🎉)
- [x] **1) Aktiviteler Menüsü & Akçe Harcama Motoru (`FaaliyetEkrani`)**:
  - Oyuncuya her yıl için **2 faaliyet hakkı** verilir (yıl ilerletildiğinde yenilenir).
  - 15 otantik Osmanlı faaliyeti (Darüşşifa, Mesir Macunu, Medrese, İstinsah, Âlim Meclisi, İmaret Bağışı, Lonca, Tekke/Cami, Dükkan Satın Alma [Max 2 Mülk], Kervan Ticareti, Kahvehane, Hamam Sefası, Aile Sofrası, Eşle Mesire, Çocuk Eğitimi) eklendi.
  - **Stat Azalan Getiri Formülü (Diminishing Returns)**: Stat < 50 iken taban kazanç, 50-74 iken +3, 75-89 iken +1, 90+ iken +0 (Faaliyetler karakteri 90 üzerine çıkaramaz).
- [x] **2) Stat Kilitleri & Seçenek Koşulları (`Secenek`)**:
  - `Secenek` modeline `gerekli_zeka`, `gerekli_itibar`, `gerekli_saglik`, `gerekli_mutluluk`, `gerekli_para` alanları eklendi.
  - Ferman kartındaki seçenekler stat şartı karşılanmıyorsa **soluk gri ve kilitli (`🔒 Kilitli: 50 Zeka gerekli`)** çizilir.
- [x] **3) Gerçek İlişki Sistemi & Tavanlı Nesil Mirası (`Iliski` & `IliskilerEkrani`)**:
  - Eş ve çocuklar `Iliski` nesnelerine dönüştürüldü (`yakinlikPuani: 0-100`, `egitimPuani: 0-100`).
  - İlgilenilmeyen ilişkiler her yıl `-1` yakınlık kaybeder.
  - **Aile Sofrası Dengelemesi**: 60 Akçe maliyet ile tüm hane yakınlığı `+2` artırılır.
  - **Nesil Değişimi**: Yakınlık %80+ olan evlatla devam edildiğinde %60 Miras Akçe devri (Sert Tavan: Max 1.000 Akçe), Stat Miras Bonusu (Eğitim ve Yakınlık bazlı) ve max 1 mülk devri sağlandı.
- [x] **4) Geriye Dönük Uyumluluk (Backward Compatibility)**:
  - `Karakter.fromJson` eski save JSON'larını varsayılan `aktiviteHakki: 2`, `mulkler: []`, `iliskiler: []` ile çökmeksizin yükler.
- [x] **5) Test & Analiz**: **35/35 test YEŞİL PAS GEÇTİ ✅**, `flutter analyze` **0 HATA / 0 UYARI ✅**.

---

## GİT & DEPLOYMENT DURUMU

- **GitHub Reposu**: `https://github.com/semmhk/osmanlidabirhayat.git` (main branch).
- **Masaüstü APK**: `C:\Users\STUDYO\Desktop\osmanhayat2.0.apk` (55.2 MB Release APK).
