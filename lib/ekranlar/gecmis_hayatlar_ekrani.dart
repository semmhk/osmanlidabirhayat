import 'package:flutter/material.dart';
import '../modeller/hayat_kaydi.dart';
import '../modeller/karakter.dart';
import '../sabitler/renkler.dart';
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
      backgroundColor: Renkler.kagitKoyu,
      appBar: AppBar(
        backgroundColor: Renkler.kagitKoyu,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Renkler.altin),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '📜 Geçmiş Hayatlar (Şecere)',
          style: TextStyle(
            color: Renkler.altin,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Renkler.kagit,
              border: Border.all(color: Renkler.altin, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: FutureBuilder<List<HayatKaydi>>(
              future: _kayitlarFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Renkler.damga),
                  );
                }

                final kayitlar = snapshot.data ?? [];

                if (kayitlar.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '🏛️',
                          style: TextStyle(fontSize: 48),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Henüz Kayıtlı Bir Hayat Yok',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Renkler.murekkep,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Yeni bir hayata başlayıp Osmanlı topraklarında iz bıraktığınızda şecereniz burada listelenecektir.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Renkler.murekkepSoluk,
                          ),
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
                        color: Renkler.kagitKoyu.withAlpha(20),
                        border: Border.all(color: Renkler.cizgi),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${k.cinsiyet == Cinsiyet.erkek ? "🧔" : "🧕"} ${k.isim}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Renkler.murekkep,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Renkler.damga,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '📜 N:${k.nesil}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            k.hikayesiTamamlandi
                                ? '📅 Yaşam Dönemi: ${k.dogumYili} - ${k.olumYili} (${k.yas} Yaşında • Osmanlı Dönemi Sonu)'
                                : '📅 Yaşam Dönemi: ${k.dogumYili} - ${k.olumYili} (${k.yas} Yaşında Vefat)',
                            style: const TextStyle(fontSize: 12, color: Renkler.murekkep),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '💼 ${k.unvan}',
                                style: const TextStyle(fontSize: 12, color: Renkler.murekkepSoluk),
                              ),
                              const Spacer(),
                              Text(
                                '💰 ${Karakter.paraFormatla(k.bakiye)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Renkler.onay,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            k.hikayesiTamamlandi
                                ? '🏛️ ${k.olumNedeni}'
                                : '⚰️ Ölüm Nedeni: ${k.olumNedeni}',
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: k.hikayesiTamamlandi ? Renkler.murekkep : Renkler.damga,
                            ),
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
                                    color: Renkler.altin.withAlpha(50),
                                    border: Border.all(color: Renkler.altin),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    '🏆 $b',
                                    style: const TextStyle(fontSize: 10, color: Renkler.murekkep),
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
