import 'package:flutter/material.dart';
import '../modeller/hayat_kaydi.dart';
import '../modeller/karakter.dart';
import '../sabitler/stiller.dart';
import '../servisler/hayat_kaydi_servisi.dart';

class GecmisHayatlarEkrani extends StatefulWidget {
  const GecmisHayatlarEkrani({super.key});

  @override
  State<GecmisHayatlarEkrani> createState() => _GecmisHayatlarEkraniState();
}

class _GecmisHayatlarEkraniState extends State<GecmisHayatlarEkrani> {
  late Future<List<HayatKaydi>> _kayitlarFuture;

  @override
  void initState() {
    super.initState();
    _kayitlariYukle();
  }

  void _kayitlariYukle() {
    setState(() {
      _kayitlarFuture = HayatKaydiServisi().tumKayitlariGetir();
    });
  }

  @override
  Widget build(BuildContext context) {
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
          'GEÇMİŞ HAYATLAR (ŞECERE)',
          style: Stiller.baslikStili(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: Stiller.altinKartStili,
            child: FutureBuilder<List<HayatKaydi>>(
              future: _kayitlarFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Stiller.parlakAltin),
                  );
                }

                final kayitlar = snapshot.data ?? [];

                if (kayitlar.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.auto_stories, size: 54, color: Stiller.parlakAltin),
                        const SizedBox(height: 12),
                        Text(
                          'Henüz Kayıtlı Bir Hayat Yok',
                          style: Stiller.baslikStili(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Yeni bir hayata başlayıp Osmanlı topraklarında iz bıraktığınızda şecereniz burada kütüklenecektir.',
                          textAlign: TextAlign.center,
                          style: Stiller.govdeStili(fontSize: 13, color: Stiller.koyuParsomen),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: kayitlar.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final k = kayitlar[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Stiller.koyuKahve,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Stiller.altinSarisi.withAlpha(100)),
                        boxShadow: Stiller.kartGolge,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    k.cinsiyet == Cinsiyet.erkek ? Icons.face : Icons.face_3,
                                    color: Stiller.parlakAltin,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    k.isim,
                                    style: Stiller.baslikStili(fontSize: 16),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Stiller.bordo,
                                  border: Border.all(color: Stiller.parlakAltin),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Nesil: ${k.nesil}',
                                  style: Stiller.baslikStili(fontSize: 11, color: Stiller.parsomen),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Stiller.koyuParsomen, size: 14),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  k.hikayesiTamamlandi
                                      ? '${k.dogumYili} - ${k.olumYili} (${k.yas} Yaşında • Osmanlı Dönemi Sonu)'
                                      : '${k.dogumYili} - ${k.olumYili} (${k.yas} Yaşında Vefat)',
                                  style: Stiller.govdeStili(fontSize: 12, color: Stiller.parsomen),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.work, color: Stiller.koyuParsomen, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                k.unvan,
                                style: Stiller.altMetinStili(fontSize: 12),
                              ),
                              const Spacer(),
                              const Icon(Icons.monetization_on, color: Stiller.parlakAltin, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${k.bakiye.toInt()} Akçe',
                                style: Stiller.baslikStili(fontSize: 12, color: Stiller.parlakAltin),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.history_edu, color: Stiller.bordo, size: 14),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  k.hikayesiTamamlandi ? k.olumNedeni : 'Ölüm Nedeni: ${k.olumNedeni}',
                                  style: Stiller.altMetinStili(fontSize: 11, color: Stiller.parlakAltin),
                                ),
                              ),
                            ],
                          ),
                          if (k.kazanilanBasarimlar.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: k.kazanilanBasarimlar.map((b) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Stiller.ortaKahve,
                                    border: Border.all(color: Stiller.altinSarisi),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.workspace_premium, color: Stiller.parlakAltin, size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        b,
                                        style: Stiller.govdeStili(fontSize: 10, color: Stiller.parsomen),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
