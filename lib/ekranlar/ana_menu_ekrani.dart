import 'package:flutter/material.dart';
import '../motor/olay_yukleyici.dart';
import '../motor/oyun_motoru.dart';
import '../sabitler/renkler.dart';
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
      backgroundColor: Renkler.kagitKoyu,
      body: Stack(
        children: [
          // İnce Parşömen Dokusu Arka Plan Bindirmesi
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
                  decoration: BoxDecoration(
                    color: Renkler.kagit,
                    border: Border.all(color: Renkler.altin, width: 3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(100),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo & Tuğra Görseli
                      Image.asset(
                        'assets/logo.png',
                        height: 110,
                        errorBuilder: (context, error, stackTrace) => const Text(
                          '👑',
                          style: TextStyle(fontSize: 64),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Başlık ve Alt Başlık
                      const Text(
                        "OSMANLI'DA BİR HAYAT",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.8,
                          color: Renkler.murekkep,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Tarihi Hayat Simülasyonu",
                        style: TextStyle(
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                          color: Renkler.murekkepSoluk,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Yeni Hayat Başlat Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Renkler.damga,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Renkler.altin, width: 1.5),
                            ),
                            elevation: 4,
                          ),
                          onPressed: _yukleniyor ? null : _yeniHayatBaslat,
                          child: _yukleniyor
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  '📜 YENİ HAYAT BAŞLAT',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Geçmiş Hayatlar (Şecere) Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Renkler.murekkep,
                            side: const BorderSide(color: Renkler.damga, width: 1.5),
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
                          child: const Text(
                            '🏛️ GEÇMİŞ HAYATLAR (ŞECERE)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Nişanlar ve Başarımlar Butonu
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Renkler.murekkep,
                            side: const BorderSide(color: Renkler.altin, width: 1.5),
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
                          child: const Text(
                            '🏆 NİŞAN VE BAŞARIMLAR',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Alt Bilgi
                      const Text(
                        "© 1299 - 1922 Osmanlı İmparatorluğu Dönemi",
                        style: TextStyle(
                          fontSize: 11,
                          color: Renkler.murekkepSoluk,
                        ),
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
