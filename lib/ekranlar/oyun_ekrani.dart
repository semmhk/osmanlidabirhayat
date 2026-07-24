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

    // Karakter durumunu ve günlüğü güncelle
    _motor.secenekSec(secenek);

    // Eğer vefat ettiyse doğrudan ölüm ekranına geçecek şekilde tetikle
    if (_motor.karakter.olu) {
      setState(() {
        _olumKontrolEtVeKaydet();
      });
      return;
    }

    // Seçenek Sonuç Ferman Modalı Açılır
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Renkler.kagit,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Renkler.altin, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '📜 FERMAN NETİCESİ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Renkler.damga,
                  letterSpacing: 1.1,
                ),
              ),
              const Divider(color: Renkler.altin, height: 20),
              const SizedBox(height: 8),
              Text(
                secenek.sonuc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Renkler.murekkep,
                ),
              ),
              const SizedBox(height: 16),
              // Stat değişim rozetleri
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (secenek.etki.saglik != 0) _statDeltaBadge('❤️ Sağlık', secenek.etki.saglik),
                  if (secenek.etki.mutluluk != 0) _statDeltaBadge('💛 Mutluluk', secenek.etki.mutluluk),
                  if (secenek.etki.zeka != 0) _statDeltaBadge('💙 Zeka', secenek.etki.zeka),
                  if (secenek.etki.itibar != 0) _statDeltaBadge('💜 İtibar', secenek.etki.itibar),
                  if (secenek.etki.para != 0) _statDeltaBadge('💰 Akçe', secenek.etki.para),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Renkler.damga,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _motor.yilYasa();
                      _donemMuziginiGuncelle();
                      _olumKontrolEtVeKaydet();
                    });
                  },
                  child: const Text(
                    'TAMAM (DEVAM ET) 📜',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statDeltaBadge(String label, int val) {
    final isPos = val > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isPos ? Colors.green.shade900 : Colors.red.shade900,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$label ${isPos ? "+$val" : val}',
        style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
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

    if (k.olu) {
      return OlumEkrani(
        karakter: k,
        onYeniHayat: _yeniHayatBaslat,
        onNesilDevamEt: _nesilDevamEt,
        onAnaMenu: _anaMenuyeDon,
      );
    }

    return Scaffold(
      backgroundColor: Renkler.kagitKoyu,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Üst Ferman Alanı (Padişah & Takvim & Karakter & Bakiye)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Renkler.kagitGetirYasaGore(k.yas),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Renkler.altin, width: 2),
                ),
                child: Column(
                  children: [
                    // Dönem, Takvim Yılı, Padişah Portresi ve İkonlar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Renkler.kagitKoyu.withAlpha(20),
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
                                if (padisah.portreGorsel != null) ...[
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Renkler.altin, width: 1.5),
                                      image: DecorationImage(
                                        image: AssetImage(padisah.portreGorsel!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                ],
                                if (padisah.tugraGorsel != null) ...[
                                  Image.asset(
                                    padisah.tugraGorsel!,
                                    height: 32,
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

                    // Karakter İsmi, Cinsiyet ve Bakiye
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              k.cinsiyet == Cinsiyet.erkek ? '🧔' : '🧕',
                              style: const TextStyle(fontSize: 22),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  k.isim,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Renkler.murekkep,
                                  ),
                                ),
                                Text(
                                  '💼 ${k.meslekUnvaniGetir()}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Renkler.murekkepSoluk,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        // Bakiye (Akçe)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade900.withAlpha(40),
                            border: Border.all(color: Colors.green.shade800),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Text('💰 ', style: TextStyle(fontSize: 14)),
                              Text(
                                Karakter.paraFormatla(k.bakiye),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900,
                                  fontSize: 13,
                                ),
                              ),
                            ],
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
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Olay Alanı veya Sakin Geçen Yıl
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Renkler.kagitGetirYasaGore(k.yas),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Renkler.altin, width: 2),
                  ),
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: const BorderSide(color: Renkler.altin, width: 1),
                                      ),
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
              ),

              const SizedBox(height: 12),

              // Yıl İlerlet Butonu
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Renkler.damga,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Renkler.altin, width: 1.5),
                    ),
                  ),
                  onPressed: bekleyenOlay == null ? _yillarIlerle : null,
                  icon: const Icon(Icons.hourglass_bottom, size: 20),
                  label: Text(
                    bekleyenOlay != null ? 'LÜTFEN BİR SEÇENEK KARARLAŞTIRIN' : 'BİR YIL İLERLE ⏳',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statBar(String etiket, int deger, Color renk) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              etiket,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Renkler.murekkep),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (deger.clamp(0, 100)) / 100.0,
                minHeight: 10,
                backgroundColor: Renkler.cizgi,
                color: renk,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '%$deger',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Renkler.murekkep),
            ),
          ),
        ],
      ),
    );
  }
}
