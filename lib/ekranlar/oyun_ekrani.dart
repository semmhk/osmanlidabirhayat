import 'package:flutter/material.dart';
import '../bilesenler/ses_ayari_diyalog.dart';
import '../modeller/olay.dart';
import '../modeller/padisah_deposu.dart';
import '../motor/oyun_motoru.dart';
import '../sabitler/stiller.dart';
import '../servisler/ses_servisi.dart';
import 'faaliyet_ekrani.dart';
import 'gunluk_ekrani.dart';
import 'iliskiler_ekrani.dart';
import 'olum_ekrani.dart';

class OyunEkrani extends StatefulWidget {
  final OyunMotoru motor;

  const OyunEkrani({super.key, required this.motor});

  @override
  State<OyunEkrani> createState() => _OyunEkraniState();
}

class _OyunEkraniState extends State<OyunEkrani> {
  Olay? _mevcutOlay;
  Secenek? _secilenSecenek;
  String? _secimSonucu;

  @override
  void initState() {
    super.initState();
    _olayCek();
    _muzikCal();
  }

  void _muzikCal() {
    final donem = PadisahDeposu.donemBul(widget.motor.karakter.takvimYili);
    if (donem != null) {
      SesServisi().donemMuzigiCal(donem.id);
    }
  }

  void _olayCek() {
    final uygunlar = widget.motor.uygunOlaylariGetir();
    final o = widget.motor.agirlikliOlaySec(uygunlar);
    setState(() {
      _mevcutOlay = o;
      _secilenSecenek = null;
      _secimSonucu = null;
    });
  }

  void _secenekSec(Secenek secenek) {
    if (_secilenSecenek != null) return;

    SesServisi().muhurSesiCal();

    setState(() {
      _secilenSecenek = secenek;
      _secimSonucu = secenek.sonuc;
    });

    OyunMotoru.secenekUygula(widget.motor.karakter, secenek);

    if (_mevcutOlay != null) {
      widget.motor.karakter.gunluk.insert(
        0,
        '${widget.motor.karakter.yas} yaş (${widget.motor.karakter.takvimYili}) — Karar: ${secenek.metin} | Sonuç: ${secenek.sonuc}',
      );
    }

    if (widget.motor.karakter.olu) {
      _olumEkraniAc();
    }
  }

  void _sonrakiYilaGec() {
    if (widget.motor.karakter.olu) {
      _olumEkraniAc();
      return;
    }

    SesServisi().kagitHisirtisiCal();
    widget.motor.yilYasa();
    _muzikCal();

    if (widget.motor.karakter.olu) {
      _olumEkraniAc();
      return;
    }

    _olayCek();
  }

  void _olumEkraniAc() {
    SesServisi().vefatSesiCal();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => OlumEkrani(
          karakter: widget.motor.karakter,
          onYeniHayat: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          onNesilDevamEt: (cocuk) {
            widget.motor.nesilDevamEt(cocuk);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OyunEkrani(motor: widget.motor)),
            );
          },
          onAnaMenu: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          motor: widget.motor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final k = widget.motor.karakter;
    final donem = PadisahDeposu.donemBul(k.takvimYili);
    final padisah = PadisahDeposu.padisahBul(k.takvimYili);

    return Scaffold(
      backgroundColor: Stiller.sepyaArkaplan,
      appBar: AppBar(
        backgroundColor: Stiller.koyuKahve,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Stiller.parlakAltin),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${k.ad} — ${k.takvimYili} (${k.yas} Yaşında)',
          style: Stiller.baslikStili(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Stiller.parlakAltin),
            tooltip: 'Müzik ve Ses Ayarları',
            onPressed: () => SesAyariDiyalog.goster(context),
          ),
          IconButton(
            icon: const Icon(Icons.auto_stories, color: Stiller.parlakAltin),
            tooltip: 'Özel Günlük',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GunlukEkrani(motor: widget.motor),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ÜST BİLGİ ŞERİDİ (64x64 Padişah Portresi + Altın Madalyon Çerçeve)
            if (donem != null && padisah != null) _ustBilgiSeridi(donem, padisah),

            // KARAKTER STATLARI BARI
            _statBarWidget(k),

            // ORTA ALAN: OLAY VE ŞIKLAR
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    if (_mevcutOlay != null) ...[
                      _olayKartiWidget(_mevcutOlay!),
                      const SizedBox(height: 12),
                      _seceneklerListesiWidget(_mevcutOlay!),
                    ] else ...[
                      _sakinYilKartiWidget(),
                    ],
                    if (_secimSonucu != null) ...[
                      const SizedBox(height: 12),
                      _sonucKartiWidget(_secimSonucu!),
                    ],
                  ],
                ),
              ),
            ),

            // ALT EYLEM BARI (Faaliyetler, Aile & Yıl Atla)
            _altEylemBariWidget(),
          ],
        ),
      ),
    );
  }

  Widget _ustBilgiSeridi(Donem donem, Padisah padisah) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Stiller.ortaKahve,
        border: const Border(bottom: BorderSide(color: Stiller.altinSarisi, width: 1.5)),
        boxShadow: Stiller.kartGolge,
      ),
      child: Row(
        children: [
          if (padisah.portreGorsel != null) ...[
            Container(
              width: 64,
              height: 64,
              decoration: Stiller.madalyonCerceve.copyWith(
                image: DecorationImage(
                  image: AssetImage(padisah.portreGorsel!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
          ] else ...[
            Container(
              width: 64,
              height: 64,
              decoration: Stiller.madalyonCerceve,
              child: const Icon(Icons.account_balance, color: Stiller.parlakAltin, size: 32),
            ),
            const SizedBox(width: 12),
          ],

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars, color: Stiller.parlakAltin, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      padisah.isim,
                      style: Stiller.padisahIsimStili(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${donem.ad} (${donem.yilMin}-${donem.yilMax})',
                  style: Stiller.altMetinStili(fontSize: 12, color: Stiller.koyuParsomen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBarWidget(dynamic k) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      color: Stiller.koyuKahve,
      child: Row(
        children: [
          Expanded(child: _statItem(Icons.favorite, 'Sağlık', k.saglik, Colors.redAccent)),
          Expanded(child: _statItem(Icons.sentiment_satisfied_alt, 'Mutluluk', k.mutluluk, Colors.amberAccent)),
          Expanded(child: _statItem(Icons.lightbulb, 'Zeka', k.zeka, Colors.lightBlueAccent)),
          Expanded(child: _statItem(Icons.military_tech, 'İtibar', k.itibar, Colors.purpleAccent)),
          Expanded(child: _statItem(Icons.monetization_on, 'Akçe', k.para, Stiller.parlakAltin, isMoney: true)),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String label, int value, Color color, {bool isMoney = false}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 2),
            Text(
              '$value',
              style: Stiller.baslikStili(fontSize: 12, color: color),
            ),
          ],
        ),
        Text(
          label,
          style: Stiller.altMetinStili(fontSize: 10, color: Stiller.koyuParsomen),
        ),
      ],
    );
  }

  Widget _olayKartiWidget(Olay olay) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: Stiller.altinKartStili,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_edu, color: Stiller.parlakAltin, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Dönem Havadisi',
                  style: Stiller.baslikStili(fontSize: 16),
                ),
              ),
            ],
          ),
          const Divider(color: Stiller.altinSarisi, thickness: 1),
          const SizedBox(height: 8),
          Text(
            olay.metin,
            style: Stiller.govdeStili(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _seceneklerListesiWidget(Olay olay) {
    return Column(
      children: olay.secenekler.map((secenek) {
        final bool kilitli = !OyunMotoru.secenekUygunMu(widget.motor.karakter, secenek);
        final bool secildi = _secilenSecenek == secenek;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: secildi ? Stiller.bordo : (kilitli ? Stiller.koyuKahve : Stiller.ortaKahve),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: kilitli ? Colors.grey.shade700 : Stiller.altinSarisi,
                    width: 1.2,
                  ),
                ),
                elevation: 4,
              ),
              onPressed: (_secilenSecenek != null || kilitli) ? null : () => _secenekSec(secenek),
              child: Row(
                children: [
                  if (kilitli)
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(Icons.lock, color: Colors.grey, size: 16),
                    ),
                  Expanded(
                    child: Text(
                      secenek.metin,
                      style: Stiller.govdeStili(
                        fontSize: 13,
                        color: kilitli ? Colors.grey : Stiller.parsomen,
                        fontWeight: secildi ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _sakinYilKartiWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: Stiller.altinKartStili,
      child: Column(
        children: [
          const Icon(Icons.nature_people, color: Stiller.parlakAltin, size: 36),
          const SizedBox(height: 10),
          Text('Sakin Bir Yıl Geçti', style: Stiller.baslikStili(fontSize: 16)),
          const SizedBox(height: 6),
          Text(
            'Bu yıl hanende ve mahallende kayda değer olağanüstü bir havadis yaşanmadı. Kendi ticaret ve gündelik işlerinle meşgul oldun.',
            textAlign: TextAlign.center,
            style: Stiller.govdeStili(fontSize: 13, color: Stiller.koyuParsomen),
          ),
        ],
      ),
    );
  }

  Widget _sonucKartiWidget(String sonuc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Stiller.koyuKahve,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Stiller.parlakAltin, width: 1.5),
        boxShadow: Stiller.altinGolge,
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Stiller.parlakAltin, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              sonuc,
              style: Stiller.govdeStili(fontSize: 13, color: Stiller.parsomen, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _altEylemBariWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Stiller.koyuKahve,
        border: const Border(top: BorderSide(color: Stiller.altinSarisi, width: 1.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Stiller.parsomen,
                side: const BorderSide(color: Stiller.altinSarisi),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FaaliyetEkrani(motor: widget.motor),
                  ),
                ).then((_) => setState(() {}));
              },
              icon: const Icon(Icons.storefront, color: Stiller.parlakAltin, size: 18),
              label: Text('Faaliyetler', style: Stiller.baslikStili(fontSize: 12, color: Stiller.parsomen)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Stiller.parsomen,
                side: const BorderSide(color: Stiller.altinSarisi),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IliskilerEkrani(motor: widget.motor),
                  ),
                ).then((_) => setState(() {}));
              },
              icon: const Icon(Icons.family_restroom, color: Stiller.parlakAltin, size: 18),
              label: Text('Aile', style: Stiller.baslikStili(fontSize: 12, color: Stiller.parsomen)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Stiller.bordo,
                foregroundColor: Stiller.parsomen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Stiller.parlakAltin),
                ),
                elevation: 4,
              ),
              onPressed: _sonrakiYilaGec,
              icon: const Icon(Icons.calendar_month, color: Stiller.parlakAltin, size: 18),
              label: Text('Yıl Atla', style: Stiller.baslikStili(fontSize: 12, color: Stiller.parsomen)),
            ),
          ),
        ],
      ),
    );
  }
}
