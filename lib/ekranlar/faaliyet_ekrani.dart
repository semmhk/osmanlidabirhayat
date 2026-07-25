import 'package:flutter/material.dart';
import '../modeller/faaliyet.dart';
import '../modeller/karakter.dart';
import '../motor/oyun_motoru.dart';
import '../sabitler/stiller.dart';

class FaaliyetEkrani extends StatefulWidget {
  final OyunMotoru motor;
  final VoidCallback? onStateChanged;

  const FaaliyetEkrani({
    super.key,
    required this.motor,
    this.onStateChanged,
  });

  @override
  State<FaaliyetEkrani> createState() => _FaaliyetEkraniState();
}

class _FaaliyetEkraniState extends State<FaaliyetEkrani> {
  FaaliyetKategorisi _seciliKategori = FaaliyetKategorisi.saglik;

  @override
  Widget build(BuildContext context) {
    final k = widget.motor.karakter;
    final tumFaaliyetler = FaaliyetDeposu.tumFaaliyetler;
    final kategoriFaaliyetleri = tumFaaliyetler.where((f) => f.kategori == _seciliKategori).toList();

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
          'DERSAADET FAALİYETLERİ',
          style: Stiller.baslikStili(fontSize: 16),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Stiller.bordo,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Stiller.parlakAltin),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: Stiller.parlakAltin, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Hak: ${k.aktiviteHakki}/2 | ${Karakter.paraFormatla(k.bakiye)}',
                  style: Stiller.baslikStili(fontSize: 11, color: Stiller.parsomen),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Kategori Seçim Sekmeleri (Tabs)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                children: FaaliyetKategorisi.values.map((kat) {
                  final isSelected = kat == _seciliKategori;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      avatar: Icon(_kategoriIcon(kat), size: 16, color: isSelected ? Colors.black : Stiller.parlakAltin),
                      label: Text(_kategoriBaslik(kat)),
                      selected: isSelected,
                      selectedColor: Stiller.parlakAltin,
                      backgroundColor: Stiller.koyuKahve,
                      labelStyle: Stiller.baslikStili(
                        fontSize: 12,
                        color: isSelected ? Colors.black : Stiller.parsomen,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _seciliKategori = kat);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // Faaliyet Listesi
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: kategoriFaaliyetleri.length,
                itemBuilder: (context, index) {
                  final f = kategoriFaaliyetleri[index];
                  final bool paraYeterli = k.para >= f.akceMaliyeti;
                  final bool hakVar = k.aktiviteHakki > 0;
                  final bool yasUygun = k.yas >= f.minYas;
                  final bool meslekUygun = !f.gerekliMeslek || k.meslekZincirId != null;
                  final bool esUygun = !f.gerekliEs || k.esAdi != null;
                  final bool cocukUygun = !f.gerekliCocuk || k.cocuklar.isNotEmpty;
                  final bool dukkanLimit = f.id != 'mulk_dukkan' || k.mulkler.length < 2;

                  final bool yapilabilir = paraYeterli && hakVar && yasUygun && meslekUygun && esUygun && cocukUygun && dukkanLimit;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Stiller.koyuKahve,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: yapilabilir ? Stiller.altinSarisi : Colors.grey.shade700,
                        width: yapilabilir ? 1.5 : 1.0,
                      ),
                      boxShadow: yapilabilir ? Stiller.kartGolge : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                f.baslik,
                                style: Stiller.baslikStili(
                                  fontSize: 14,
                                  color: yapilabilir ? Stiller.parlakAltin : Colors.grey,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Stiller.ortaKahve,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Stiller.altinSarisi),
                              ),
                              child: Text(
                                '${f.akceMaliyeti} Akçe',
                                style: Stiller.baslikStili(fontSize: 11, color: Stiller.parlakAltin),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          f.aciklama,
                          style: Stiller.govdeStili(fontSize: 12, color: Stiller.koyuParsomen),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.stars, color: Colors.greenAccent, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  f.kazanimOzeti,
                                  style: Stiller.govdeStili(
                                    fontSize: 11,
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yapilabilir ? Stiller.bordo : Colors.grey.shade800,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  side: BorderSide(color: yapilabilir ? Stiller.parlakAltin : Colors.transparent),
                                ),
                              ),
                              onPressed: yapilabilir
                                  ? () {
                                      final success = widget.motor.faaliyetYurut(f);
                                      if (success) {
                                        setState(() {});
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${f.baslik} başarıyla gerçekleştirildi.'),
                                            backgroundColor: Stiller.koyuKahve,
                                            duration: const Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              child: Text(
                                !hakVar
                                    ? 'Hak Yok'
                                    : !paraYeterli
                                        ? 'Akçe Yetersiz'
                                        : !dukkanLimit
                                            ? 'Max Dükkan'
                                            : 'İcra Et',
                                style: Stiller.baslikStili(
                                  fontSize: 11,
                                  color: yapilabilir ? Stiller.parsomen : Colors.grey,
                                ),
                              ),
                            ),
                          ],
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

  String _kategoriBaslik(FaaliyetKategorisi kat) {
    switch (kat) {
      case FaaliyetKategorisi.saglik:
        return 'Sağlık';
      case FaaliyetKategorisi.ilim:
        return 'İlim';
      case FaaliyetKategorisi.itibar:
        return 'İtibar';
      case FaaliyetKategorisi.mulk:
        return 'Mülk';
      case FaaliyetKategorisi.sosyal:
        return 'Sosyal';
      case FaaliyetKategorisi.aile:
        return 'Aile';
    }
  }

  IconData _kategoriIcon(FaaliyetKategorisi kat) {
    switch (kat) {
      case FaaliyetKategorisi.saglik:
        return Icons.health_and_safety;
      case FaaliyetKategorisi.ilim:
        return Icons.school;
      case FaaliyetKategorisi.itibar:
        return Icons.military_tech;
      case FaaliyetKategorisi.mulk:
        return Icons.storefront;
      case FaaliyetKategorisi.sosyal:
        return Icons.groups;
      case FaaliyetKategorisi.aile:
        return Icons.family_restroom;
    }
  }
}
