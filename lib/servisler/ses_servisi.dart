import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

enum MuzikModu { kapali, aralikli, surekli }

class SesServisi with WidgetsBindingObserver {
  static final SesServisi _instance = SesServisi._internal();
  factory SesServisi() => _instance;

  SesServisi._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  AudioPlayer? _bgmPlayer;
  AudioPlayer? _sfxPlayer;
  Timer? _aralikTimer;

  double bgmSesSeviyesi = 0.35;
  double sfxSesSeviyesi = 0.75;
  MuzikModu muzikModu = MuzikModu.aralikli;

  AudioPlayer? get bgmPlayer {
    try {
      if (_bgmPlayer == null) {
        _bgmPlayer = AudioPlayer();
        try {
          _bgmPlayer!.setAudioContext(AudioContext(
            android: AudioContextAndroid(
              stayAwake: true,
              contentType: AndroidContentType.music,
              usageType: AndroidUsageType.media,
              audioFocus: AndroidAudioFocus.gain,
            ),
          ));
        } catch (_) {}
        _bgmPlayer!.onPlayerComplete.listen((_) {
          _parcaBitti();
        });
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
        try {
          _sfxPlayer!.setAudioContext(AudioContext(
            android: AudioContextAndroid(
              stayAwake: false,
              contentType: AndroidContentType.sonification,
              usageType: AndroidUsageType.assistanceSonification,
              audioFocus: AndroidAudioFocus.none,
            ),
          ));
        } catch (_) {}
      }
      return _sfxPlayer;
    } catch (e) {
      debugPrint('AudioPlayer init error: $e');
      return null;
    }
  }

  bool get sesAcik => muzikModu != MuzikModu.kapali;
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

  static const Map<String, String> donemMuzikleri = {
    'kurulus': 'muzikler/kurulus.wav',
    'yukselme': 'muzikler/yukselme.wav',
    'duraklama': 'muzikler/duraklama.ogg',
    'gerileme': 'muzikler/gerileme.wav',
    'dagilma': 'muzikler/dagilma.ogg',
  };

  void muzikModunuDegistir(MuzikModu yeniMod) {
    muzikModu = yeniMod;
    _aralikTimer?.cancel();

    try {
      if (muzikModu == MuzikModu.kapali) {
        tumSesleriDurdur();
      } else if (muzikModu == MuzikModu.surekli) {
        bgmPlayer?.setReleaseMode(ReleaseMode.loop);
        if (_mevcutDonemId != null) {
          donemMuzigiCal(_mevcutDonemId!);
        }
      } else if (muzikModu == MuzikModu.aralikli) {
        bgmPlayer?.setReleaseMode(ReleaseMode.stop);
        if (_mevcutDonemId != null) {
          donemMuzigiCal(_mevcutDonemId!);
        }
      }
    } catch (_) {}
  }

  void _parcaBitti() {
    if (muzikModu == MuzikModu.aralikli && _mevcutDonemId != null) {
      final int beklemeSaniye = 45 + Random().nextInt(30);
      _aralikTimer?.cancel();
      _aralikTimer = Timer(Duration(seconds: beklemeSaniye), () {
        if (muzikModu == MuzikModu.aralikli && _mevcutDonemId != null) {
          _parcayiYumusakBaslat(_mevcutDonemId!);
        }
      });
    }
  }

  Future<void> _parcayiYumusakBaslat(String donemId) async {
    final dosyaYolu = donemId == 'anamenu' ? 'muzikler/kurulus.wav' : donemMuzikleri[donemId];
    if (dosyaYolu == null || !sesAcik) return;
    final player = bgmPlayer;
    if (player == null) return;

    try {
      await player.setReleaseMode(muzikModu == MuzikModu.surekli ? ReleaseMode.loop : ReleaseMode.stop);
      await player.setVolume(0.0);
      await player.play(AssetSource(dosyaYolu));

      final targetVol = donemId == 'anamenu' ? 0.25 : bgmSesSeviyesi;
      for (double v = 0.0; v <= targetVol; v += 0.05) {
        await player.setVolume(v.clamp(0.0, 1.0));
        await Future.delayed(const Duration(milliseconds: 50));
      }
    } catch (_) {}
  }

  Future<void> anaMenuMuzigiCal() async {
    if (!sesAcik || _isTransitioning) return;
    if (_mevcutDonemId == 'anamenu' && bgmPlayer?.state == PlayerState.playing) return;

    _isTransitioning = true;
    _mevcutDonemId = 'anamenu';
    _aralikTimer?.cancel();

    try {
      if (bgmPlayer?.state == PlayerState.playing) {
        await bgmPlayer?.stop();
      }
      await _parcayiYumusakBaslat('anamenu');
    } catch (_) {
    } finally {
      _isTransitioning = false;
    }
  }

  Future<void> donemMuzigiCal(String donemId) async {
    if (!sesAcik || _isTransitioning) return;
    if (_mevcutDonemId == donemId && bgmPlayer?.state == PlayerState.playing) return;

    final dosyaYolu = donemMuzikleri[donemId];
    if (dosyaYolu == null) return;

    _isTransitioning = true;
    _mevcutDonemId = donemId;
    _aralikTimer?.cancel();

    try {
      if (bgmPlayer?.state == PlayerState.playing) {
        await bgmPlayer?.stop();
      }
      await _parcayiYumusakBaslat(donemId);
    } catch (_) {
    } finally {
      _isTransitioning = false;
    }
  }

  Future<void> _efektVeDuckingCal(String sfxPath) async {
    if (!sesAcik) return;
    final sPlayer = sfxPlayer;
    final bPlayer = bgmPlayer;
    if (sPlayer == null) return;

    try {
      if (bPlayer != null && bPlayer.state == PlayerState.playing) {
        await bPlayer.setVolume(0.15);
      }

      await sPlayer.stop();
      await sPlayer.setVolume(sfxSesSeviyesi);
      await sPlayer.play(AssetSource(sfxPath));

      Timer(const Duration(milliseconds: 400), () async {
        if (bPlayer != null && bPlayer.state == PlayerState.playing) {
          await bPlayer.setVolume(bgmSesSeviyesi);
        }
      });
    } catch (_) {}
  }

  Future<void> muhurSesiCal() async {
    await _efektVeDuckingCal('sesler/muhur_damga.wav');
  }

  Future<void> kagitHisirtisiCal() async {
    await _efektVeDuckingCal('sesler/kagit_hisirtisi.wav');
  }

  Future<void> vefatSesiCal() async {
    await _efektVeDuckingCal('sesler/vefat_davul.wav');
  }

  void sesDurumunuDegistir() {
    if (muzikModu == MuzikModu.kapali) {
      muzikModunuDegistir(MuzikModu.aralikli);
    } else {
      muzikModunuDegistir(MuzikModu.kapali);
    }
  }

  Future<void> tumSesleriDurdur() async {
    _aralikTimer?.cancel();
    try {
      await _bgmPlayer?.stop();
      await _sfxPlayer?.stop();
      _mevcutDonemId = null;
    } catch (_) {}
  }
}
