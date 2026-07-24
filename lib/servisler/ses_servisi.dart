import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SesServisi {
  static final SesServisi _instance = SesServisi._internal();
  factory SesServisi() => _instance;
  SesServisi._internal();

  AudioPlayer? _bgmPlayer;
  AudioPlayer? _sfxPlayer;

  AudioPlayer? get bgmPlayer {
    try {
      _bgmPlayer ??= AudioPlayer();
      return _bgmPlayer;
    } catch (e) {
      debugPrint('AudioPlayer init error: $e');
      return null;
    }
  }

  AudioPlayer? get sfxPlayer {
    try {
      _sfxPlayer ??= AudioPlayer();
      return _sfxPlayer;
    } catch (e) {
      debugPrint('AudioPlayer init error: $e');
      return null;
    }
  }

  bool sesAcik = true;
  String? _mevcutDonemId;
  bool _isTransitioning = false;

  /// Döneme karşılık gelen müzik dosya yolları
  static const Map<String, String> donemMuzikleri = {
    'kurulus': 'muzikler/kurulus.wav',
    'yukselme': 'muzikler/yukselme.wav',
    'duraklama': 'muzikler/duraklama.ogg',
    'gerileme': 'muzikler/gerileme.wav',
    'dagilma': 'muzikler/dagilma.ogg',
  };

  /// Dönemsel müziği başlatır veya dönem değiştiğinde yumuşak geçiş (soft cross-fade) yapar
  Future<void> donemMuzigiCal(String donemId) async {
    if (!sesAcik || _isTransitioning) return;
    if (_mevcutDonemId == donemId) return; // Aynı dönem müziği çalıyorsa devam et

    final dosyaYolu = donemMuzikleri[donemId];
    if (dosyaYolu == null) return;

    _isTransitioning = true;
    _mevcutDonemId = donemId;

    final player = bgmPlayer;
    if (player == null) {
      _isTransitioning = false;
      return;
    }

    try {
      // 1. Mevcut parça çalıyorsa sesini kısarak kapat (fade-out)
      for (double v = 1.0; v >= 0.0; v -= 0.2) {
        await player.setVolume(v.clamp(0.0, 1.0));
        await Future.delayed(const Duration(milliseconds: 50));
      }
      await player.stop();

      // 2. Yeni dönem parçasına geç
      await player.setReleaseMode(ReleaseMode.loop);
      await player.play(AssetSource(dosyaYolu));

      // 3. Sesi kademeli olarak aç (fade-in)
      for (double v = 0.0; v <= 1.0; v += 0.2) {
        await player.setVolume(v.clamp(0.0, 1.0));
        await Future.delayed(const Duration(milliseconds: 50));
      }
    } catch (_) {
      // Platform channel hatasında sessizce devam et (unit test ortamlarında)
    } finally {
      _isTransitioning = false;
    }
  }

  /// Karar verildiğinde tok mühür basma sesi
  Future<void> muhurSesiCal() async {
    if (!sesAcik) return;
    final player = sfxPlayer;
    if (player == null) return;
    try {
      await player.play(AssetSource('sesler/muhur_damga.wav'));
    } catch (_) {}
  }

  /// Takvim yaprağı / yıl atlandığında parşömen kağıdı sesi
  Future<void> kagitHisirtisiCal() async {
    if (!sesAcik) return;
    final player = sfxPlayer;
    if (player == null) return;
    try {
      await player.play(AssetSource('sesler/kagit_hisirtisi.wav'));
    } catch (_) {}
  }

  /// Karakter öldüğünde ağır kös / vefat davulu vuruşu
  Future<void> vefatSesiCal() async {
    if (!sesAcik) return;
    final player = sfxPlayer;
    if (player == null) return;
    try {
      await player.play(AssetSource('sesler/vefat_davul.wav'));
    } catch (_) {}
  }

  /// Sesleri açma/kapatma (Mute toggle)
  void sesDurumunuDegistir() {
    sesAcik = !sesAcik;
    if (!sesAcik) {
      try {
        _bgmPlayer?.stop();
        _sfxPlayer?.stop();
      } catch (_) {}
      _mevcutDonemId = null;
    }
  }

  /// Tüm müzik ve efektleri durdurur
  Future<void> tumSesleriDurdur() async {
    try {
      await _bgmPlayer?.stop();
      await _sfxPlayer?.stop();
      _mevcutDonemId = null;
    } catch (_) {}
  }
}
