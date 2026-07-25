import 'package:flutter/material.dart';
import '../modeller/faaliyet.dart';
import '../modeller/karakter.dart';
import '../motor/oyun_motoru.dart';
import '../sabitler/renkler.dart';

class FaaliyetEkrani extends StatefulWidget {
  final OyunMotoru motor;
  final VoidCallback onStateChanged;

  const FaaliyetEkrani({
    super.key,
    required this.motor,
    required this.onStateChanged,
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

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Renkler.kagit,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Üst Başlık & Bakiye Çubuğu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Renkler.kagitKoyu,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: Renkler.altin, width: 1.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text('🕌 ', style: TextStyle(fontSize: 20)),
                    Text(
                      'Dersaadet Faaliyetleri',
                      style: TextStyle(
                        fontFamily: 'Cinzel',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Renkler.altin,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Renkler.damga.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Renkler.altin.withAlpha(120)),
                  ),
                  child: Text(
                    'Hak: ${k.aktiviteHakki}/2 | 💰 ${Karakter.paraFormatla(k.bakiye)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Kategori Seçim Sekmeleri (Tabs)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: FaaliyetKategorisi.values.map((kat) {
                final isSelected = kat == _seciliKategori;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(_kategoriBaslik(kat)),
                    selected: isSelected,
                    selectedColor: Renkler.altin,
                    backgroundColor: Renkler.kagitKoyu,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 12,
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

                return Card(
                  color: Renkler.kagitKoyu,
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: yapilabilir ? Renkler.altin.withAlpha(100) : Colors.grey.withAlpha(60),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                f.baslik,
                                style: const TextStyle(
                                  fontFamily: 'Cinzel',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Renkler.altin,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Renkler.altin.withAlpha(30),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${f.akceMaliyeti} Akçe',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Renkler.altin,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          f.aciklama,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '✨ ${f.kazanimOzeti}',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.greenAccent,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: yapilabilir ? Renkler.altin : Colors.grey,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              ),
                              onPressed: yapilabilir
                                  ? () {
                                      final success = widget.motor.faaliyetYurut(f);
                                      if (success) {
                                        widget.onStateChanged();
                                        setState(() {});
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('🕌 ${f.baslik} başarıyla gerçekleştirildi.'),
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
                                            ? 'Max 2 Dükkan'
                                            : 'İcra Et',
                                style: const TextStyle(fontSize: 12, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _kategoriBaslik(FaaliyetKategorisi kat) {
    switch (kat) {
      case FaaliyetKategorisi.saglik:
        return '🏥 Sağlık';
      case FaaliyetKategorisi.ilim:
        return '🎓 İlim';
      case FaaliyetKategorisi.itibar:
        return '👑 İtibar';
      case FaaliyetKategorisi.mulk:
        return '🏪 Mülk';
      case FaaliyetKategorisi.sosyal:
        return '☕ Sosyal';
      case FaaliyetKategorisi.aile:
        return '👨‍👩‍👧‍👦 Aile';
    }
  }
}
