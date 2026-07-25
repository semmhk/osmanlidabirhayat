import 'package:flutter/material.dart';
import '../bilesenler/ses_ayari_diyalog.dart';
import '../motor/olay_yukleyici.dart';
import '../motor/oyun_motoru.dart';
import '../sabitler/stiller.dart';
import '../servisler/ses_servisi.dart';
import 'basarimlar_ekrani.dart';
import 'gecmis_hayatlar_ekrani.dart';
import 'oyun_ekrani.dart';

class AnaMenuEkrani extends StatefulWidget {
  const AnaMenuEkrani({super.key});

  @override
  State<AnaMenuEkrani> createState() => _AnaMenuEkraniState();
}

class _AnaMenuEkraniState extends State<AnaMenuEkrani> {
  bool _yukleniyor = false;

  @override
  void initState() {
    super.initState();
    SesServisi().anaMenuMuzigiCal();
  }

  Future<void> _yeniHayatBaslat() async {
    setState(() {
      _yukleniyor = true;
    });

    final yukleyici = OlayYukleyici();
    final olaylar = await yukleyici.tumunuYukle();
    final motor = OyunMotoru(tumOlaylar: olaylar);
    motor.yilYasa();

    if (!mounted) return;
    setState(() {
      _yukleniyor = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OyunEkrani(motor: motor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Stiller.sepyaArkaplan,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/arkaplan/parsomen_doku.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.12),
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 480),
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: Stiller.altinKartStili,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ayarlar butonu (Sağ üst)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.tune, color: Stiller.parlakAltin),
                          tooltip: 'Müzik ve Ses Ayarları',
                          onPressed: () => SesAyariDiyalog.goster(context),
                        ),
                      ),

                      // Logo & Tuğra Görseli
                      Image.asset(
                        'assets/logo.png',
                        height: 110,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.account_balance,
                          size: 64,
                          color: Stiller.parlakAltin,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Başlık ve Alt Başlık
                      Text(
                        "OSMANLI'DA BİR HAYAT",
                        textAlign: TextAlign.center,
                        style: Stiller.baslikStili(fontSize: 22),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Tarihi Hayat Simülasyonu",
                        style: Stiller.altMetinStili(fontSize: 13),
                      ),
                      const SizedBox(height: 24),

                      // Yeni Hayat Başlat Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Stiller.bordo,
                            foregroundColor: Stiller.parsomen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Stiller.parlakAltin, width: 1.5),
                            ),
                            elevation: 6,
                          ),
                          onPressed: _yukleniyor ? null : _yeniHayatBaslat,
                          icon: const Icon(Icons.history_edu, color: Stiller.parlakAltin),
                          label: _yukleniyor
                              ? const CircularProgressIndicator(color: Stiller.parlakAltin)
                              : Text(
                                  'YENİ HAYAT BAŞLAT',
                                  style: Stiller.baslikStili(fontSize: 15, color: Stiller.parsomen),
                                ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Geçmiş Hayatlar (Şecere) Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Stiller.parsomen,
                            side: const BorderSide(color: Stiller.altinSarisi, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GecmisHayatlarEkrani(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.auto_stories, color: Stiller.parlakAltin, size: 20),
                          label: Text(
                            'GEÇMİŞ HAYATLAR (ŞECERE)',
                            style: Stiller.baslikStili(fontSize: 13, color: Stiller.parsomen),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Nişanlar ve Başarımlar Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Stiller.parsomen,
                            side: const BorderSide(color: Stiller.altinSarisi, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BasarimlarEkrani(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.workspace_premium, color: Stiller.parlakAltin, size: 20),
                          label: Text(
                            'NİŞAN VE BAŞARIMLAR',
                            style: Stiller.baslikStili(fontSize: 13, color: Stiller.parsomen),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      Text(
                        "© 1299 - 1922 Osmanlı İmparatorluğu Dönemi",
                        style: Stiller.altMetinStili(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
