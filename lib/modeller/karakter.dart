import 'dart:collection';
import 'dart:math';
import 'cocuk.dart';
import 'meslek.dart';
import 'padisah_deposu.dart';

enum TenTonu { acik, bugday, esmer, koyu }
enum SacRengi { siyah, kumral, kahverengi, beyaz }
enum SacStili { duz, dalgali, kisa, uzun, kel }
enum YuzSekli { oval, yuvarlak, koseli }
enum Cinsiyet { erkek, kadin }

class AvatarGenleri {
  final TenTonu tenTonu;
  final SacRengi sacRengi;
  final SacStili sacStili;
  final YuzSekli yuzSekli;
  final bool gozlukVar;
  final bool biyikSakalVar;
  final Cinsiyet cinsiyet;

  AvatarGenleri({
    required this.tenTonu,
    required this.sacRengi,
    required this.sacStili,
    required this.yuzSekli,
    required this.gozlukVar,
    required this.biyikSakalVar,
    this.cinsiyet = Cinsiyet.erkek,
  });

  factory AvatarGenleri.rastgele([Random? rnd, Cinsiyet? cinsiyet]) {
    final r = rnd ?? Random();
    final activeCinsiyet = cinsiyet ?? (r.nextBool() ? Cinsiyet.erkek : Cinsiyet.kadin);
    final bool erkek = activeCinsiyet == Cinsiyet.erkek;

    final SacStili sacStili;
    if (erkek) {
      const erkekSacStilleri = [
        SacStili.kisa,
        SacStili.kisa,
        SacStili.kisa,
        SacStili.duz,
        SacStili.duz,
        SacStili.dalgali,
        SacStili.uzun,
        SacStili.kel,
      ];
      sacStili = erkekSacStilleri[r.nextInt(erkekSacStilleri.length)];
    } else {
      const kadinSacStilleri = [
        SacStili.uzun,
        SacStili.uzun,
        SacStili.uzun,
        SacStili.dalgali,
        SacStili.dalgali,
        SacStili.dalgali,
        SacStili.duz,
        SacStili.kisa,
      ];
      sacStili = kadinSacStilleri[r.nextInt(kadinSacStilleri.length)];
    }

    final YuzSekli yuzSekli;
    if (erkek) {
      const erkekYuzSekilleri = [
        YuzSekli.koseli,
        YuzSekli.koseli,
        YuzSekli.oval,
        YuzSekli.yuvarlak,
      ];
      yuzSekli = erkekYuzSekilleri[r.nextInt(erkekYuzSekilleri.length)];
    } else {
      const kadinYuzSekilleri = [
        YuzSekli.oval,
        YuzSekli.oval,
        YuzSekli.yuvarlak,
        YuzSekli.yuvarlak,
      ];
      yuzSekli = kadinYuzSekilleri[r.nextInt(kadinYuzSekilleri.length)];
    }

    return AvatarGenleri(
      tenTonu: TenTonu.values[r.nextInt(TenTonu.values.length)],
      sacRengi: SacRengi.values[r.nextInt(SacRengi.values.length)],
      sacStili: sacStili,
      yuzSekli: yuzSekli,
      gozlukVar: false, // Osmanlı döneminde gözlük oldukça nadir
      biyikSakalVar: erkek ? r.nextDouble() < 0.70 : false, // Osmanlı erkeklerinde sakal/bıyık yaygın
      cinsiyet: activeCinsiyet,
    );
  }

  factory AvatarGenleri.fromJson(Map<String, dynamic> json) {
    return AvatarGenleri(
      tenTonu: TenTonu.values.firstWhere(
        (e) => e.name == json['tenTonu'],
        orElse: () => TenTonu.bugday,
      ),
      sacRengi: SacRengi.values.firstWhere(
        (e) => e.name == json['sacRengi'],
        orElse: () => SacRengi.siyah,
      ),
      sacStili: SacStili.values.firstWhere(
        (e) => e.name == json['sacStili'],
        orElse: () => SacStili.kisa,
      ),
      yuzSekli: YuzSekli.values.firstWhere(
        (e) => e.name == json['yuzSekli'],
        orElse: () => YuzSekli.oval,
      ),
      gozlukVar: json['gozlukVar'] as bool? ?? false,
      biyikSakalVar: json['biyikSakalVar'] as bool? ?? false,
      cinsiyet: Cinsiyet.values.firstWhere(
        (e) => e.name == json['cinsiyet'],
        orElse: () => Cinsiyet.erkek,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tenTonu': tenTonu.name,
      'sacRengi': sacRengi.name,
      'sacStili': sacStili.name,
      'yuzSekli': yuzSekli.name,
      'gozlukVar': gozlukVar,
      'biyikSakalVar': biyikSakalVar,
      'cinsiyet': cinsiyet.name,
    };
  }
}

class Karakter {
  String ad;
  String soyad;

  String get isim => '$ad $soyad'.trim();
  set isim(String yeniIsim) {
    final parcalar = yeniIsim.trim().split(' ');
    if (parcalar.length >= 2) {
      soyad = parcalar.last;
      ad = parcalar.sublist(0, parcalar.length - 1).join(' ');
    } else {
      ad = yeniIsim;
    }
  }

  int yas;
  int dogumYili; // 1299 - 1900 arası rastgele
  int get takvimYili => dogumYili + yas;

  bool olu;
  int saglik;
  int mutluluk;
  int zeka;
  int para;
  int itibar;

  int zirveZeka;
  int zirveItibar;
  bool hicAsgariUcretliOldu;

  double bakiye; // Akçe cinsinden bakiye
  double yillikGelir;
  double yillikGider;
  String meslek;

  String? meslekZincirId;
  int meslekKademesi;
  int kademedekiYil;

  final Set<String> bayraklar;

  String? esAdi;
  final List<Cocuk> cocuklar;

  List<String> get cocukAdlari => _CocukAdlariListWrapper(this);

  int nesil;

  final Set<String> kullanilanOlaylar;
  final List<String> gunluk;

  final AvatarGenleri genler;
  final Cinsiyet cinsiyet;

  String? olumNedeni;

  Karakter({
    String? isim,
    String? ad,
    String? soyad,
    this.yas = 0,
    int? dogumYili,
    this.olu = false,
    this.olumNedeni,
    this.saglik = 80,
    this.mutluluk = 60,
    this.zeka = 50,
    this.para = 30,
    this.itibar = 50,
    int? zirveZeka,
    int? zirveItibar,
    this.hicAsgariUcretliOldu = false,
    this.bakiye = 20.0, // Başlangıç serveti 20 Akçe
    this.yillikGelir = 0.0,
    this.yillikGider = 0.0,
    this.meslek = 'İşsiz',
    this.meslekZincirId,
    this.meslekKademesi = 0,
    this.kademedekiYil = 0,
    Set<String>? bayraklar,
    this.esAdi,
    List<Cocuk>? cocuklar,
    List<String>? cocukAdlari,
    this.nesil = 1,
    Set<String>? kullanilanOlaylar,
    List<String>? gunluk,
    AvatarGenleri? genler,
    Cinsiyet? cinsiyet,
    Random? rnd,
  })  : dogumYili = dogumYili ?? (1299 + (rnd ?? Random()).nextInt(1900 - 1299 + 1)),
        ad = ad ?? (isim != null ? _isimdenAdGetir(isim) : 'Orhan'),
        soyad = soyad ?? (isim != null ? _isimdenSoyadGetir(isim) : 'Efendi'),
        zirveZeka = zirveZeka ?? zeka,
        zirveItibar = zirveItibar ?? itibar,
        bayraklar = bayraklar ?? {},
        cocuklar = cocuklar ?? _cocukListesiOlustur(cocukAdlari),
        kullanilanOlaylar = kullanilanOlaylar ?? {},
        gunluk = gunluk ?? [],
        cinsiyet = cinsiyet ?? Cinsiyet.erkek,
        genler = genler ?? AvatarGenleri.rastgele(rnd, cinsiyet);

  static String _isimdenAdGetir(String fullIsim) {
    final p = fullIsim.trim().split(' ');
    return p.length >= 2 ? p.sublist(0, p.length - 1).join(' ') : fullIsim;
  }

  static String _isimdenSoyadGetir(String fullIsim) {
    final p = fullIsim.trim().split(' ');
    return p.length >= 2 ? p.last : '';
  }

  static List<Cocuk> _cocukListesiOlustur(List<String>? isimler) {
    if (isimler == null) return [];
    return isimler.map((name) => Cocuk(ad: name, erkekMi: true, ebeveynYasiDogum: 30)).toList();
  }

  void zirveGuncelle() {
    if (zeka > zirveZeka) zirveZeka = zeka;
    if (itibar > zirveItibar) zirveItibar = itibar;
  }

  String meslekUnvaniGetir() {
    if (meslekZincirId != null) {
      final zincir = MeslekDeposu.zincirGetir(meslekZincirId);
      if (zincir != null && meslekKademesi >= 0 && meslekKademesi < zincir.kademeler.length) {
        final kademe = zincir.kademeler[meslekKademesi];
        return '${makeTitleCase(kademe.unvan)} (${zincir.ad})';
      }
    }
    if (yas <= 6) return 'Çocuk';
    if (yas <= 17) return 'Talebe';
    return meslek;
  }

  String padisahVeDonemBilgisiGetir() {
    return PadisahDeposu.donemVePadisahUnvani(takvimYili);
  }

  static String makeTitleCase(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  void statSinirla() {
    saglik = saglik.clamp(0, 100);
    mutluluk = mutluluk.clamp(0, 100);
    zeka = zeka.clamp(0, 100);
    para = para.clamp(0, 100);
    itibar = itibar.clamp(0, 100);
    zirveGuncelle();
  }

  /// Akçe cinsinden parayı formatlar (Örn: 1.500 Akçe)
  static String paraFormatla(double tutar) {
    final isNegative = tutar < 0;
    final absVal = tutar.abs().round();
    final str = absVal.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }

    final formatted = buffer.toString();
    return isNegative ? '-$formatted Akçe' : '$formatted Akçe';
  }

  factory Karakter.fromJson(Map<String, dynamic> json) {
    final cinsiyetStr = json['cinsiyet'] as String?;
    final cinsiyet = cinsiyetStr != null
        ? Cinsiyet.values.firstWhere(
            (e) => e.name == cinsiyetStr,
            orElse: () => Cinsiyet.erkek,
          )
        : null;

    final zekaVal = json['zeka'] as int? ?? 50;
    final itibarVal = json['itibar'] as int? ?? 50;

    final String? adVal = json['ad'] as String?;
    final String? soyadVal = json['soyad'] as String?;
    final String? isimVal = json['isim'] as String?;

    final List<Cocuk> cocuklarList;
    if (json['cocuklar'] != null) {
      cocuklarList = (json['cocuklar'] as List<dynamic>)
          .map((e) => Cocuk.fromJson(e as Map<String, dynamic>))
          .toList();
    } else if (json['cocukAdlari'] != null) {
      cocuklarList = (json['cocukAdlari'] as List<dynamic>)
          .map((e) => Cocuk(ad: e.toString(), erkekMi: true, ebeveynYasiDogum: 30))
          .toList();
    } else {
      cocuklarList = [];
    }

    return Karakter(
      ad: adVal,
      soyad: soyadVal,
      isim: isimVal,
      dogumYili: json['dogumYili'] as int? ?? 1300,
      nesil: json['nesil'] as int? ?? 1,
      yas: json['yas'] as int? ?? 0,
      olu: json['olu'] as bool? ?? false,
      olumNedeni: json['olumNedeni'] as String?,
      saglik: json['saglik'] as int? ?? 80,
      mutluluk: json['mutluluk'] as int? ?? 60,
      zeka: zekaVal,
      para: json['para'] as int? ?? 30,
      itibar: itibarVal,
      zirveZeka: json['zirveZeka'] as int? ?? zekaVal,
      zirveItibar: json['zirveItibar'] as int? ?? itibarVal,
      hicAsgariUcretliOldu: json['hicAsgariUcretliOldu'] as bool? ?? false,
      bakiye: (json['bakiye'] as num?)?.toDouble() ?? 20.0,
      yillikGelir: (json['yillikGelir'] as num?)?.toDouble() ?? 0.0,
      yillikGider: (json['yillikGider'] as num?)?.toDouble() ?? 0.0,
      meslek: json['meslek'] as String? ?? 'İşsiz',
      meslekZincirId: json['meslekZincirId'] as String?,
      meslekKademesi: json['meslekKademesi'] as int? ?? 0,
      kademedekiYil: json['kademedekiYil'] as int? ?? 0,
      bayraklar: (json['bayraklar'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toSet() ??
          {},
      esAdi: json['esAdi'] as String?,
      cocuklar: cocuklarList,
      kullanilanOlaylar: (json['kullanilanOlaylar'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toSet() ??
          {},
      gunluk: (json['gunluk'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      genler: json['genler'] != null
          ? AvatarGenleri.fromJson(json['genler'] as Map<String, dynamic>)
          : AvatarGenleri.rastgele(null, cinsiyet),
      cinsiyet: cinsiyet,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ad': ad,
      'soyad': soyad,
      'isim': isim,
      'dogumYili': dogumYili,
      'takvimYili': takvimYili,
      'nesil': nesil,
      'yas': yas,
      'olu': olu,
      if (olumNedeni != null) 'olumNedeni': olumNedeni,
      'saglik': saglik,
      'mutluluk': mutluluk,
      'zeka': zeka,
      'para': para,
      'itibar': itibar,
      'zirveZeka': zirveZeka,
      'zirveItibar': zirveItibar,
      'hicAsgariUcretliOldu': hicAsgariUcretliOldu,
      'bakiye': bakiye,
      'yillikGelir': yillikGelir,
      'yillikGider': yillikGider,
      'meslek': meslek,
      'meslekZincirId': meslekZincirId,
      'meslekKademesi': meslekKademesi,
      'kademedekiYil': kademedekiYil,
      'bayraklar': bayraklar.toList(),
      'esAdi': esAdi,
      'cocuklar': cocuklar.map((c) => c.toJson()).toList(),
      'cocukAdlari': cocukAdlari,
      'kullanilanOlaylar': kullanilanOlaylar.toList(),
      'gunluk': gunluk,
      'genler': genler.toJson(),
      'cinsiyet': cinsiyet.name,
    };
  }
}

class _CocukAdlariListWrapper extends ListBase<String> {
  final Karakter _karakter;
  _CocukAdlariListWrapper(this._karakter);

  @override
  int get length => _karakter.cocuklar.length;

  @override
  set length(int newLength) {
    _karakter.cocuklar.length = newLength;
  }

  @override
  String operator [](int index) => _karakter.cocuklar[index].ad;

  @override
  void operator []=(int index, String value) {
    final me = _karakter.cocuklar[index];
    _karakter.cocuklar[index] = Cocuk(
      ad: value,
      erkekMi: me.erkekMi,
      ebeveynYasiDogum: me.ebeveynYasiDogum,
    );
  }

  @override
  void add(String element) {
    _karakter.cocuklar.add(Cocuk(
      ad: element,
      erkekMi: true,
      ebeveynYasiDogum: _karakter.yas > 0 ? _karakter.yas : 30,
    ));
  }

  @override
  void addAll(Iterable<String> iterable) {
    for (final element in iterable) {
      add(element);
    }
  }
}
