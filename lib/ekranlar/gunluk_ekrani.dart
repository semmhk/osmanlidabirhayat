import 'package:flutter/material.dart';
import '../bilesenler/vesikalik_avatar.dart';
import '../modeller/karakter.dart';
import '../sabitler/renkler.dart';

class GunlukEkrani extends StatelessWidget {
  final Karakter karakter;

  const GunlukEkrani({super.key, required this.karakter});

  @override
  Widget build(BuildContext context) {
    final gunlukListesi = karakter.gunluk;

    return Scaffold(
      backgroundColor: Renkler.kagitKoyu,
      body: Stack(
        children: [
          // Parşömen dokusu arka plan bindirmesi
          Positioned.fill(
            child: Image.asset(
              'assets/arkaplan/parsomen_doku.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.12),
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Üst Başlık Çubuğu
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Renkler.kagit,
                    border: const Border(
                      bottom: BorderSide(color: Renkler.altin, width: 2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(80),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Renkler.damga),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📖 ${karakter.isim} — HAYAT GÜNLÜĞÜ',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Renkler.damga,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              'Takvim Yılı: ${karakter.takvimYili} | ${karakter.yas} Yaşında (${gunlukListesi.length} Kayıt)',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Renkler.murekkepSoluk,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // OSMANLI HÜVİYET KARTI (Büyük Dev Vesikalık Avatar & Kimlik Kartı)
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Renkler.kagitGetirYasaGore(karakter.yas),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Renkler.altin, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(60),
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Dev 110x135 Piksel Vesikalık Avatar
                      VesikalikAvatar(
                        yas: karakter.yas,
                        genler: karakter.genler,
                        genislik: 110,
                        yukseklik: 135,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Renkler.damga,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'DEVLET-İ ALİYYE HÜVİYET CÜZDANI',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              karakter.isim,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Renkler.murekkep,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '💼 ${karakter.meslekUnvaniGetir()}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Renkler.murekkepSoluk,
                              ),
                            ),
                            const Divider(color: Renkler.cizgi, height: 12),
                            Text(
                              '📅 Doğum: ${karakter.dogumYili} | Nesil: #${karakter.nesil}',
                              style: const TextStyle(fontSize: 11, color: Renkler.murekkep),
                            ),
                            Text(
                              '💰 Servet: ${Karakter.paraFormatla(karakter.bakiye)}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Renkler.pozitifRengi,
                              ),
                            ),
                            if (karakter.esAdi != null)
                              Text(
                                '💍 Eş: ${karakter.esAdi}',
                                style: const TextStyle(fontSize: 11, color: Renkler.murekkep),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Günlük Listesi
                Expanded(
                  child: gunlukListesi.isEmpty
                      ? Center(
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            margin: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Renkler.kagit,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Renkler.altin, width: 1.5),
                            ),
                            child: const Text(
                              'Henüz kayıtlı bir günlük girdisi yok.',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Renkler.murekkepSoluk,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          itemCount: gunlukListesi.length,
                          itemBuilder: (context, index) {
                            final girdi = gunlukListesi[index];
                            final isEnSon = (index == 0);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isEnSon
                                    ? Renkler.kagitGetirYasaGore(karakter.yas)
                                    : Renkler.kagit.withAlpha(220),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isEnSon ? Renkler.altin : Renkler.cizgi,
                                  width: isEnSon ? 2 : 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(40),
                                    blurRadius: 3,
                                    offset: const Offset(1, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isEnSon ? Renkler.damga : Renkler.murekkepSoluk,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '#${gunlukListesi.length - index}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      girdi,
                                      style: TextStyle(
                                        fontSize: 13,
                                        height: 1.4,
                                        fontWeight: isEnSon ? FontWeight.w600 : FontWeight.normal,
                                        color: Renkler.murekkep,
                                      ),
                                    ),
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
        ],
      ),
    );
  }
}
