import 'package:flutter/material.dart';
import '../modeller/karakter.dart';
import '../motor/oyun_motoru.dart';
import '../sabitler/stiller.dart';

class IliskilerEkrani extends StatefulWidget {
  final OyunMotoru motor;
  final VoidCallback? onStateChanged;

  const IliskilerEkrani({
    super.key,
    required this.motor,
    this.onStateChanged,
  });

  @override
  State<IliskilerEkrani> createState() => _IliskilerEkraniState();
}

class _IliskilerEkraniState extends State<IliskilerEkrani> {
  @override
  Widget build(BuildContext context) {
    final k = widget.motor.karakter;

    // İlişkileri senkronize et
    if (k.esAdi != null && !k.iliskiler.any((i) => i.tip == IliskiTipi.es)) {
      k.iliskiler.add(Iliski(id: 'es_${k.takvimYili}', isim: k.esAdi!, tip: IliskiTipi.es, yakinlikPuani: 75));
    }
    for (final cocuk in k.cocuklar) {
      if (!k.iliskiler.any((i) => i.isim == cocuk.ad)) {
        k.iliskiler.add(Iliski(id: 'cocuk_${cocuk.ad}', isim: cocuk.ad, tip: IliskiTipi.cocuk, yakinlikPuani: 70));
      }
    }

    return Scaffold(
      backgroundColor: Stiller.sepyaArkaplan,
      appBar: AppBar(
        backgroundColor: Stiller.koyuKahve,
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Stiller.parlakAltin),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'HANE HALKI VE İLİŞKİLER',
          style: Stiller.baslikStili(fontSize: 16),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${k.iliskiler.length} Birey',
                style: Stiller.baslikStili(fontSize: 13, color: Stiller.parlakAltin),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: k.iliskiler.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(16),
                        decoration: Stiller.altinKartStili,
                        child: Text(
                          'Henüz evlenmediniz veya evladınız yok.',
                          style: Stiller.altMetinStili(fontSize: 14),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: k.iliskiler.length,
                      itemBuilder: (context, index) {
                        final i = k.iliskiler[index];
                        final isEs = i.tip == IliskiTipi.es;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Stiller.koyuKahve,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Stiller.altinSarisi.withAlpha(100)),
                            boxShadow: Stiller.kartGolge,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    isEs ? Icons.favorite : Icons.child_care,
                                    color: isEs ? Colors.pinkAccent : Stiller.parlakAltin,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${i.isim} (${isEs ? "Eş" : "Evlat"})',
                                      style: Stiller.baslikStili(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Yakınlık Puanı
                              Row(
                                children: [
                                  SizedBox(
                                    width: 85,
                                    child: Text(
                                      'Yakınlık:',
                                      style: Stiller.govdeStili(fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: i.yakinlikPuani / 100.0,
                                        backgroundColor: Stiller.ortaKahve,
                                        color: i.yakinlikPuani >= 80 ? Colors.green : (i.yakinlikPuani < 30 ? Colors.red : Stiller.parlakAltin),
                                        minHeight: 8,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${i.yakinlikPuani}/100',
                                    style: Stiller.baslikStili(fontSize: 12),
                                  ),
                                ],
                              ),

                              // Eğitim Puanı (Sadece Çocuklar)
                              if (!isEs) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 85,
                                      child: Text(
                                        'Eğitim:',
                                        style: Stiller.govdeStili(fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: LinearProgressIndicator(
                                          value: i.egitimPuani / 100.0,
                                          backgroundColor: Stiller.ortaKahve,
                                          color: Colors.lightBlueAccent,
                                          minHeight: 8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${i.egitimPuani}/100',
                                      style: Stiller.baslikStili(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
