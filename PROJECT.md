# OSMANLI'DA BİR HAYAT — PROJECT.md

> Bu dosya projenin anayasasıdır. Her oturumda önce bu dosya okunur.
> İlerleme durumu için ILERLEME.md'ye bakılır ve her oturum sonunda güncellenir.

## 1. PROJE NEDİR?

"Türkiye'de Bir Hayat" projesinin kardeş projesi. 1299-1922 yılları arasında Osmanlı İmparatorluğu'nda geçen, gerçek tarihi zaman çizelgesine bağlı bir hayat simülasyonu oyunu.
Oyuncu doğar (1299-1900 arası rastgele doğum yılı), her yıl "Bir Yıl Yaşa" butonuna basar; o anki takvim yılı ve yaşına uygun olaylar gelir, kararlar verir, statları değişir, padişah dönemlerine tanıklık eder, ölünce paylaşılabilir bir "hayat özeti" alır ve nesil devriyle yeniden başlar.

## 2. TEKNİK KARARLAR (DEĞİŞTİRİLEMEZ)

| Konu | Karar |
|---|---|
| Framework | Flutter (Flame GEREKMEZ — düz Flutter yeterli) |
| State management | Riverpod |
| Yerel veri | Hive (kayıtlı hayatlar, ayarlar, istatistikler) |
| Olay verisi | assets/olaylar/*.json — koddan tamamen ayrı |
| Tarih Sistemi | Takvim Yılı (`dogumYili` + `yas`), Padişah ve Dönem Deposu (`PadisahDeposu`) |
| Para Birimi | Dönem-nötr "Akçe" birimi |
| Görsel Tema | Koyu Sepya & Parşömen estetiği, Altın / Osmanlı Kırmızısı vurğuları, Tuğra mührü |
| Dil | Kod, yorumlar, dosya adları, UI: TAMAMEN TÜRKÇE |
| Min. platform | Android (öncelik), iOS sonra |

## 3. DOSYA YAPISI

```
osmanli_da_bir_hayat/
├── PROJECT.md
├── ILERLEME.md
├── pubspec.yaml
├── assets/
│   └── olaylar/
│       └── kurulus.json      (1299-1453 Kuruluş dönemi olayları)
├── lib/
│   ├── main.dart
│   ├── bilesenler/
│   │   └── vesikalik_avatar.dart
│   ├── modeller/
│   │   ├── olay.dart          (Olay, Secenek, Etki, Kosul modelleri + tarihYilMin/Max)
│   │   ├── karakter.dart      (dogumYili, takvimYili, Akçe bakiye, statlar)
│   │   ├── meslek.dart        (ahilik, ilmiye, seyfiye, kalemiye)
│   │   ├── padisah_deposu.dart(Kuruluş dönemi padişahları ve dönem aralıkları)
│   │   └── cocuk.dart
│   ├── motor/
│   │   ├── oyun_motoru.dart   (takvim yılı, tarihsel ölüm riski, terfi garantisi)
│   │   └── olay_yukleyici.dart(tarih_yil_min/max JSON şema doğrulayıcı)
└── test/
    ├── olay_tarih_filtre_test.dart
    └── widget_test.dart
```

## 4. OLAY JSON ŞEMASI (Tarih Çizelgeli)

```json
{
  "id": "kurulus_01_ahilik_giris",
  "yas_min": 10,
  "yas_max": 14,
  "tarih_yil_min": 1299,
  "tarih_yil_max": 1453,
  "tek_seferlik": true,
  "oncelikli": true,
  "metin": "Olay açıklaması. Hikaye metni.",
  "secenekler": [
    {
      "metin": "Seçenek açıklaması",
      "etki": { "zeka": 10, "itibar": 10, "para": 5 },
      "meslek_atama": "ahilik",
      "bayrak_ekle": "meslek_ahilik",
      "sonuc": "Sonuç metni"
    }
  ]
}
```

Kurallar:
- `id` benzersiz, `donem_sayi_isim` formatında
- `tarih_yil_min` / `tarih_yil_max` opsiyonel: Olayın geçerli olduğu gerçek tarih aralığı
- `gerekli_bayrak`, `gerekli_bayraklar`, `engel_bayrak` desteklenir
- Gerçek tarihi kişilere uydurma söz/replik KONULMAZ. Karakter sıradan bir halk üyesidir. Dini/mezhepsel tarafsızlık esastır.

## 5. MESLEK ZİNCİRLERİ (1.0x - 8.0x)

1. `ahilik` (Esnaf/Lonca): Çırak (1.0x) → Kalfa (2.0x) → Usta (4.0x) → Lonca Ustabaşısı (7.0x)
2. `ilmiye` (Medrese/Din): Talebe (0.8x) → Danişmend (2.2x) → Müderris (4.5x) → Kadı (8.0x)
3. `seyfiye` (Askeri): Yeni Asker (1.2x) → Sipahi (2.5x) → Bölükbaşı (4.5x) → Ağa (7.5x)
4. `kalemiye` (Bürokrasi): Kâtip (1.2x) → Halifeler (2.5x) → Reisülküttab Yrd. (4.8x) → Defterdar (8.0x)
