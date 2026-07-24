class Padisah {
  final String id;
  final String isim;
  final int baslangic;
  final int bitis;
  final String? tugraGorsel;

  const Padisah({
    required this.id,
    required this.isim,
    required this.baslangic,
    required this.bitis,
    this.tugraGorsel,
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
  static const int imparatorlukSonYili = 1922;

  static const Map<String, Donem> donemler = {
    'kurulus': Donem(
      id: 'kurulus',
      ad: 'Kuruluş Dönemi',
      yilMin: 1299,
      yilMax: 1453,
      padisahlar: [
        Padisah(id: 'osman1', isim: 'Osman Gazi', baslangic: 1299, bitis: 1326, tugraGorsel: null),
        Padisah(id: 'orhan', isim: 'Orhan Gazi', baslangic: 1326, bitis: 1359, tugraGorsel: 'assets/tugralar/orhan.png'),
        Padisah(id: 'murad1', isim: 'I. Murad (Hüdavendigar)', baslangic: 1359, bitis: 1389, tugraGorsel: 'assets/tugralar/murad1.png'),
        Padisah(id: 'bayezid1', isim: 'Yıldırım Bayezid', baslangic: 1389, bitis: 1402, tugraGorsel: 'assets/tugralar/bayezid1.png'),
        Padisah(id: 'fetret', isim: 'Fetret Devri (taht boşluğu)', baslangic: 1402, bitis: 1413, tugraGorsel: null),
        Padisah(id: 'mehmed1', isim: 'I. Mehmed (Çelebi Mehmed)', baslangic: 1413, bitis: 1421, tugraGorsel: 'assets/tugralar/mehmed1.png'),
        Padisah(id: 'murad2', isim: 'II. Murad', baslangic: 1421, bitis: 1451, tugraGorsel: 'assets/tugralar/murad2.png'),
      ],
    ),
    'yukselme': Donem(
      id: 'yukselme',
      ad: 'Yükselme Dönemi',
      yilMin: 1453,
      yilMax: 1579,
      padisahlar: [
        Padisah(id: 'mehmed2', isim: 'II. Mehmed (Fatih Sultan Mehmed)', baslangic: 1451, bitis: 1481, tugraGorsel: 'assets/tugralar/mehmed2.png'),
        Padisah(id: 'bayezid2', isim: 'II. Bayezid', baslangic: 1481, bitis: 1512, tugraGorsel: 'assets/tugralar/bayezid2.png'),
        Padisah(id: 'selim1', isim: 'I. Selim (Yavuz Sultan Selim)', baslangic: 1512, bitis: 1520, tugraGorsel: 'assets/tugralar/selim1.png'),
        Padisah(id: 'suleyman1', isim: 'I. Süleyman (Kanuni Sultan Süleyman)', baslangic: 1520, bitis: 1566, tugraGorsel: 'assets/tugralar/suleyman1.png'),
        Padisah(id: 'selim2', isim: 'II. Selim (Sarı Selim)', baslangic: 1566, bitis: 1574, tugraGorsel: 'assets/tugralar/selim2.png'),
      ],
    ),
    'duraklama': Donem(
      id: 'duraklama',
      ad: 'Duraklama Dönemi',
      yilMin: 1579,
      yilMax: 1699,
      padisahlar: [
        Padisah(id: 'murad3', isim: 'III. Murad', baslangic: 1574, bitis: 1595, tugraGorsel: 'assets/tugralar/murad3.png'),
        Padisah(id: 'mehmed3', isim: 'III. Mehmed', baslangic: 1595, bitis: 1603, tugraGorsel: 'assets/tugralar/mehmed3.png'),
        Padisah(id: 'ahmed1', isim: 'I. Ahmed', baslangic: 1603, bitis: 1617, tugraGorsel: 'assets/tugralar/ahmed1.png'),
        Padisah(id: 'mustafa1', isim: 'I. Mustafa', baslangic: 1617, bitis: 1618, tugraGorsel: 'assets/tugralar/mustafa1.png'),
        Padisah(id: 'osman2', isim: 'II. Osman (Genç Osman)', baslangic: 1618, bitis: 1622, tugraGorsel: 'assets/tugralar/osman2.png'),
        Padisah(id: 'mustafa1_2', isim: 'I. Mustafa (2. Dönem)', baslangic: 1622, bitis: 1623, tugraGorsel: 'assets/tugralar/mustafa1.png'),
        Padisah(id: 'murad4', isim: 'IV. Murad', baslangic: 1623, bitis: 1640, tugraGorsel: 'assets/tugralar/murad4.png'),
        Padisah(id: 'ibrahim', isim: 'Sultan İbrahim', baslangic: 1640, bitis: 1648, tugraGorsel: 'assets/tugralar/ibrahim.png'),
        Padisah(id: 'mehmed4', isim: 'IV. Mehmed (Avcı Mehmed)', baslangic: 1648, bitis: 1687, tugraGorsel: 'assets/tugralar/mehmed4.png'),
        Padisah(id: 'suleyman2', isim: 'II. Süleyman', baslangic: 1687, bitis: 1691, tugraGorsel: 'assets/tugralar/suleyman2.png'),
        Padisah(id: 'ahmed2', isim: 'II. Ahmed', baslangic: 1691, bitis: 1695, tugraGorsel: 'assets/tugralar/ahmed2.png'),
        Padisah(id: 'mustafa2', isim: 'II. Mustafa', baslangic: 1695, bitis: 1703, tugraGorsel: 'assets/tugralar/mustafa2.png'),
      ],
    ),
    'gerileme': Donem(
      id: 'gerileme',
      ad: 'Gerileme Dönemi',
      yilMin: 1699,
      yilMax: 1792,
      padisahlar: [
        Padisah(id: 'ahmed3', isim: 'III. Ahmed', baslangic: 1703, bitis: 1730, tugraGorsel: 'assets/tugralar/ahmed3.png'),
        Padisah(id: 'mahmud1', isim: 'I. Mahmud', baslangic: 1730, bitis: 1754, tugraGorsel: 'assets/tugralar/mahmud1.png'),
        Padisah(id: 'osman3', isim: 'III. Osman', baslangic: 1754, bitis: 1757, tugraGorsel: 'assets/tugralar/osman3.png'),
        Padisah(id: 'mustafa3', isim: 'III. Mustafa', baslangic: 1757, bitis: 1774, tugraGorsel: 'assets/tugralar/mustafa3.png'),
        Padisah(id: 'abdulhamid1', isim: 'I. Abdülhamid', baslangic: 1774, bitis: 1789, tugraGorsel: 'assets/tugralar/abdulhamid1.png'),
        Padisah(id: 'selim3', isim: 'III. Selim', baslangic: 1789, bitis: 1807, tugraGorsel: 'assets/tugralar/selim3.png'),
      ],
    ),
    'dagilma': Donem(
      id: 'dagilma',
      ad: 'Dağılma Dönemi',
      yilMin: 1792,
      yilMax: 1922,
      padisahlar: [
        Padisah(id: 'mustafa4', isim: 'IV. Mustafa', baslangic: 1807, bitis: 1808, tugraGorsel: 'assets/tugralar/mustafa4.png'),
        Padisah(id: 'mahmud2', isim: 'II. Mahmud', baslangic: 1808, bitis: 1839, tugraGorsel: 'assets/tugralar/mahmud2.png'),
        Padisah(id: 'abdulmecid1', isim: 'Sultan Abdülmecid', baslangic: 1839, bitis: 1861, tugraGorsel: 'assets/tugralar/abdulmecid1.png'),
        Padisah(id: 'abdulaziz', isim: 'Sultan Abdülaziz', baslangic: 1861, bitis: 1876, tugraGorsel: 'assets/tugralar/abdulaziz.png'),
        Padisah(id: 'murad5', isim: 'V. Murad', baslangic: 1876, bitis: 1876, tugraGorsel: 'assets/tugralar/murad5.png'),
        Padisah(id: 'abdulhamid2', isim: 'II. Abdülhamid', baslangic: 1876, bitis: 1909, tugraGorsel: 'assets/tugralar/abdulhamid2.png'),
        Padisah(id: 'mehmed5', isim: 'V. Mehmed (Reşad)', baslangic: 1909, bitis: 1918, tugraGorsel: 'assets/tugralar/mehmed5.png'),
        Padisah(id: 'mehmed6', isim: 'VI. Mehmed (Vahdeddin)', baslangic: 1918, bitis: 1922, tugraGorsel: 'assets/tugralar/mehmed6.png'),
      ],
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

  /// Verilen takvim yılına denk gelen Padişahı döner
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
