import 'package:hive_flutter/hive_flutter.dart';
import '../modeller/hayat_kaydi.dart';
import '../modeller/karakter.dart';

class HayatKaydiServisi {
  static const String boxName = 'hayat_kaydi';
  static final HayatKaydiServisi _instance = HayatKaydiServisi._internal();
  factory HayatKaydiServisi() => _instance;
  HayatKaydiServisi._internal();

  Box<String>? _box;

  Future<Box<String>?> get box async {
    try {
      if (_box != null && _box!.isOpen) return _box!;
      _box = await Hive.openBox<String>(boxName);
      return _box!;
    } catch (_) {
      return null;
    }
  }

  /// Karakter vefat ettiğinde geçmiş hayat kaydını kaydeder
  Future<void> hayatKaydet(Karakter karakter, {String? olumNedeni}) async {
    try {
      final kayit = HayatKaydi.karakterden(karakter, olumNedeniOverride: olumNedeni);
      final b = await box;
      if (b != null) {
        await b.put(kayit.id, kayit.toJson());
      }
    } catch (_) {}
  }

  /// Tüm geçmiş hayat kayıtlarını en son kaydedilen üstte olacak şekilde getirir
  Future<List<HayatKaydi>> tumKayitlariGetir() async {
    try {
      final b = await box;
      if (b == null) return [];
      final list = b.values.map((jsonStr) => HayatKaydi.fromJson(jsonStr)).toList();
      list.sort((a, b) => b.tarihSaat.compareTo(a.tarihSaat));
      return list;
    } catch (_) {
      return [];
    }
  }

  /// Tüm kayıtları temizler
  Future<void> tumKayitlariTemizle() async {
    try {
      final b = await box;
      if (b != null) {
        await b.clear();
      }
    } catch (_) {}
  }
}
