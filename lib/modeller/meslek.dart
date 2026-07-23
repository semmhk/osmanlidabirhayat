class MeslekKademe {
  final String unvan;
  final double gelirCarpan;
  final int minYil;
  final int minZeka;
  final int minItibar;

  const MeslekKademe({
    required this.unvan,
    required this.gelirCarpan,
    this.minYil = 3,
    this.minZeka = 0,
    this.minItibar = 0,
  });
}

class MeslekZinciri {
  final String id;
  final String ad;
  final List<MeslekKademe> kademeler;

  const MeslekZinciri({
    required this.id,
    required this.ad,
    required this.kademeler,
  });
}

class MeslekDeposu {
  static const Map<String, MeslekZinciri> zincirler = {
    'ahilik': MeslekZinciri(
      id: 'ahilik',
      ad: 'Ahilik & Lonca Teşkilatı',
      kademeler: [
        MeslekKademe(unvan: 'Çırak', gelirCarpan: 1.0, minYil: 2, minZeka: 0),
        MeslekKademe(unvan: 'Kalfa', gelirCarpan: 2.0, minYil: 4, minZeka: 40),
        MeslekKademe(unvan: 'Usta', gelirCarpan: 4.0, minYil: 6, minZeka: 60, minItibar: 50),
        MeslekKademe(unvan: 'Lonca Ustabaşısı', gelirCarpan: 7.0, minYil: 99, minZeka: 75, minItibar: 75),
      ],
    ),
    'ilmiye': MeslekZinciri(
      id: 'ilmiye',
      ad: 'İlmiye & Medrese Sınıfı',
      kademeler: [
        MeslekKademe(unvan: 'Talebe', gelirCarpan: 0.8, minYil: 3, minZeka: 50),
        MeslekKademe(unvan: 'Danişmend', gelirCarpan: 2.2, minYil: 4, minZeka: 65),
        MeslekKademe(unvan: 'Müderris', gelirCarpan: 4.5, minYil: 6, minZeka: 80, minItibar: 60),
        MeslekKademe(unvan: 'Kadı', gelirCarpan: 8.0, minYil: 99, minZeka: 90, minItibar: 85),
      ],
    ),
    'seyfiye': MeslekZinciri(
      id: 'seyfiye',
      ad: 'Seyfiye & Askeri Sınıf',
      kademeler: [
        MeslekKademe(unvan: 'Yeni Asker', gelirCarpan: 1.2, minYil: 2, minZeka: 0),
        MeslekKademe(unvan: 'Sipahi', gelirCarpan: 2.5, minYil: 4, minZeka: 45),
        MeslekKademe(unvan: 'Bölükbaşı', gelirCarpan: 4.5, minYil: 6, minZeka: 55, minItibar: 60),
        MeslekKademe(unvan: 'Ağa', gelirCarpan: 7.5, minYil: 99, minZeka: 65, minItibar: 85),
      ],
    ),
    'kalemiye': MeslekZinciri(
      id: 'kalemiye',
      ad: 'Kalemiye & Bürokrasi Sınıfı',
      kademeler: [
        MeslekKademe(unvan: 'Kâtip', gelirCarpan: 1.2, minYil: 3, minZeka: 60),
        MeslekKademe(unvan: 'Halifeler', gelirCarpan: 2.5, minYil: 4, minZeka: 70),
        MeslekKademe(unvan: 'Reisülküttab Yrd.', gelirCarpan: 4.8, minYil: 6, minZeka: 82, minItibar: 65),
        MeslekKademe(unvan: 'Defterdar', gelirCarpan: 8.0, minYil: 99, minZeka: 92, minItibar: 88),
      ],
    ),
  };

  static MeslekZinciri? zincirGetir(String? id) => id != null ? zincirler[id] : null;
}
