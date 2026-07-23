import 'package:flutter/material.dart';
import '../modeller/basarim.dart';
import '../motor/basarim_kontrolcusu.dart';
import '../sabitler/renkler.dart';

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
      backgroundColor: Renkler.kagitKoyu,
      appBar: AppBar(
        backgroundColor: Renkler.kagit,
        elevation: 0,
        iconTheme: const IconThemeData(color: Renkler.murekkep),
        title: const Text(
          'NİŞAN VE BAŞARIMLAR',
          style: TextStyle(
            color: Renkler.murekkep,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: _yukleniyor
          ? const Center(
              child: CircularProgressIndicator(color: Renkler.murekkep),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  color: Renkler.kagit,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'KAZANILAN MADALYALAR:',
                        style: TextStyle(
                          color: Renkler.murekkepSoluk,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Renkler.damga, width: 2),
                          color: Renkler.kagit,
                        ),
                        child: Text(
                          '$kazanilanSayisi / ${_basarimlar.length}',
                          style: const TextStyle(
                            color: Renkler.damga,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Renkler.cizgi),
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
        color: kazanildi ? Renkler.kagit : Renkler.kagitKoyu.withAlpha(120),
        border: Border.all(
          color: kazanildi ? Renkler.damga : Renkler.cizgi,
          width: kazanildi ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kazanildi ? Renkler.damga.withAlpha(30) : Colors.transparent,
              border: Border.all(
                color: kazanildi ? Renkler.damga : Renkler.cizgi,
                width: 1.5,
              ),
              shape: BoxShape.circle,
            ),
            child: Text(
              b.ikon,
              style: TextStyle(
                fontSize: 22,
                color: kazanildi ? null : Colors.grey,
              ),
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
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kazanildi ? Renkler.murekkep : Renkler.murekkepSoluk,
                        ),
                      ),
                    ),
                    if (kazanildi && b.kazanmaTarihi != null)
                      Text(
                        b.kazanmaTarihi!,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Renkler.damga,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  b.aciklama,
                  style: TextStyle(
                    fontSize: 12,
                    color: kazanildi ? Renkler.murekkep.withAlpha(200) : Renkler.murekkepSoluk.withAlpha(180),
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
