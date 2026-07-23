class Kosul {
  final String stat;
  final int min;

  const Kosul({
    required this.stat,
    required this.min,
  });

  factory Kosul.fromJson(Map<String, dynamic> json) {
    return Kosul(
      stat: json['stat'] as String,
      min: (json['min'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stat': stat,
      'min': min,
    };
  }
}

class Etki {
  final int saglik;
  final int mutluluk;
  final int zeka;
  final int para;
  final int itibar;

  const Etki({
    this.saglik = 0,
    this.mutluluk = 0,
    this.zeka = 0,
    this.para = 0,
    this.itibar = 0,
  });

  factory Etki.fromJson(Map<String, dynamic> json) {
    return Etki(
      saglik: (json['saglik'] as num?)?.toInt() ?? 0,
      mutluluk: (json['mutluluk'] as num?)?.toInt() ?? 0,
      zeka: (json['zeka'] as num?)?.toInt() ?? 0,
      para: (json['para'] as num?)?.toInt() ?? 0,
      itibar: (json['itibar'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (saglik != 0) map['saglik'] = saglik;
    if (mutluluk != 0) map['mutluluk'] = mutluluk;
    if (zeka != 0) map['zeka'] = zeka;
    if (para != 0) map['para'] = para;
    if (itibar != 0) map['itibar'] = itibar;
    return map;
  }

  Map<String, int> toMap() {
    return {
      if (saglik != 0) 'saglik': saglik,
      if (mutluluk != 0) 'mutluluk': mutluluk,
      if (zeka != 0) 'zeka': zeka,
      if (para != 0) 'para': para,
      if (itibar != 0) 'itibar': itibar,
    };
  }
}

class Secenek {
  final String metin;
  final Etki etki;
  final bool sansGerekli;
  final String sonuc;
  final String? meslekAtama; // Opsiyonel meslek zinciri atanması ("ahilik", "ilmiye" vb.)
  final String? bayrakEkle;  // Seçildiğinde karaktere eklenecek tekil bayrak ("evli", "cocuklu" vb.)
  final List<String>? bayraklarEkle; // Seçildiğinde karaktere eklenecek çoklu bayraklar
  final String? bayrakKaldir; // Seçildiğinde karakterden kaldırılacak bayrak ("evli" vb.)
  final int olumculSans; // Seçildiğinde ani/doğrudan ölüm ihtimali (%1-100, varsayılan 0)
  final String? olumNedeni; // Ölüm gerçekleştiğinde özete yazılacak spesifik vefat nedeni

  const Secenek({
    required this.metin,
    required this.etki,
    this.sansGerekli = false,
    required this.sonuc,
    this.meslekAtama,
    this.bayrakEkle,
    this.bayraklarEkle,
    this.bayrakKaldir,
    this.olumculSans = 0,
    this.olumNedeni,
  });

  factory Secenek.fromJson(Map<String, dynamic> json) {
    return Secenek(
      metin: json['metin'] as String,
      etki: Etki.fromJson((json['etki'] as Map<String, dynamic>?) ?? {}),
      sansGerekli: json['sans_gerekli'] as bool? ?? false,
      sonuc: json['sonuc'] as String,
      meslekAtama: json['meslek_atama'] as String?,
      bayrakEkle: json['bayrak_ekle'] as String?,
      bayraklarEkle: (json['bayraklar_ekle'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      bayrakKaldir: json['bayrak_kaldir'] as String?,
      olumculSans: (json['olumcul_sans'] as num?)?.toInt() ?? 0,
      olumNedeni: json['olum_nedeni'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'metin': metin,
      'etki': etki.toJson(),
      'sans_gerekli': sansGerekli,
      'sonuc': sonuc,
    };
    if (meslekAtama != null) map['meslek_atama'] = meslekAtama;
    if (bayrakEkle != null) map['bayrak_ekle'] = bayrakEkle;
    if (bayraklarEkle != null) map['bayraklar_ekle'] = bayraklarEkle;
    if (bayrakKaldir != null) map['bayrak_kaldir'] = bayrakKaldir;
    if (olumculSans > 0) map['olumcul_sans'] = olumculSans;
    if (olumNedeni != null) map['olum_nedeni'] = olumNedeni;
    return map;
  }
}

class Olay {
  final String id;
  final int yasMin;
  final int yasMax;
  final int? tarihYilMin; // Tarihi Zaman Çizelgesi Min Yılı (Örn: 1299)
  final int? tarihYilMax; // Tarihi Zaman Çizelgesi Max Yılı (Örn: 1453)
  final bool tekSeferlik;
  final Kosul? kosul;
  final String? gerekliBayrak;
  final List<String>? gerekliBayraklar;
  final String? engelBayrak;
  final String metin;
  final List<Secenek> secenekler;
  final bool oncelikli;

  const Olay({
    required this.id,
    required this.yasMin,
    required this.yasMax,
    this.tarihYilMin,
    this.tarihYilMax,
    this.tekSeferlik = false,
    this.kosul,
    this.gerekliBayrak,
    this.gerekliBayraklar,
    this.engelBayrak,
    required this.metin,
    required this.secenekler,
    this.oncelikli = false,
  });

  factory Olay.fromJson(Map<String, dynamic> json) {
    return Olay(
      id: json['id'] as String,
      yasMin: (json['yas_min'] as num).toInt(),
      yasMax: (json['yas_max'] as num).toInt(),
      tarihYilMin: (json['tarih_yil_min'] as num?)?.toInt(),
      tarihYilMax: (json['tarih_yil_max'] as num?)?.toInt(),
      tekSeferlik: json['tek_seferlik'] as bool? ?? false,
      kosul: json['kosul'] != null ? Kosul.fromJson(json['kosul'] as Map<String, dynamic>) : null,
      gerekliBayrak: json['gerekli_bayrak'] as String?,
      gerekliBayraklar: (json['gerekli_bayraklar'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      engelBayrak: json['engel_bayrak'] as String?,
      metin: json['metin'] as String,
      secenekler: (json['secenekler'] as List<dynamic>)
          .map((e) => Secenek.fromJson(e as Map<String, dynamic>))
          .toList(),
      oncelikli: json['oncelikli'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'yas_min': yasMin,
      'yas_max': yasMax,
      if (tarihYilMin != null) 'tarih_yil_min': tarihYilMin,
      if (tarihYilMax != null) 'tarih_yil_max': tarihYilMax,
      'tek_seferlik': tekSeferlik,
      if (kosul != null) 'kosul': kosul!.toJson(),
      if (gerekliBayrak != null) 'gerekli_bayrak': gerekliBayrak,
      if (gerekliBayraklar != null) 'gerekli_bayraklar': gerekliBayraklar,
      if (engelBayrak != null) 'engel_bayrak': engelBayrak,
      if (oncelikli) 'oncelikli': oncelikli,
      'metin': metin,
      'secenekler': secenekler.map((e) => e.toJson()).toList(),
    };
  }
}
