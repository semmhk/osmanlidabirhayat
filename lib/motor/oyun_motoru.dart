import 'dart:math';
import '../modeller/cocuk.dart';
import '../modeller/karakter.dart';
import '../modeller/olay.dart';
import '../modeller/meslek.dart';

class OyunMotoru {
  final Random _random;
  final List<Olay> tumOlaylar;
  Karakter karakter;
  Olay? bekleyenOlay;
  bool sonIslemTerfiMi = false;

  static const List<String> _sakinYilMetinleriBebek = [
    "Bu yıl mahallede sakin geçti. Oyunlar oynandı, büyümeye devam edildi.",
    "Ev içinde koşturmaca, mahalle çeşmesinden su taşıyan kadınların sesiyle bir yıl daha geçti.",
    "Bu yıl bir santimetre daha uzadı. Lonca ustalarının dükkanları seyredildi.",
    "Oyuncak tahta at koşturuldu, akşam masallarıyla uykuya daldı.",
  ];

  static const List<String> _sakinYilMetinleriGenc = [
    "Bu yıl medrese ve sokak arasında sakin geçti.",
    "Mahalle kahvesinde ve çeşme başında vakit geçirildi. Sakin bir yıl.",
    "Ahilerin dükkanları seyredildi, zanaat öğrenme hevesi büyüdü.",
    "Sıradan ama huzurlu bir yıl geride kaldı.",
  ];

  static const List<String> _sakinYilMetinleriYetiskin = [
    "Bu yıl kayda değer bir vukuat yok. Evden dükkana, dükkandan eve olaysız bir sene.",
    "Sıradan bir yıl. Komşularla selamlalaşıldı, vergiler ödendi.",
    "Sessiz bir sene. Bazen en büyük ikramiye olaysız yaşamaktır.",
    "Market ve çarşı koşturmacası olaysız kapandı.",
  ];

  static const List<String> _sakinYilMetinleriYasli = [
    "Sakin bir yıldı, torunlar ve dualar içinde geçti.",
    "Cami avlusunda dostlarla sohbet edilip çay içildi. Huzurlu bir sene.",
    "Yavaş ama keyifli bir yıl. Bahçe sulandı, kütüphaneden kitap okundu.",
  ];

  OyunMotoru({
    required this.tumOlaylar,
    Karakter? karakter,
    Random? random,
  })  : _random = random ?? Random(),
        karakter = karakter ?? yeniKarakterOlustur(random);

  static Karakter yeniKarakterOlustur([Random? rnd]) {
    final r = rnd ?? Random();
    final cinsiyet = r.nextBool() ? Cinsiyet.erkek : Cinsiyet.kadin;
    final erkekIsimleri = ['Orhan', 'Murad', 'Osman', 'Mehmed', 'Bayezid', 'Süleyman', 'Mustafa', 'Selim'];
    final kadinIsimleri = ['Nilüfer', 'Halime', 'Malhun', 'Ayşe', 'Fatma', 'Hatice', 'Emine', 'Zeynep'];
    final soyadlar = ['Efendi', 'Bey', 'Ağa', 'Çelebi', 'Zade', 'Gazi'];

    final adHavuzu = cinsiyet == Cinsiyet.kadin ? kadinIsimleri : erkekIsimleri;
    final ad = adHavuzu[r.nextInt(adHavuzu.length)];
    final soyad = soyadlar[r.nextInt(soyadlar.length)];
    final isim = '$ad $soyad';

    final genler = AvatarGenleri.rastgele(r, cinsiyet);
    return Karakter(isim: isim, cinsiyet: cinsiyet, genler: genler, rnd: r);
  }

  /// Meslek ve yaşa göre Akçe gelir hesabı
  static double gelirHesapla(Karakter k, int yas) {
    final double tabanGelir;
    if (yas <= 17) {
      tabanGelir = 0.0;
    } else if (yas <= 24) {
      tabanGelir = 10.0; // Gençlik harçlığı / Çıraklık desteği
    } else if (yas <= 59) {
      if (k.meslekZincirId == null) {
        k.meslek = 'Vasıfsız İşçi';
        if (!k.bayraklar.contains('calisaniyor')) {
          k.bayraklar.add('calisaniyor');
        }
        return 20.0; // Taban 20 Akçe
      }
      tabanGelir = 20.0;
    } else {
      tabanGelir = 15.0; // Yaşlılık desteği / Birikim
    }

    double meslekCarpan = 1.0;
    if (k.meslekZincirId != null) {
      final zincir = MeslekDeposu.zincirGetir(k.meslekZincirId);
      if (zincir != null && k.meslekKademesi >= 0 && k.meslekKademesi < zincir.kademeler.length) {
        meslekCarpan = zincir.kademeler[k.meslekKademesi].gelirCarpan;
      }
    }

    return tabanGelir * meslekCarpan;
  }

  /// Yıllık Akçe gider hesabı
  static double giderHesapla(Karakter k, int yas) {
    if (yas <= 17) return 0.0;
    double gider = 15.0; // Taban yaşam gideri
    gider += (k.cocuklar.length * 5.0); // Çocuk başı 5 Akçe
    return gider;
  }

  void yeniHayatBaslat() {
    karakter = yeniKarakterOlustur(_random);
    bekleyenOlay = null;
    sonIslemTerfiMi = false;
  }

  /// Tarihsel Osmanlı ölüm riski formülü
  bool olumKontrolu() {
    if (karakter.saglik <= 0) {
      karakter.olumNedeni ??= 'Ağır hastalık ve şifa bulunamaması';
      return true;
    }

    double yasRiski = 0.0;
    if (karakter.yas <= 2) {
      yasRiski = 0.06; // %6.0 çocukluk riski
    } else if (karakter.yas <= 5) {
      yasRiski = 0.03;
    } else if (karakter.yas >= 80) {
      yasRiski = 0.40; // %40.0 yaşlılık riski
    } else if (karakter.yas >= 70) {
      yasRiski = 0.20;
    } else if (karakter.yas >= 60) {
      yasRiski = 0.08;
    }

    double saglikRiski = 0.0;
    if (karakter.saglik < 10) {
      saglikRiski = 0.35;
    } else if (karakter.saglik < 20) {
      saglikRiski = 0.15;
    }

    double donemselRisk = 0.0;
    if (karakter.bayraklar.contains('salgin_maruz') || karakter.bayraklar.contains('savas_cebhe')) {
      donemselRisk = 0.15;
    }

    final double toplamRisk = min(1.0, yasRiski + saglikRiski + donemselRisk);

    if (toplamRisk > 0 && _random.nextDouble() < toplamRisk) {
      if (donemselRisk > 0) {
        karakter.olumNedeni ??= 'Salgın hastalık veya harp zaiyatı';
      } else if (saglikRiski > yasRiski) {
        karakter.olumNedeni ??= 'Ağır amansız hastalık';
      } else {
        karakter.olumNedeni ??= 'Ecel / Doğal vefat';
      }
      return true;
    }
    return false;
  }

  /// Terfi kontrolü & Garantili terfi kuralı
  bool terfiKontrolEt() {
    if (karakter.meslekZincirId == null) return false;

    karakter.kademedekiYil++;
    final zincir = MeslekDeposu.zincirGetir(karakter.meslekZincirId);
    if (zincir == null || karakter.meslekKademesi >= zincir.kademeler.length - 1) return false;

    final mevcutKademe = zincir.kademeler[karakter.meslekKademesi];
    final sonrakiKademe = zincir.kademeler[karakter.meslekKademesi + 1];

    if (karakter.kademedekiYil >= mevcutKademe.minYil &&
        karakter.zeka >= sonrakiKademe.minZeka &&
        karakter.itibar >= sonrakiKademe.minItibar) {
      karakter.meslekKademesi++;
      karakter.kademedekiYil = 0;
      karakter.meslek = sonrakiKademe.unvan;
      karakter.bayraklar.add('terfi_edildi');
      karakter.gunluk.insert(
        0,
        '${karakter.yas} yaş (${karakter.takvimYili}) — 🎖️ TERFİ! Yeni unvanınız: ${karakter.meslekUnvaniGetir()}',
      );
      return true;
    }
    return false;
  }

  /// Karakter için o an geçerli uygun olayları getirir (Takvim Yılı + Yaş + Bayrak Filtreli)
  List<Olay> uygunOlaylariGetir() {
    return tumOlaylar.where((o) {
      if (karakter.kullanilanOlaylar.contains(o.id) && o.tekSeferlik) return false;

      // 1. Yaş Aralığı Doğrulaması
      if (karakter.yas < o.yasMin || karakter.yas > o.yasMax) return false;

      // 2. Takvim Yılı Aralığı Doğrulaması (Yeni Tarih Filtresi)
      if (o.tarihYilMin != null && karakter.takvimYili < o.tarihYilMin!) return false;
      if (o.tarihYilMax != null && karakter.takvimYili > o.tarihYilMax!) return false;

      // 3. Stat Şartı Doğrulaması
      if (o.kosul != null) {
        final val = switch (o.kosul!.stat) {
          'saglik' => karakter.saglik,
          'mutluluk' => karakter.mutluluk,
          'zeka' => karakter.zeka,
          'para' => karakter.para,
          'itibar' => karakter.itibar,
          _ => 0,
        };
        if (val < o.kosul!.min) return false;
      }

      // 4. Bayrak Doğrulamaları
      if (o.gerekliBayrak != null && !karakter.bayraklar.contains(o.gerekliBayrak)) return false;
      if (o.gerekliBayraklar != null && !o.gerekliBayraklar!.every(karakter.bayraklar.contains)) return false;
      if (o.engelBayrak != null && karakter.bayraklar.contains(o.engelBayrak)) return false;

      return true;
    }).toList();
  }

  /// Bir yıl yaşama fonksiyonu
  bool yilYasa() {
    if (karakter.olu) return false;

    karakter.yas++;
    sonIslemTerfiMi = terfiKontrolEt();

    karakter.yillikGelir = gelirHesapla(karakter, karakter.yas);
    karakter.yillikGider = giderHesapla(karakter, karakter.yas);
    karakter.bakiye += (karakter.yillikGelir - karakter.yillikGider);

    if (olumKontrolu()) {
      karakter.olu = true;
      karakter.gunluk.insert(
        0,
        '${karakter.yas} yaş (${karakter.takvimYili}) — VEFAT: ${karakter.olumNedeni ?? "Ecel"}',
      );
      return false;
    }

    final uygunlar = uygunOlaylariGetir();
    if (uygunlar.isNotEmpty) {
      // Öncelikli / Kilometre taşı ağırlıklandırma seçimi
      final oncelikliler = uygunlar.where((o) => o.oncelikli).toList();
      if (oncelikliler.isNotEmpty && _random.nextDouble() < 0.70) {
        bekleyenOlay = oncelikliler[_random.nextInt(oncelikliler.length)];
      } else {
        bekleyenOlay = uygunlar[_random.nextInt(uygunlar.length)];
      }
    } else {
      bekleyenOlay = null;
      final metin = _sakinMetinGetir(karakter.yas);
      karakter.gunluk.insert(
        0,
        '${karakter.yas} yaş (${karakter.takvimYili}) — $metin',
      );
    }

    return true;
  }

  String _sakinMetinGetir(int yas) {
    if (yas <= 12) return _sakinYilMetinleriBebek[_random.nextInt(_sakinYilMetinleriBebek.length)];
    if (yas <= 24) return _sakinYilMetinleriGenc[_random.nextInt(_sakinYilMetinleriGenc.length)];
    if (yas <= 59) return _sakinYilMetinleriYetiskin[_random.nextInt(_sakinYilMetinleriYetiskin.length)];
    return _sakinYilMetinleriYasli[_random.nextInt(_sakinYilMetinleriYasli.length)];
  }

  void secenekSec(Secenek secenek) {
    if (bekleyenOlay == null || karakter.olu) return;

    karakter.saglik += secenek.etki.saglik;
    karakter.mutluluk += secenek.etki.mutluluk;
    karakter.zeka += secenek.etki.zeka;
    karakter.para += secenek.etki.para;
    karakter.itibar += secenek.etki.itibar;
    karakter.statSinirla();

    if (secenek.meslekAtama != null) {
      karakter.meslekZincirId = secenek.meslekAtama;
      karakter.meslekKademesi = 0;
      karakter.kademedekiYil = 0;
      final zincir = MeslekDeposu.zincirGetir(secenek.meslekAtama);
      if (zincir != null && zincir.kademeler.isNotEmpty) {
        karakter.meslek = zincir.kademeler[0].unvan;
        karakter.bayraklar.add('meslek_${secenek.meslekAtama}');
        karakter.bayraklar.add('calisaniyor');
      }
    }

    if (secenek.bayrakEkle != null) karakter.bayraklar.add(secenek.bayrakEkle!);
    if (secenek.bayraklarEkle != null) karakter.bayraklar.addAll(secenek.bayraklarEkle!);
    if (secenek.bayrakKaldir != null) karakter.bayraklar.remove(secenek.bayrakKaldir!);

    karakter.kullanilanOlaylar.add(bekleyenOlay!.id);

    // Ani ölümcül kaza kontrolü
    if (secenek.olumculSans > 0 && _random.nextInt(100) < secenek.olumculSans) {
      karakter.olu = true;
      karakter.olumNedeni = secenek.olumNedeni ?? 'Beklenmedik felaket / Kaza';
      karakter.gunluk.insert(
        0,
        '${karakter.yas} yaş (${karakter.takvimYili}) — VEFAT: ${karakter.olumNedeni}',
      );
    } else {
      karakter.gunluk.insert(
        0,
        '${karakter.yas} yaş (${karakter.takvimYili}) — ${secenek.sonuc}',
      );
    }

    bekleyenOlay = null;
  }
}
