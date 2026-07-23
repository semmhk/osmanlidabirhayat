class Cocuk {
  final String ad;
  final bool erkekMi;
  final int ebeveynYasiDogum;

  Cocuk({
    required this.ad,
    required this.erkekMi,
    required this.ebeveynYasiDogum,
  });

  /// Ebeveyn vefat ettiğindeki çocuğun güncel yaşını hesaplar
  int guncelYasGetir(int ebeveynVefatYasi) {
    final yas = ebeveynVefatYasi - ebeveynYasiDogum;
    return yas < 0 ? 0 : yas;
  }

  factory Cocuk.fromJson(Map<String, dynamic> json) {
    return Cocuk(
      ad: json['ad'] as String? ?? 'Çocuk',
      erkekMi: json['erkekMi'] as bool? ?? true,
      ebeveynYasiDogum: json['ebeveynYasiDogum'] as int? ?? 30,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ad': ad,
      'erkekMi': erkekMi,
      'ebeveynYasiDogum': ebeveynYasiDogum,
    };
  }
}
