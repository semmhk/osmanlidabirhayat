import 'dart:math';
import '../modeller/cocuk.dart';
import '../modeller/karakter.dart';
import '../modeller/olay.dart';
import '../modeller/meslek.dart';
import '../modeller/padisah_deposu.dart';

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

  static double gelirHesapla(Karakter k, int yas) {
    final double tabanGelir;
    if (yas <= 17) {
      tabanGelir = 0.0;
    } else if (yas <= 24) {
      tabanGelir = 10.0;
    } else if (yas <= 59) {
      if (k.meslekZincirId == null) {
        k.meslek = 'Vasıfsız İşçi';
        if (!k.bayraklar.contains('calisaniyor')) {
          k.bayraklar.add('calisaniyor');
        }
        return 20.0;
      }
      tabanGelir = 20.0;
    } else {
      tabanGelir = 15.0;
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

  static double giderHesapla(Karakter k, int yas) {
    if (yas <= 17) return 0.0;
    double gider = 15.0;
    gider += (k.cocuklar.length * 5.0);
    return gider;
  }

  void yeniHayatBaslat() {
    karakter = yeniKarakterOlustur(_random);
    bekleyenOlay = null;
    sonIslemTerfiMi = false;
  }

  static double toplamOlumRiskiHesapla(Karakter karakter) {
    if (karakter.saglik <= 0) return 1.0;

    double yasRiski = 0.0;
    if (karakter.yas <= 2) {
      yasRiski = 0.06;
    } else if (karakter.yas <= 5) {
      yasRiski = 0.03;
    } else if (karakter.yas >= 80) {
      yasRiski = 0.40;
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

    double donemselSaglikCarpani = 1.0;
    if (karakter.takvimYili < 1703) {
      donemselSaglikCarpani = 1.30;
    } else if (karakter.takvimYili < 1807) {
      donemselSaglikCarpani = 1.15;
    } else if (karakter.takvimYili < 1850) {
      donemselSaglikCarpani = 1.00;
    } else {
      donemselSaglikCarpani = 0.80;
    }

    double tarihselSalginRiski = 0.0;
    final yil = karakter.takvimYili;
    if ((yil >= 1347 && yil <= 1351) || (yil >= 1812 && yil <= 1813) || (yil >= 1918 && yil <= 1919)) {
      tarihselSalginRiski = 0.15;
    } else if ((yil >= 1511 && yil <= 1512) || yil == 1778 || yil == 1831 || yil == 1847 || yil == 1848) {
      tarihselSalginRiski = 0.12;
    }

    return min(1.0, (yasRiski * donemselSaglikCarpani) + saglikRiski + donemselRisk + tarihselSalginRiski);
  }

  bool olumKontrolu() {
    if (karakter.saglik <= 0) {
      karakter.olumNedeni ??= 'Ağır hastalık ve şifa bulunamaması';
      return true;
    }

    final double toplamRisk = toplamOlumRiskiHesapla(karakter);

    if (toplamRisk > 0 && _random.nextDouble() < toplamRisk) {
      if (karakter.bayraklar.contains('salgin_maruz') || karakter.bayraklar.contains('savas_cebhe')) {
        karakter.olumNedeni ??= 'Salgın hastalık veya harp zaiyatı';
      } else if (karakter.saglik < 20) {
        karakter.olumNedeni ??= 'Ağır amansız hastalık';
      } else {
        karakter.olumNedeni ??= 'Ecel / Doğal vefat';
      }
      return true;
    }
    return false;
  }

  /// Terfi Kontrolü: 
  /// - Karakter terfi şartlarını sağladıysa kademedeki süresini takip eder.
  /// - Eğer şartlar sağlandığı halde 2 yıl bekleme süresi dolmuşsa (kademedekiYil >= minYil + 2), 
  ///   GARANTİLİ / ZORUNLU TERFİ gerçekleşir.
  bool terfiKontrolEt() {
    if (karakter.meslekZincirId == null) return false;

    karakter.kademedekiYil++;
    final zincir = MeslekDeposu.zincirGetir(karakter.meslekZincirId);
    if (zincir == null || karakter.meslekKademesi >= zincir.kademeler.length - 1) return false;

    final mevcukKademe = zincir.kademeler[karakter.meslekKademesi];
    final sonrakiKademe = zincir.kademeler[karakter.meslekKademesi + 1];

    // Şartlar sağlandı mı?
    if (karakter.kademedekiYil >= mevcukKademe.minYil &&
        karakter.zeka >= sonrakiKademe.minZeka &&
        karakter.itibar >= sonrakiKademe.minItibar) {
      
      // 2 yıl tolerans bekleme süresi dolduysa ZORUNLU GARANTİLİ TERFİ!
      if (karakter.kademedekiYil >= mevcukKademe.minYil + 2) {
        karakter.meslekKademesi++;
        karakter.kademedekiYil = 0;
        karakter.meslek = sonrakiKademe.unvan;
        karakter.bayraklar.add('terfi_edildi');
        karakter.gunluk.insert(
          0,
          '${karakter.yas} yaş (${karakter.takvimYili}) — 🎖️ GARANTİLİ TERFİ! Yeni unvanınız: ${karakter.meslekUnvaniGetir()}',
        );
        return true;
      }
    }
    return false;
  }

  /// Karakter için o an geçerli uygun olayları getirir (Takvim Yılı + Yaş + Bayrak Filtreli)
  List<Olay> uygunOlaylariGetir() {
    return tumOlaylar.where((o) {
      if (karakter.kullanilanOlaylar.contains(o.id) && o.tekSeferlik) return false;

      if (karakter.yas < o.yasMin || karakter.yas > o.yasMax) return false;

      if (o.tarihYilMin != null && karakter.takvimYili < o.tarihYilMin!) return false;
      if (o.tarihYilMax != null && karakter.takvimYili > o.tarihYilMax!) return false;

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

      if (o.gerekliBayrak != null && !karakter.bayraklar.contains(o.gerekliBayrak)) return false;
      if (o.gerekliBayraklar != null && !o.gerekliBayraklar!.every(karakter.bayraklar.contains)) return false;
      if (o.engelBayrak != null && karakter.bayraklar.contains(o.engelBayrak)) return false;

      return true;
    }).toList();
  }

  final List<String> sonGosterilenOlaylar = [];

  /// Olay Havuzu Sayısal Ağırlıklandırması (Weighted Pool Selector)
  /// - Son 10 turda gösterilen olaylar havuzdan öncelikle elenerek çeşitlilik sağlanır.
  /// - Tarihsel dönem ve gündelik olay çeşitliliği artırılmıştır.
  Olay? agirlikliOlaySec(List<Olay> uygunlar) {
    if (uygunlar.isEmpty) return null;

    // Son gösterilen olayları süzerek çeşitlilik sağla
    final tazeOlaylar = uygunlar.where((o) => !sonGosterilenOlaylar.contains(o.id)).toList();
    final secimHavuzu = tazeOlaylar.isNotEmpty ? tazeOlaylar : uygunlar;

    final List<int> agirliklar = [];
    int toplamAgirlik = 0;

    for (final o in secimHavuzu) {
      bool tarihiOlay = !o.id.startsWith('gundelik');
      int agirlik = tarihiOlay ? 8 : 2; // Tarihi olaylara 4 kat daha yüksek öncelik

      if (o.oncelikli) {
        // Telafi durumu kontrolü
        final bool meslekTelafi = (karakter.yas >= 18 && karakter.meslekZincirId == null);
        final bool evlilikTelafi = (karakter.yas >= 28 && karakter.esAdi == null);

        if (meslekTelafi || evlilikTelafi) {
          agirlik = 12; // Telafi ağırlığı
        } else {
          agirlik = 8; // Kilometre taşı ağırlığı
        }
      }

      // Terfi dönemi olayları
      if (karakter.meslekZincirId != null) {
        final zincir = MeslekDeposu.zincirGetir(karakter.meslekZincirId);
        if (zincir != null && karakter.meslekKademesi < zincir.kademeler.length - 1) {
          final mevcukKademe = zincir.kademeler[karakter.meslekKademesi];
          if (karakter.kademedekiYil >= mevcukKademe.minYil) {
            agirlik = max(agirlik, 8);
          }
        }
      }

      agirliklar.add(agirlik);
      toplamAgirlik += agirlik;
    }

    int zar = _random.nextInt(toplamAgirlik);
    Olay secilen = secimHavuzu.last;
    for (var i = 0; i < secimHavuzu.length; i++) {
      if (zar < agirliklar[i]) {
        secilen = secimHavuzu[i];
        break;
      }
      zar -= agirliklar[i];
    }

    sonGosterilenOlaylar.add(secilen.id);
    if (sonGosterilenOlaylar.length > 10) {
      sonGosterilenOlaylar.removeAt(0);
    }

    return secilen;
  }

  /// Bir yıl yaşama fonksiyonu
  bool yilYasa() {
    if (karakter.olu) return false;

    if (karakter.takvimYili >= PadisahDeposu.imparatorlukSonYili) {
      karakter.hikayesiTamamlandi = true;
      karakter.olu = true;
      karakter.olumNedeni = "Sonuç: Osmanlı Dönemi Hikayesi Tamamlandı (1922)";
      karakter.gunluk.insert(
        0,
        '${karakter.yas} yaş (${karakter.takvimYili}) — 🏛️ HİKAYENİN SONU: 1922\'de Osmanlı Devleti\'nin sona ermesiyle, ${karakter.isim}\'in bu topraklardaki Osmanlı dönemi hikayesi burada tamamlandı. Hayatı Cumhuriyet Türkiyesi\'nde devam etti.',
      );
      return false;
    }

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
      // Sayısal ağırlıklandırma algoritması ile seçim yap
      bekleyenOlay = agirlikliOlaySec(uygunlar);
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

  static void secenekUygula(Karakter k, Secenek secenek) {
    k.saglik += secenek.etki.saglik;
    k.mutluluk += secenek.etki.mutluluk;
    k.zeka += secenek.etki.zeka;
    k.para += secenek.etki.para;
    k.itibar += secenek.etki.itibar;
    k.statSinirla();

    if (secenek.meslekAtama != null) {
      k.meslekZincirId = secenek.meslekAtama;
      k.meslekKademesi = 0;
      k.kademedekiYil = 0;
      final zincir = MeslekDeposu.zincirGetir(secenek.meslekAtama);
      if (zincir != null && zincir.kademeler.isNotEmpty) {
        k.meslek = zincir.kademeler[0].unvan;
        k.bayraklar.add('meslek_${secenek.meslekAtama}');
        k.bayraklar.add('calisaniyor');
      }
    }

    if (secenek.bayrakEkle != null) k.bayraklar.add(secenek.bayrakEkle!);
    if (secenek.bayraklarEkle != null) k.bayraklar.addAll(secenek.bayraklarEkle!);
    if (secenek.bayrakKaldir != null) k.bayraklar.remove(secenek.bayrakKaldir!);
  }

  void secenekSec(Secenek secenek) {
    if (bekleyenOlay == null || karakter.olu) return;

    secenekUygula(karakter, secenek);
    karakter.kullanilanOlaylar.add(bekleyenOlay!.id);

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

  /// Nesil devamının 1922 tarihi sınırına takılıp takılmadığını kontrol eder
  bool nesilDevamEdebilirMi() {
    return karakter.takvimYili < PadisahDeposu.imparatorlukSonYili;
  }

  /// Seçilen evlat ile oyuna devam etme (Nesil Devamı)
  Karakter nesilDevamEt(Cocuk secilenCocuk) {
    final int baslangicYasi = secilenCocuk.guncelYasGetir(karakter.yas);
    final int cocukDogumYili = (karakter.dogumYili + secilenCocuk.ebeveynYasiDogum).toInt();
    final cocukCinsiyet = secilenCocuk.erkekMi ? Cinsiyet.erkek : Cinsiyet.kadin;

    // Miras Hesabı: Pozitif bakiyenin %40'ı çocuk sayısına eşit bölünür
    final double mirasMiktari;
    if (karakter.bakiye > 0 && karakter.cocuklar.isNotEmpty) {
      mirasMiktari = (karakter.bakiye * 0.40) / karakter.cocuklar.length;
    } else {
      mirasMiktari = 0.0;
    }

    // Yaşa Göre Başlangıç Sağlığı Formülü
    final int baslangicSaglik = (80 - ((baslangicYasi - 18).clamp(0, 50) * 0.4)).round().clamp(40, 80);

    final yeniKarakter = Karakter(
      ad: secilenCocuk.ad,
      soyad: karakter.soyad,
      yas: baslangicYasi,
      dogumYili: cocukDogumYili,
      nesil: karakter.nesil + 1,
      saglik: baslangicSaglik,
      mutluluk: 65,
      zeka: 50,
      itibar: 50,
      bakiye: mirasMiktari,
      cinsiyet: cocukCinsiyet,
      genler: AvatarGenleri.rastgele(_random, cocukCinsiyet),
    );

    // Temiz sayfa: Meslek ve bayrakları sıfırla
    yeniKarakter.meslekZincirId = null;
    yeniKarakter.meslekKademesi = 0;
    yeniKarakter.kademedekiYil = 0;
    yeniKarakter.meslek = 'Vasıfsız İşçi';
    yeniKarakter.bayraklar.clear();

    // Çocuğun başlangıç yaşının altındaki tek seferlik olayları egzoz et
    for (final o in tumOlaylar) {
      if (o.tekSeferlik && o.yasMax < baslangicYasi) {
        yeniKarakter.kullanilanOlaylar.add(o.id);
      }
    }

    yeniKarakter.gunluk.insert(
      0,
      '$baslangicYasi yaş (${yeniKarakter.takvimYili}) — 📜 NESİL DEVAMI: ${karakter.isim} ailesinin ${yeniKarakter.nesil}. nesli olarak yaşam bayrağını devraldın. (Devrolan Akçe Mirası: ${Karakter.paraFormatla(mirasMiktari)})',
    );

    karakter = yeniKarakter;
    bekleyenOlay = null;
    sonIslemTerfiMi = false;
    return yeniKarakter;
  }
}
