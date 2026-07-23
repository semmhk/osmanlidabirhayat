import 'package:flutter/material.dart';
import '../modeller/basarim.dart';
import '../modeller/cocuk.dart';
import '../modeller/karakter.dart';
import '../motor/ozet_uretici.dart';
import '../sabitler/renkler.dart';

class OlumEkrani extends StatelessWidget {
  final Karakter karakter;
  final VoidCallback onYeniHayat;
  final Function(Cocuk)? onNesilDevamEt;
  final List<Basarim> yeniBasarimlar;

  const OlumEkrani({
    super.key,
    required this.karakter,
    required this.onYeniHayat,
    this.onNesilDevamEt,
    this.yeniBasarimlar = const [],
  });

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
    final ozetMetni = OzetUretici.olumOzetiUret(karakter);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Renkler.damga, width: 3),
              color: Renkler.kagit,
            ),
            child: const Text(
              'FERMAN-I VEFAT (RUHUNA FATİHA)',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 2,
                fontWeight: FontWeight.bold,
                color: Renkler.damga,
              ),
            ),
          ),
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
          if (karakter.cocuklar.isNotEmpty && onNesilDevamEt != null) ...[
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
          ],
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Renkler.murekkep,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(44),
            ),
            onPressed: onYeniHayat,
            child: const Text('YENİ HAYATA BAŞLA 🕌'),
          ),
        ],
      ),
    );
  }
}
