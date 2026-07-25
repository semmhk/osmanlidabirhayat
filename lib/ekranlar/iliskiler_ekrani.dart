import 'package:flutter/material.dart';
import '../modeller/karakter.dart';
import '../motor/oyun_motoru.dart';
import '../sabitler/renkler.dart';

class IliskilerEkrani extends StatefulWidget {
  final OyunMotoru motor;
  final VoidCallback onStateChanged;

  const IliskilerEkrani({
    super.key,
    required this.motor,
    required this.onStateChanged,
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.80,
      decoration: const BoxDecoration(
        color: Renkler.kagit,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Renkler.kagitKoyu,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: Renkler.altin, width: 1.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('👨‍👩‍👧‍👦 ', style: TextStyle(fontSize: 20)),
                    Text(
                      'Hane Halkı & İlişkiler',
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Renkler.altin,
                      ),
                    ),
                  ],
                ),
                Text(
                  '${k.iliskiler.length} Birey',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),

          // Relation List
          Expanded(
            child: k.iliskiler.isEmpty
                ? const Center(
                    child: Text(
                      'Henüz evlenmediniz veya evladınız yok.',
                      style: TextStyle(fontStyle: FontStyle.italic, color: Renkler.murekkep),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: k.iliskiler.length,
                    itemBuilder: (context, index) {
                      final i = k.iliskiler[index];
                      final isEs = i.tip == IliskiTipi.es;

                      return Card(
                        color: Renkler.kagitKoyu,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Renkler.altin.withAlpha(80)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(isEs ? '💍 ' : '👶 ', style: const TextStyle(fontSize: 20)),
                                  Expanded(
                                    child: Text(
                                      '${i.isim} (${isEs ? "Eş" : "Evlat"})',
                                      style: const TextStyle(
                                        fontFamily: 'Cinzel',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Renkler.altin,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Yakınlık Puanı
                              Row(
                                children: [
                                  const SizedBox(width: 85, child: Text('❤️ Yakınlık:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))),
                                  Expanded(
                                    child: LinearProgressIndicator(
                                      value: i.yakinlikPuani / 100.0,
                                      backgroundColor: Colors.grey.withAlpha(50),
                                      color: i.yakinlikPuani >= 80 ? Colors.green : (i.yakinlikPuani < 30 ? Colors.red : Renkler.altin),
                                      minHeight: 8,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${i.yakinlikPuani}/100', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                                ],
                              ),

                              // Eğitim Puanı (Sadece Çocuklar)
                              if (!isEs) ...[
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const SizedBox(width: 85, child: Text('🎓 Eğitim:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white))),
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: i.egitimPuani / 100.0,
                                        backgroundColor: Colors.grey.withAlpha(50),
                                        color: Colors.blueAccent,
                                        minHeight: 8,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('${i.egitimPuani}/100', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
