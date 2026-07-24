import 'package:flutter/material.dart';
import '../modeller/cocuk.dart';
import '../modeller/karakter.dart';
import '../modeller/olay.dart';
import '../modeller/padisah_deposu.dart';
import '../motor/oyun_motoru.dart';
import '../sabitler/renkler.dart';
import '../servisler/hayat_kaydi_servisi.dart';
import '../servisler/ses_servisi.dart';
import 'olum_ekrani.dart';

class OyunEkrani extends StatefulWidget {
  final OyunMotoru motor;

  const OyunEkrani({super.key, required this.motor});

  @override
  State<OyunEkrani> createState() => _OyunEkraniState();
}

class _OyunEkraniState extends State<OyunEkrani> {
  late OyunMotoru _motor;

  @override
  void initState() {
    super.initState();
    _motor = widget.motor;
    _donemMuziginiGuncelle();
  }

  void _donemMuziginiGuncelle() {
    final donem = PadisahDeposu.donemBul(_motor.karakter.takvimYili);
    if (donem != null) {
      SesServisi().donemMuzigiCal(donem.id);
    }
  }

  void _olumKontrolEtVeKaydet() {
    if (_motor.karakter.olu) {
      SesServisi().vefatSesiCal();
      HayatKaydiServisi().hayatKaydet(_motor.karakter);
    }
  }

  void _yillarIlerle() {
    SesServisi().kagitHisirtisiCal();
    setState(() {
      _motor.yilYasa();
      _donemMuziginiGuncelle();
      _olumKontrolEtVeKaydet();
    });
  }

  void _secenekSec(Secenek secenek) {
    SesServisi().muhurSesiCal();
    setState(() {
      _motor.secenekSec(secenek);
      _motor.yilYasa();
      _donemMuziginiGuncelle();
      _olumKontrolEtVeKaydet();
    });
  }

  void _yeniHayatBaslat() {
    setState(() {
      _motor.yeniHayatBaslat();
      _motor.yilYasa();
      _donemMuziginiGuncelle();
    });
  }

  void _nesilDevamEt(Cocuk cocuk) {
    setState(() {
      _motor.nesilDevamEt(cocuk);
      _motor.yilYasa();
      _donemMuziginiGuncelle();
    });
  }

  void _anaMenuyeDon() {
    if (_motor.karakter.olu) {
      HayatKaydiServisi().hayatKaydet(_motor.karakter);
    }
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final k = _motor.karakter;
    final padisah = PadisahDeposu.padisahBul(k.takvimYili);
    final bekleyenOlay = _motor.bekleyenOlay;

    return Scaffold(
      backgroundColor: Renkler.kagitKoyu,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Renkler.kagit,
              border: Border.all(color: Renkler.altin, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: k.olu
                ? OlumEkrani(
                    karakter: k,
                    onYeniHayat: _yeniHayatBaslat,
                    onNesilDevamEt: _nesilDevamEt,
                    onAnaMenu: _anaMenuyeDon,
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Üst Bilgi Barı: Takvim Yılı, Padişah, Nesil, Ses ve Ana Menü Butonu
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Renkler.kagitKoyu.withAlpha(40),
                          border: Border.all(color: Renkler.cizgi),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: _anaMenuyeDon,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 6),
                                    child: Icon(
                                      Icons.home_outlined,
                                      size: 20,
                                      color: Renkler.damga,
                                    ),
                                  ),
                                ),
                                Text(
                                  '📅 ${k.takvimYili} (${k.yas} Yaş)',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Renkler.murekkep,
                                  ),
                                ),
                              ],
                            ),
                            if (padisah != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (padisah.tugraGorsel != null) ...[
                                    Image.asset(
                                      padisah.tugraGorsel!,
                                      height: 38,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                  Text(
                                    '👑 ${padisah.isim}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Renkler.damga,
                                    ),
                                  ),
                                ],
                              ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '📜 N:${k.nesil}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Renkler.murekkep,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      SesServisi().sesDurumunuDegistir();
                                    });
                                  },
                                  child: Icon(
                                    SesServisi().sesAcik ? Icons.volume_up : Icons.volume_off,
                                    size: 18,
                                    color: Renkler.murekkep,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Karakter İsmi, Meslek ve Bakiye
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${k.cinsiyet == Cinsiyet.erkek ? "🧔" : "🧕"} ${k.isim}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Renkler.murekkep,
                                ),
                              ),
                              Text(
                                '💼 ${k.meslekUnvaniGetir()}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Renkler.murekkepSoluk,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                            decoration: BoxDecoration(
                              color: Renkler.onay.withAlpha(30),
                              border: Border.all(color: Renkler.onay),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '💰 ${Karakter.paraFormatla(k.bakiye)}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Renkler.onay,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Stat Barları (Sağlık, Mutluluk, Zeka, İtibar)
                      _statBar('Sağlık', k.saglik, Colors.red.shade800),
                      _statBar('Mutluluk', k.mutluluk, Colors.amber.shade900),
                      _statBar('Zeka', k.zeka, Colors.blue.shade900),
                      _statBar('İtibar', k.itibar, Colors.purple.shade900),
                      const SizedBox(height: 16),

                      // Olay Alanı veya Sakin Geçen Yıl
                      Expanded(
                        child: SingleChildScrollView(
                          child: bekleyenOlay != null
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(120),
                                        border: Border.all(color: Renkler.cizgi),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        bekleyenOlay.metin,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.5,
                                          color: Renkler.murekkep,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ...bekleyenOlay.secenekler.map((secenek) {
                                      return Padding(
                                        padding: const EdgeInsets.only(bottom: 8),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Renkler.murekkep,
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                          ),
                                          onPressed: () => _secenekSec(secenek),
                                          child: Text(
                                            secenek.metin,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(100),
                                    border: Border.all(color: Renkler.cizgi),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    k.gunluk.isNotEmpty ? k.gunluk.first : 'Sakin bir yıl geride kaldı.',
                                    style: const TextStyle(fontSize: 13, color: Renkler.murekkep),
                                  ),
                                ),
                        ),
                      ),

                      if (bekleyenOlay == null) ...[
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Renkler.damga,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(44),
                          ),
                          onPressed: _yillarIlerle,
                          child: const Text('BİR YIL İLERLE ⏳'),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _statBar(String etiket, int deger, Color renk) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              etiket,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Renkler.murekkep),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (deger.clamp(0, 100)) / 100.0,
                backgroundColor: Renkler.cizgi.withAlpha(80),
                color: renk,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 28,
            child: Text(
              '$deger',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Renkler.murekkep),
            ),
          ),
        ],
      ),
    );
  }
}
