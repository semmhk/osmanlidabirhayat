import 'package:flutter/material.dart';
import '../modeller/basarim.dart';
import '../modeller/cocuk.dart';
import '../modeller/karakter.dart';
import '../motor/oyun_motoru.dart';
import '../motor/ozet_uretici.dart';
import '../sabitler/stiller.dart';
import '../servisler/hayat_kaydi_servisi.dart';

class OlumEkrani extends StatelessWidget {
  final Karakter karakter;
  final VoidCallback onYeniHayat;
  final Function(Cocuk)? onNesilDevamEt;
  final VoidCallback? onAnaMenu;
  final List<Basarim> yeniBasarimlar;
  final OyunMotoru? motor;

  const OlumEkrani({
    super.key,
    required this.karakter,
    required this.onYeniHayat,
    this.onNesilDevamEt,
    this.onAnaMenu,
    this.yeniBasarimlar = const [],
    this.motor,
  });

  void _hayatiKaydet() {
    HayatKaydiServisi().hayatKaydet(karakter);
  }

  void _nesilSecimModalGoster(BuildContext context) {
    if (karakter.cocuklar.isEmpty || onNesilDevamEt == null) return;

    final double toplamMiras = karakter.para > 0 ? (karakter.para * 0.40) : 0.0;
    final double kisiBasiMiras = karakter.cocuklar.isNotEmpty ? (toplamMiras / karakter.cocuklar.length) : 0.0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Stiller.sepyaArkaplan,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.family_restroom, color: Stiller.parlakAltin, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'SOYUNU DEVAM ETTİR',
                    style: Stiller.baslikStili(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Hangi evladınla yaşam bayrağını devralmak istersin?',
                textAlign: TextAlign.center,
                style: Stiller.altMetinStili(fontSize: 12),
              ),
              const SizedBox(height: 16),
              ...karakter.cocuklar.map((c) {
                final int cocukYasi = c.guncelYasGetir(karakter.yas);
                final IconData cinsiyetIcon = c.erkekMi ? Icons.face : Icons.face_3;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Stiller.koyuKahve,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      side: const BorderSide(color: Stiller.altinSarisi, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      _hayatiKaydet();
                      Navigator.pop(ctx);
                      onNesilDevamEt!(c);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(cinsiyetIcon, color: Stiller.parlakAltin, size: 20),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${c.ad} ${karakter.soyad}',
                                  style: Stiller.baslikStili(fontSize: 14),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$cocukYasi Yaşında · ${c.erkekMi ? "Oğul" : "Kız"}',
                                  style: Stiller.altMetinStili(fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          'Miras: ${kisiBasiMiras.toInt()} Akçe',
                          style: Stiller.govdeStili(fontSize: 12, color: Stiller.parlakAltin, fontWeight: FontWeight.bold),
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

    return Scaffold(
      backgroundColor: Stiller.sepyaArkaplan,
      appBar: AppBar(
        backgroundColor: Stiller.koyuKahve,
        elevation: 4,
        title: Text(
          son1922 ? "HİKAYENİN SONU (1922)" : 'FERMAN-I VEFAT (RUHUNA FATİHA)',
          style: Stiller.baslikStili(fontSize: 16),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: Stiller.altinKartStili,
                child: Column(
                  children: [
                    const Icon(Icons.history_edu, color: Stiller.parlakAltin, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      son1922
                          ? "1922 — OSMANLI DEVLETİ'NİN SONU"
                          : 'VEFAT İLAMI (RUHUNA FATİHA)',
                      textAlign: TextAlign.center,
                      style: Stiller.baslikStili(fontSize: 16),
                    ),
                    const Divider(color: Stiller.altinSarisi, thickness: 1, height: 20),
                    Text(
                      ozetMetni,
                      style: Stiller.govdeStili(fontSize: 13, height: 1.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (yeniBasarimlar.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Stiller.koyuKahve,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Stiller.parlakAltin, width: 1.5),
                    boxShadow: Stiller.altinGolge,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.workspace_premium, color: Stiller.parlakAltin, size: 20),
                          const SizedBox(width: 6),
                          Text('YENİ BAŞARIM KAZANILDI!', style: Stiller.baslikStili(fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ...yeniBasarimlar.map(
                        (b) => Text(
                          '${b.baslik}: ${b.aciklama}',
                          style: Stiller.govdeStili(fontSize: 12, color: Stiller.parsomen),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (!son1922 && karakter.cocuklar.isNotEmpty && onNesilDevamEt != null) ...[
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Stiller.bordo,
                      foregroundColor: Stiller.parsomen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Stiller.parlakAltin),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () => _nesilSecimModalGoster(context),
                    icon: const Icon(Icons.family_restroom, color: Stiller.parlakAltin),
                    label: Text('SOYUNU DEVAM ETTİR', style: Stiller.baslikStili(fontSize: 14, color: Stiller.parsomen)),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Stiller.ortaKahve,
                    foregroundColor: Stiller.parsomen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Stiller.altinSarisi),
                    ),
                  ),
                  onPressed: () {
                    _hayatiKaydet();
                    onYeniHayat();
                  },
                  icon: const Icon(Icons.refresh, color: Stiller.parlakAltin),
                  label: Text('YENİ HAYATA BAŞLA', style: Stiller.baslikStili(fontSize: 14, color: Stiller.parsomen)),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Stiller.parsomen,
                    side: const BorderSide(color: Stiller.altinSarisi),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    _hayatiKaydet();
                    if (onAnaMenu != null) {
                      onAnaMenu!();
                    } else {
                      Navigator.popUntil(context, (route) => route.isFirst);
                    }
                  },
                  icon: const Icon(Icons.home, color: Stiller.parlakAltin),
                  label: Text('ANA MENÜYE DÖN', style: Stiller.baslikStili(fontSize: 14, color: Stiller.parsomen)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
