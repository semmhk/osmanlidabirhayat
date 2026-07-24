import 'package:flutter/material.dart';
import '../modeller/basarim.dart';
import '../modeller/cocuk.dart';
import '../modeller/karakter.dart';
import '../motor/ozet_uretici.dart';
import '../sabitler/renkler.dart';
import '../servisler/hayat_kaydi_servisi.dart';

class OlumEkrani extends StatelessWidget {
  final Karakter karakter;
  final VoidCallback onYeniHayat;
  final Function(Cocuk)? onNesilDevamEt;
  final VoidCallback? onAnaMenu;
  final List<Basarim> yeniBasarimlar;

  const OlumEkrani({
    super.key,
    required this.karakter,
    required this.onYeniHayat,
    this.onNesilDevamEt,
    this.onAnaMenu,
    this.yeniBasarimlar = const [],
  });

  void _hayatiKaydet() {
    HayatKaydiServisi().hayatKaydet(karakter);
  }

  void _nesilSecimModalGoster(BuildContext context) {
    if (karakter.cocuklar.isEmpty || onNesilDevamEt == null) return;

    final double toplamMiras = karakter.bakiye > 0 ? (karakter.bakiye * 0.40) : 0.0;
    final double kisiBasiMiras = karakter.cocuklar.isNotEmpty ? (toplamMiras / karakter.cocuklar.length) : 0.0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Renkler.kagit,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '📜 SOYUNU DEVAM ETTİR',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Renkler.murekkep,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Hangi evladınla yaşam bayrağını devralmak istersin?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Renkler.murekkep.withAlpha(180),
                ),
              ),
              const SizedBox(height: 16),
              ...karakter.cocuklar.map((c) {
                final int cocukYasi = c.guncelYasGetir(karakter.yas);
                final String cinsiyetIcon = c.erkekMi ? '👦' : '👧';
                final String formattedMiras = Karakter.paraFormatla(kisiBasiMiras);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      side: const BorderSide(color: Renkler.damga, width: 1.5),
                    ),
                    onPressed: () {
                      _hayatiKaydet();
                      Navigator.pop(ctx);
                      onNesilDevamEt!(c);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$cinsiyetIcon ${c.ad} ${karakter.soyad}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Renkler.murekkep,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$cocukYasi Yaşında · ${c.erkekMi ? "Oğul" : "Kız"}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Renkler.murekkep.withAlpha(160),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Miras: $formattedMiras',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Renkler.onay,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool son1922 = karakter.hikayesiTamamlandi || karakter.takvimYili >= 1922;
    final ozetMetni = OzetUretici.olumOzetiUret(karakter);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: son1922 ? Renkler.altin : Renkler.damga, width: 3),
              color: Renkler.kagit,
            ),
            child: Text(
              son1922 ? "HİKAYENİN SONU (1922 - OSMANLI DEVLETİ'NİN SONU)" : 'FERMAN-I VEFAT (RUHUNA FATİHA)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: son1922 ? Renkler.murekkep : Renkler.damga,
              ),
            ),
          ),
          if (son1922) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Renkler.altin, width: 2),
                color: Renkler.kagitKoyu.withAlpha(20),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  const Text(
                    '🏛️ OSMANLI DÖNEMİ TAMAMLANDI',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Renkler.damga,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '1922\'de Osmanlı Devleti\'nin sona ermesiyle, ${karakter.isim}\'in bu topraklardaki Osmanlı dönemi hikayesi burada tamamlanıyor. Hayatı Cumhuriyet Türkiyesi\'nde devam etti.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                      color: Renkler.murekkep,
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (yeniBasarimlar.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Renkler.onay, width: 2),
                color: Renkler.kagit,
              ),
              child: Column(
                children: [
                  const Text(
                    '🏅 YENİ BAŞARIM(LAR) KAZANILDI!',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Renkler.onay,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...yeniBasarimlar.map(
                    (b) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '${b.ikon} ${b.baslik}: ${b.aciklama}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Renkler.murekkep,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Renkler.cizgi),
              color: Colors.white.withAlpha(102),
            ),
            child: Text(
              ozetMetni,
              style: const TextStyle(
                fontSize: 13,
                height: 1.6,
                color: Renkler.murekkep,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (!son1922 && karakter.cocuklar.isNotEmpty && onNesilDevamEt != null) ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Renkler.damga,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(44),
              ),
              onPressed: () => _nesilSecimModalGoster(context),
              child: const Text('SOYUNU DEVAM ETTİR 📜'),
            ),
            const SizedBox(height: 10),
          ] else if (son1922) ...[
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Renkler.kagitKoyu.withAlpha(15),
                border: Border.all(color: Renkler.cizgi),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                '📜 1922 Saltanatın kaldırılmasıyla Osmanlı Devleti dönemi tamamlanmış olup yeni nesil devredilemez.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Renkler.murekkepSoluk,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Renkler.murekkep,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: () {
              _hayatiKaydet();
              onYeniHayat();
            },
            child: const Text('YENİ HAYATA BAŞLA 🕌'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Renkler.murekkep,
              side: const BorderSide(color: Renkler.altin, width: 1.5),
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: () {
              _hayatiKaydet();
              if (onAnaMenu != null) {
                onAnaMenu!();
              } else {
                Navigator.popUntil(context, (route) => route.isFirst);
              }
            },
            child: const Text('🏛️ ANA MENÜYE DÖN'),
          ),
        ],
      ),
    );
  }
}
