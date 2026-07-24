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
      body: SafeArea(
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
                    '1299 - 1922 • Tarihi Yaşam Simülasyonu',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Renkler.damga,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Menü Butonları
                  if (_yukleniyor)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(color: Renkler.damga),
                    )
                  else ...[
                    _menuButonu(
                      etiket: '📜 YENİ HAYAT BAŞLAT',
                      renk: Renkler.damga,
                      yaziRengi: Colors.white,
                      onTap: _yeniHayatBaslat,
                    ),
                    const SizedBox(height: 12),
                    _menuButonu(
                      etiket: '🏛️ GEÇMİŞ HAYATLAR (ŞECERE)',
                      renk: Renkler.murekkep,
                      yaziRengi: Renkler.kagit,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GecmisHayatlarEkrani(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _menuButonu(
                      etiket: '🏆 NİŞAN VE BAŞARIMLAR',
                      renk: Renkler.altin,
                      yaziRengi: Renkler.murekkep,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BasarimlarEkrani(),
                          ),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Divider(color: Renkler.cizgi),
                  const SizedBox(height: 8),

                  // Alt Bilgi & Ses Butonu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'v1.0.0 • Devlet-i Aliyye',
                        style: TextStyle(fontSize: 11, color: Renkler.murekkepSoluk),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            SesServisi().sesDurumunuDegistir();
                          });
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              SesServisi().sesAcik ? Icons.volume_up : Icons.volume_off,
                              size: 16,
                              color: Renkler.murekkep,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              SesServisi().sesAcik ? 'Müzik Açık' : 'Müzik Kapalı',
                              style: const TextStyle(fontSize: 11, color: Renkler.murekkep),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuButonu({
    required String etiket,
    required Color renk,
    required Color yaziRengi,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: renk,
          foregroundColor: yaziRengi,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: Renkler.altin, width: 1),
          ),
        ),
        onPressed: onTap,
        child: Text(
          etiket,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
