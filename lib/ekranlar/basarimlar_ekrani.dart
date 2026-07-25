import 'package:flutter/material.dart';
import '../modeller/basarim.dart';
import '../motor/basarim_kontrolcusu.dart';
import '../sabitler/stiller.dart';

class BasarimlarEkrani extends StatefulWidget {
  const BasarimlarEkrani({super.key});

  @override
  State<BasarimlarEkrani> createState() => _BasarimlarEkraniState();
}

class _BasarimlarEkraniState extends State<BasarimlarEkrani> {
  List<Basarim> _basarimlar = [];
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _yukle();
  }

  Future<void> _yukle() async {
    final list = await BasarimKontrolcu.basarimlariYukle();
    if (mounted) {
      setState(() {
        _basarimlar = list;
        _yukleniyor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final kazanilanSayisi = _basarimlar.where((b) => b.kazanildi).length;

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
          'NİŞAN VE BAŞARIMLAR',
          style: Stiller.baslikStili(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: _yukleniyor
          ? const Center(
              child: CircularProgressIndicator(color: Stiller.parlakAltin),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  color: Stiller.koyuKahve,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.workspace_premium, color: Stiller.parlakAltin, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'KAZANILAN MADALYALAR:',
                            style: Stiller.baslikStili(fontSize: 13),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Stiller.parlakAltin, width: 1.5),
                          borderRadius: BorderRadius.circular(6),
                          color: Stiller.ortaKahve,
                        ),
                        child: Text(
                          '$kazanilanSayisi / ${_basarimlar.length}',
                          style: Stiller.baslikStili(fontSize: 14, color: Stiller.parlakAltin),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Stiller.altinSarisi),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _basarimlar.length,
                    itemBuilder: (context, index) {
                      final b = _basarimlar[index];
                      return _basarimKarti(b);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _basarimKarti(Basarim b) {
    final bool kazanildi = b.kazanildi;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kazanildi ? Stiller.ortaKahve : Stiller.koyuKahve,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: kazanildi ? Stiller.parlakAltin : Stiller.altinSarisi.withAlpha(80),
          width: kazanildi ? 1.8 : 1.0,
        ),
        boxShadow: kazanildi ? Stiller.altinGolge : Stiller.kartGolge,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kazanildi ? Stiller.bordo : Stiller.koyuKahve,
              border: Border.all(
                color: kazanildi ? Stiller.parlakAltin : Colors.grey,
                width: 1.5,
              ),
              shape: BoxShape.circle,
              boxShadow: kazanildi ? Stiller.altinGolge : null,
            ),
            child: Icon(
              kazanildi ? Icons.workspace_premium : Icons.lock,
              size: 24,
              color: kazanildi ? Stiller.parlakAltin : Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        b.baslik,
                        style: Stiller.baslikStili(
                          fontSize: 14,
                          color: kazanildi ? Stiller.parlakAltin : Stiller.koyuParsomen,
                        ),
                      ),
                    ),
                    if (kazanildi && b.kazanmaTarihi != null)
                      Text(
                        b.kazanmaTarihi!,
                        style: Stiller.altMetinStili(fontSize: 10, color: Stiller.parlakAltin),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  b.aciklama,
                  style: Stiller.govdeStili(
                    fontSize: 12,
                    color: kazanildi ? Stiller.parsomen : Stiller.koyuParsomen.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
