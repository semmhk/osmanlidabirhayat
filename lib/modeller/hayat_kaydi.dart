import 'dart:convert';
import 'karakter.dart';

class HayatKaydi {
  final String id;
  final String isim;
  final Cinsiyet cinsiyet;
  final int dogumYili;
  final int olumYili;
  final int yas;
  final String unvan;
  final double bakiye;
  final String olumNedeni;
  final int nesil;
  final String padisahDonemleri;
  final List<String> kazanilanBasarimlar;
  final DateTime tarihSaat;

  HayatKaydi({
    required this.id,
    required this.isim,
    required this.cinsiyet,
    required this.dogumYili,
    required this.olumYili,
    required this.yas,
    required this.unvan,
    required this.bakiye,
    required this.olumNedeni,
    required this.nesil,
    required this.padisahDonemleri,
    required this.kazanilanBasarimlar,
    required this.tarihSaat,
  });

  /// Karakter nesnesinden geçmiş hayat kaydı oluşturur
  factory HayatKaydi.karakterden(Karakter k, {String? olumNedeniOverride}) {
    return HayatKaydi(
      id: '${k.dogumYili}_${k.takvimYili}_${DateTime.now().millisecondsSinceEpoch}',
      isim: k.isim,
      cinsiyet: k.cinsiyet,
      dogumYili: k.dogumYili,
      olumYili: k.takvimYili,
      yas: k.yas,
      unvan: k.meslekUnvaniGetir(),
      bakiye: k.bakiye,
      olumNedeni: olumNedeniOverride ?? k.olumNedeni ?? (k.saglik <= 0 ? 'Hastalık ve Zayıflık' : 'Yaşlılığa Bağlı Doğal Ölüm'),
      nesil: k.nesil,
      padisahDonemleri: '📅 ${k.dogumYili} - ${k.takvimYili}',
      kazanilanBasarimlar: List<String>.from(k.kazanilanBasarimlar),
      tarihSaat: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isim': isim,
      'cinsiyet': cinsiyet.name,
      'dogumYili': dogumYili,
      'olumYili': olumYili,
      'yas': yas,
      'unvan': unvan,
      'bakiye': bakiye,
      'olumNedeni': olumNedeni,
      'nesil': nesil,
      'padisahDonemleri': padisahDonemleri,
      'kazanilanBasarimlar': kazanilanBasarimlar,
      'tarihSaat': tarihSaat.toIso8601String(),
    };
  }

  factory HayatKaydi.fromMap(Map<String, dynamic> map) {
    return HayatKaydi(
      id: map['id'] ?? '',
      isim: map['isim'] ?? 'Bilinmeyen Karakter',
      cinsiyet: map['cinsiyet'] == 'kadin' ? Cinsiyet.kadin : Cinsiyet.erkek,
      dogumYili: map['dogumYili'] ?? 1300,
      olumYili: map['olumYili'] ?? 1360,
      yas: map['yas'] ?? 60,
      unvan: map['unvan'] ?? 'Vasıfsız',
      bakiye: (map['bakiye'] as num?)?.toDouble() ?? 0.0,
      olumNedeni: map['olumNedeni'] ?? 'Eceliyle Vefat',
      nesil: map['nesil'] ?? 1,
      padisahDonemleri: map['padisahDonemleri'] ?? '',
      kazanilanBasarimlar: List<String>.from(map['kazanilanBasarimlar'] ?? []),
      tarihSaat: DateTime.tryParse(map['tarihSaat'] ?? '') ?? DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());
  factory HayatKaydi.fromJson(String source) => HayatKaydi.fromMap(jsonDecode(source));
}
