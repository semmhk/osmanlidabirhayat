class Basarim {
  final String id;
  final String baslik;
  final String aciklama;
  final String ikon;
  final bool kazanildi;
  final String? kazanmaTarihi;

  const Basarim({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.ikon,
    this.kazanildi = false,
    this.kazanmaTarihi,
  });

  Basarim copyWith({
    bool? kazanildi,
    String? kazanmaTarihi,
  }) {
    return Basarim(
      id: id,
      baslik: baslik,
      aciklama: aciklama,
      ikon: ikon,
      kazanildi: kazanildi ?? this.kazanildi,
      kazanmaTarihi: kazanmaTarihi ?? this.kazanmaTarihi,
    );
  }

  factory Basarim.fromJson(Map<String, dynamic> json, {bool kazanildi = false, String? kazanmaTarihi}) {
    return Basarim(
      id: json['id'] as String,
      baslik: json['baslik'] as String,
      aciklama: json['aciklama'] as String,
      ikon: json['ikon'] as String? ?? '🏆',
      kazanildi: kazanildi,
      kazanmaTarihi: kazanmaTarihi,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'baslik': baslik,
      'aciklama': aciklama,
      'ikon': ikon,
      'kazanildi': kazanildi,
      'kazanmaTarihi': kazanmaTarihi,
    };
  }
}
