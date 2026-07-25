import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

class SesServisi with WidgetsBindingObserver {
  static final SesServisi _instance = SesServisi._internal();
  factory SesServisi() => _instance;

  SesServisi._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  AudioPlayer? _bgmPlayer;
  AudioPlayer? _sfxPlayer;

  double bgmSesSeviyesi = 0.35; // Arka plan müziği %35
  double sfxSesSeviyesi = 0.75; // Ses efektleri %75

  AudioPlayer? get bgmPlayer {
    try {
      if (_bgmPlayer == null) {
        _bgmPlayer = AudioPlayer();
        _bgmPlayer!.setAudioContext(AudioContext(
          android: AudioContextAndroid(
            stayAwake: true,
            contentType: AndroidContentType.music,
            usageType: AndroidUsageType.media,
            audioFocus: AndroidAudioFocus.gain,
          ),
        ));
      }
      return _bgmPlayer;
    } catch (e) {
      debugPrint('AudioPlayer init error: $e');
      return null;
    }
  }

  AudioPlayer? get sfxPlayer {
    try {
      if (_sfxPlayer == null) {
        _sfxPlayer = AudioPlayer();
        _sfxPlayer!.setAudioContext(AudioContext(
          android: AudioContextAndroid(
            stayAwake: false,
            contentType: AndroidContentType.sonification,
            usageType: AndroidUsageType.assistanceSonification,
            audioFocus: AndroidAudioFocus.none,
          ),
        ));
      }
      return _sfxPlayer;
    } catch (e) {
      debugPrint('AudioPlayer init error: $e');
      return null;
    }
  }

  bool sesAcik = true;
  String? _mevcutDonemId;
  bool _isTransitioning = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _bgmPlayer?.pause();
    } else if (state == AppLifecycleState.resumed && sesAcik) {
      _bgmPlayer?.resume();
    }
  }

  /// Döneme karşılık gelen müzik dosya yolları
  static const Map<String, String> donemMuzikleri = {
    'kurulus': 'muzikler/kurulus.wav',
    'yukselme': 'muzikler/yukselme.wav',
    'duraklama': 'muzikler/duraklama.ogg',
    'gerileme': 'muzikler/gerileme.wav',
    'dagilma': 'muzikler/dagilma.ogg',
  };

  /// Ana menüde çalacak hafif tema müziği (%25 seviye)
  Future<void> anaMenuMuzigiCal() async {
    if (!sesAcik || _isTransitioning) return;
    if (_mevcutDonemId == 'anamenu' && bgmPlayer?.state == PlayerState.playing) return;

    _isTransitioning = true;
    _mevcutDonemId = 'anamenu';
    final player = bgmPlayer;
    if (player == null) {
      _isTransitioning = false;
      return;
    }

    try {
      if (player.state == PlayerState.playing) {
        for (double v = bgmSesSeviyesi; v >= 0.0; v -= 0.1) {
          await player.setVolume(v.clamp(0.0, 1.0));
          await Future.delayed(const Duration(milliseconds: 20));
        }
        await player.stop();
      }

      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(0.25); // Ana menüde %25 tatlı ses
      await player.play(AssetSource('muzikler/kurulus.wav'));
    } catch (_) {
    } finally {
      _isTransitioning = false;
    }
  }

  /// Dönemsel müziği başlatır veya dönem değiştiğinde yumuşak geçiş (soft cross-fade) yapar
  Future<void> donemMuzigiCal(String donemId) async {
    if (!sesAcik || _isTransitioning) return;
    if (_mevcutDonemId == donemId && bgmPlayer?.state == PlayerState.playing) return;

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
      if (player.state == PlayerState.playing) {
        for (double v = bgmSesSeviyesi; v >= 0.0; v -= 0.1) {
          await player.setVolume(v.clamp(0.0, 1.0));
          await Future.delayed(const Duration(milliseconds: 20));
        }
        await player.stop();
      }

      // 2. Yeni dönem parçasına geç (%35 varsayılan seviye)
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(bgmSesSeviyesi);
      await player.play(AssetSource(dosyaYolu));
    } catch (_) {
      // Platform channel hatasında sessizce devam et
    } finally {
      _isTransitioning = false;
    }
  }

  /// Audio Ducking ile ses efekti çalma (efekt anında BGM sesini %15'e kısar, sonra %35'e döndürür)
  Future<void> _efektVeDuckingCal(String sfxPath) async {
    if (!sesAcik) return;
    final sPlayer = sfxPlayer;
    final bPlayer = bgmPlayer;
    if (sPlayer == null) return;

    try {
      // Ducking: Müziği geçici olarak %15 seviyesine kıs
      if (bPlayer != null && bPlayer.state == PlayerState.playing) {
        await bPlayer.setVolume(0.15);
      }

      await sPlayer.stop();
      await sPlayer.setVolume(sfxSesSeviyesi);
      await sPlayer.play(AssetSource(sfxPath));

      // Efekt başladıktan 400ms sonra müziği eski seviyesine (%35) yumuşakça döndür
      Timer(const Duration(milliseconds: 400), () async {
        if (bPlayer != null && bPlayer.state == PlayerState.playing) {
          await bPlayer.setVolume(bgmSesSeviyesi);
        }
      });
    } catch (_) {}
  }

  /// Karar verildiğinde tok mühür basma sesi
  Future<void> muhurSesiCal() async {
    await _efektVeDuckingCal('sesler/muhur_damga.wav');
  }

  /// Takvim yaprağı / yıl atlandığında parşömen kağıdı sesi
  Future<void> kagitHisirtisiCal() async {
    await _efektVeDuckingCal('sesler/kagit_hisirtisi.wav');
  }

  /// Karakter öldüğünde ağır kös / vefat davulu vuruşu
  Future<void> vefatSesiCal() async {
    await _efektVeDuckingCal('sesler/vefat_davul.wav');
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
