import 'package:flutter/material.dart';
import '../sabitler/stiller.dart';
import '../servisler/ses_servisi.dart';

class SesAyariDiyalog extends StatefulWidget {
  const SesAyariDiyalog({super.key});

  static void goster(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const SesAyariDiyalog(),
    );
  }

  @override
  State<SesAyariDiyalog> createState() => _SesAyariDiyalogState();
}

class _SesAyariDiyalogState extends State<SesAyariDiyalog> {
  final _sesServisi = SesServisi();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: Stiller.altinKartStili,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.music_note, color: Stiller.parlakAltin, size: 24),
                const SizedBox(width: 10),
                Text('Müzik ve Ses Ayarları', style: Stiller.baslikStili(fontSize: 18)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Stiller.koyuParsomen),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(color: Stiller.altinSarisi, thickness: 1),
            const SizedBox(height: 12),
            Text(
              'Osmanlı musiki atmosferi tercihiniz:',
              style: Stiller.govdeStili(fontSize: 13, color: Stiller.koyuParsomen),
            ),
            const SizedBox(height: 16),

            _secenekTile(
              mod: MuzikModu.aralikli,
              baslik: 'Aralıklı Çalma (Tavsiye Edilen)',
              aciklama: 'Parça bittiğinde 45-75 sn sessizlik verir, zihni yormaz.',
              icon: Icons.graphic_eq,
            ),

            const SizedBox(height: 10),

            _secenekTile(
              mod: MuzikModu.surekli,
              baslik: 'Sürekli Çalma',
              aciklama: 'Dönem müziği durmaksızın döngüsel çalar.',
              icon: Icons.loop,
            ),

            const SizedBox(height: 10),

            _secenekTile(
              mod: MuzikModu.kapali,
              baslik: 'Müzik Kapalı',
              aciklama: 'Arka plan müziği tamamen kapatılır.',
              icon: Icons.volume_off,
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Stiller.ortaKahve,
                side: const BorderSide(color: Stiller.altinSarisi),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('TAMAM', style: Stiller.baslikStili(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secenekTile({
    required MuzikModu mod,
    required String baslik,
    required String aciklama,
    required IconData icon,
  }) {
    final bool secili = _sesServisi.muzikModu == mod;

    return InkWell(
      onTap: () {
        setState(() {
          _sesServisi.muzikModunuDegistir(mod);
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: secili ? Stiller.ortaKahve : Stiller.koyuKahve,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: secili ? Stiller.parlakAltin : Stiller.altinSarisi.withAlpha(70),
            width: secili ? 2.0 : 1.0,
          ),
          boxShadow: secili ? Stiller.altinGolge : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: secili ? Stiller.parlakAltin : Stiller.koyuParsomen, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    baslik,
                    style: Stiller.baslikStili(
                      fontSize: 14,
                      color: secili ? Stiller.parlakAltin : Stiller.parsomen,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    aciklama,
                    style: Stiller.govdeStili(fontSize: 11, color: Stiller.koyuParsomen),
                  ),
                ],
              ),
            ),
            if (secili)
              const Icon(Icons.check_circle, color: Stiller.parlakAltin, size: 20),
          ],
        ),
      ),
    );
  }
}
