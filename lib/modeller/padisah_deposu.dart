class Padisah {
  final String isim;
  final int baslangic;
  final int bitis;

  const Padisah({
    required this.isim,
    required this.baslangic,
    required this.bitis,
  });
}

class Donem {
  final String id;
  final String ad;
  final int yilMin;
  final int yilMax;
  final List<Padisah> padisahlar;

  const Donem({
    required this.id,
    required this.ad,
    required this.yilMin,
    required this.yilMax,
    this.padisahlar = const [],
  });
}

class PadisahDeposu {
  static const Map<String, Donem> donemler = {
    'kurulus': Donem(
      id: 'kurulus',
      ad: 'Kuruluş Dönemi',
      yilMin: 1299,
      yilMax: 1453,
      padisahlar: [
        Padisah(isim: 'Osman Gazi', baslangic: 1299, bitis: 1326),
        Padisah(isim: 'Orhan Gazi', baslangic: 1326, bitis: 1359),
        Padisah(isim: 'I. Murad (Hüdavendigar)', baslangic: 1359, bitis: 1389),
        Padisah(isim: 'Yıldırım Bayezid', baslangic: 1389, bitis: 1402),
        Padisah(isim: 'Fetret Devri (taht boşluğu)', baslangic: 1402, bitis: 1413),
        Padisah(isim: 'I. Mehmed (Çelebi Mehmed)', baslangic: 1413, bitis: 1421),
        Padisah(isim: 'II. Murad', baslangic: 1421, bitis: 1451),
      ],
    ),
    'yukselme': Donem(
      id: 'yukselme',
      ad: 'Yükselme Dönemi',
      yilMin: 1453,
      yilMax: 1579,
    ),
    'duraklama': Donem(
      id: 'duraklama',
      ad: 'Duraklama Dönemi',
      yilMin: 1579,
      yilMax: 1699,
    ),
    'gerileme': Donem(
      id: 'gerileme',
      ad: 'Gerileme Dönemi',
      yilMin: 1699,
      yilMax: 1792,
    ),
    'dagilma': Donem(
      id: 'dagilma',
      ad: 'Dağılma Dönemi',
      yilMin: 1792,
      yilMax: 1922,
    ),
  };

  /// Verilen takvim yılına denk gelen Dönem nesnesini döner
  static Donem? donemBul(int takvimYili) {
    for (final donem in donemler.values) {
      if (takvimYili >= donem.yilMin && takvimYili <= donem.yilMax) {
        return donem;
      }
    }
    return null;
  }

  /// Verilen takvim yılına denk gelen Padişah veya Dönem adını döner
  static Padisah? padisahBul(int takvimYili) {
    final donem = donemBul(takvimYili);
    if (donem == null) return null;
    for (final p in donem.padisahlar) {
      if (takvimYili >= p.baslangic && takvimYili <= p.bitis) {
        return p;
      }
    }
    return null;
  }

  /// Takvim yılına göre padişah veya dönem açıklama metni döner
  static String donemVePadisahUnvani(int takvimYili) {
    final padisah = padisahBul(takvimYili);
    if (padisah != null) {
      return '${padisah.isim} Dönemi';
    }
    final donem = donemBul(takvimYili);
    if (donem != null) {
      return donem.ad;
    }
    return 'Osmanlı Devri';
  }
}
