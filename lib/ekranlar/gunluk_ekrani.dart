import 'package:flutter/material.dart';
import '../bilesenler/vesikalik_avatar.dart';
import '../modeller/karakter.dart';
import '../sabitler/stiller.dart';

class GunlukEkrani extends StatelessWidget {
  final dynamic motor;

  const GunlukEkrani({super.key, required this.motor});

  Karakter get karakter => motor.karakter;

  @override
  Widget build(BuildContext context) {
    final List<String> gunlukListesi = List<String>.from(karakter.gunluk);

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
          '${karakter.ad} — HAYAT GÜNLÜĞÜ',
          style: Stiller.baslikStili(fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // OSMANLI HÜVİYET CÜZDANI KARTIS
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: Stiller.altinKartStili,
              child: Row(
                children: [
                  // Vesikalık Avatar
                  VesikalikAvatar(
                    yas: karakter.yas,
                    genler: karakter.genler,
                    genislik: 100,
                    yukseklik: 120,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Stiller.bordo,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'DEVLET-İ ALİYYE HÜVİYET CÜZDANI',
                            style: Stiller.baslikStili(fontSize: 9, color: Stiller.parsomen),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          karakter.ad,
                          style: Stiller.baslikStili(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.work, color: Stiller.koyuParsomen, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              karakter.meslekUnvaniGetir(),
                              style: Stiller.altMetinStili(fontSize: 12),
                            ),
                          ],
                        ),
                        const Divider(color: Stiller.altinSarisi, height: 12),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, color: Stiller.koyuParsomen, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              'Doğum: ${karakter.dogumYili} | Nesil: #${karakter.nesil}',
                              style: Stiller.govdeStili(fontSize: 11),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.monetization_on, color: Stiller.parlakAltin, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              'Servet: ${karakter.para.toInt()} Akçe',
                              style: Stiller.baslikStili(fontSize: 11, color: Stiller.parlakAltin),
                            ),
                          ],
                        ),
                        if (karakter.esAdi != null)
                          Row(
                            children: [
                              const Icon(Icons.favorite, color: Colors.pinkAccent, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                'Eş: ${karakter.esAdi}',
                                style: Stiller.govdeStili(fontSize: 11),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // GÜNLÜK KAYITLARI LİSTESİ
            Expanded(
              child: gunlukListesi.isEmpty
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.all(16),
                        decoration: Stiller.altinKartStili,
                        child: Text(
                          'Henüz kayıtlı bir günlük girdisi yok.',
                          style: Stiller.altMetinStili(fontSize: 14),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      itemCount: gunlukListesi.length,
                      itemBuilder: (context, index) {
                        final girdi = gunlukListesi[gunlukListesi.length - 1 - index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Stiller.koyuKahve,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Stiller.altinSarisi.withAlpha(80)),
                            boxShadow: Stiller.kartGolge,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Stiller.bordo,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '#${gunlukListesi.length - index}',
                                  style: Stiller.baslikStili(fontSize: 10, color: Stiller.parsomen),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  girdi,
                                  style: Stiller.govdeStili(fontSize: 13, height: 1.4),
                                ),
                              ),
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
