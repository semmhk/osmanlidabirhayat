enum FaaliyetKategorisi { saglik, ilim, itibar, mulk, sosyal, aile }

class Faaliyet {
  final String id;
  final String baslik;
  final FaaliyetKategorisi kategori;
  final int akceMaliyeti;
  final String aciklama;
  final String kazanimOzeti;
  final int minYas;
  final bool gerekliMeslek;
  final bool gerekliEs;
  final bool gerekliCocuk;
  final bool gerekliAile;

  const Faaliyet({
    required this.id,
    required this.baslik,
    required this.kategori,
    required this.akceMaliyeti,
    required this.aciklama,
    required this.kazanimOzeti,
    this.minYas = 0,
    this.gerekliMeslek = false,
    this.gerekliEs = false,
    this.gerekliCocuk = false,
    this.gerekliAile = false,
  });
}

class FaaliyetDeposu {
  static const List<Faaliyet> tumFaaliyetler = [
    Faaliyet(
      id: 'saglik_darussifa',
      baslik: 'Darüşşifada Hekime Muayene',
      kategori: FaaliyetKategorisi.saglik,
      akceMaliyeti: 35,
      aciklama: 'Devlet-i Aliyye darüşşifasında nabız saydırıp şifalı iksirler almak.',
      kazanimOzeti: 'Sağlık +8 (Azalan Getiri)',
      minYas: 5,
    ),
    Faaliyet(
      id: 'saglik_mesir',
      baslik: 'Aktardan Şifalı Mesir Macunu',
      kategori: FaaliyetKategorisi.saglik,
      akceMaliyeti: 15,
      aciklama: 'Manisa usulü 41 çeşit baharatlı şifalı macun tüketmek.',
      kazanimOzeti: 'Sağlık +4, Mutluluk +3',
      minYas: 5,
    ),
    Faaliyet(
      id: 'ilim_medrese',
      baslik: 'Medresede İlim / Ders Almak',
      kategori: FaaliyetKategorisi.ilim,
      akceMaliyeti: 45,
      aciklama: 'Müderris huzurunda mantık, riyaziye ve kelam derslerine katılmak.',
      kazanimOzeti: 'Zeka +8 (Azalan Getiri)',
      minYas: 10,
    ),
    Faaliyet(
      id: 'ilim_istinsah',
      baslik: 'Yazma Kitap İstinsah Ettirmek',
      kategori: FaaliyetKategorisi.ilim,
      akceMaliyeti: 65,
      aciklama: 'Hattata tefsir veya tarih risalesi yazdırmak.',
      kazanimOzeti: 'Zeka +10 (Azalan Getiri)',
      minYas: 14,
    ),
    Faaliyet(
      id: 'ilim_meclis',
      baslik: 'Âlimler Meclisine Katılmak',
      kategori: FaaliyetKategorisi.ilim,
      akceMaliyeti: 30,
      aciklama: 'Konakta ulema ve şairlerin ilmi sohbetlerine bizzat iştirak etmek.',
      kazanimOzeti: 'Zeka +4, İtibar +3',
      minYas: 18,
    ),
    Faaliyet(
      id: 'itibar_imaret',
      baslik: 'İmaret & Çeşme Bağışı',
      kategori: FaaliyetKategorisi.itibar,
      akceMaliyeti: 100,
      aciklama: 'Fukara ve gariplere çorba dağıtmak, mahalle çeşmesini ihya etmek.',
      kazanimOzeti: 'İtibar +10 (Azalan Getiri), Mutluluk +4',
      minYas: 16,
    ),
    Faaliyet(
      id: 'itibar_lonca',
      baslik: 'Lonca Toplantısına Katılmak',
      kategori: FaaliyetKategorisi.itibar,
      akceMaliyeti: 25,
      aciklama: 'Ahilik ve esnaf loncasında kethüda huzurunda pir sofrasına oturmak.',
      kazanimOzeti: 'İtibar +5',
      minYas: 16,
      gerekliMeslek: true,
    ),
    Faaliyet(
      id: 'itibar_tekke',
      baslik: 'Tekke & Cami İkramı',
      kategori: FaaliyetKategorisi.itibar,
      akceMaliyeti: 30,
      aciklama: 'Cuma namazı çıkışı şerbet dağıtıp dervişan meclisine katılmak.',
      kazanimOzeti: 'İtibar +4, Mutluluk +4',
      minYas: 10,
    ),
    Faaliyet(
      id: 'mulk_dukkan',
      baslik: 'Dükkan / Akar Satın Al',
      kategori: FaaliyetKategorisi.mulk,
      akceMaliyeti: 250,
      aciklama: 'Çarşıda dükkan satın alıp kiraya vermek (Sert Limit: Max 2 Dükkan).',
      kazanimOzeti: 'Net Pasif Gelir +10 Akçe/yıl',
      minYas: 18,
    ),
    Faaliyet(
      id: 'mulk_kervan',
      baslik: 'Kervan Ticaretine Ortak Ol',
      kategori: FaaliyetKategorisi.mulk,
      akceMaliyeti: 150,
      aciklama: 'İpek yolu kervanına sermaye yatırmak (Kayıp Riski Var).',
      kazanimOzeti: '%70 İhtimal +240 Akçe / %30 Risk -150 Akçe',
      minYas: 18,
    ),
    Faaliyet(
      id: 'sosyal_kahve',
      baslik: 'Semt Kahvehanesinde Sohbet',
      kategori: FaaliyetKategorisi.sosyal,
      akceMaliyeti: 10,
      aciklama: 'Nargile ve dibek kahvesi eşliğinde meddah hikayesi dinlemek.',
      kazanimOzeti: 'Mutluluk +6, İtibar +1',
      minYas: 15,
    ),
    Faaliyet(
      id: 'sosyal_hamam',
      baslik: 'Tarihi Hamam Sefası',
      kategori: FaaliyetKategorisi.sosyal,
      akceMaliyeti: 20,
      aciklama: 'Göbek taşında terleyip tellak hizmetiyle ferahlamak.',
      kazanimOzeti: 'Sağlık +3, Mutluluk +6',
      minYas: 5,
    ),
    Faaliyet(
      id: 'aile_sofrasi',
      baslik: 'Aile Sofrası & Ziyaret',
      kategori: FaaliyetKategorisi.aile,
      akceMaliyeti: 60,
      aciklama: 'Hane halkını toplayıp tepsi kebabı ve baklava ikram etmek.',
      kazanimOzeti: 'Tüm Aile Yakınlığı +2, Mutluluk +5',
      minYas: 18,
      gerekliAile: true,
    ),
    Faaliyet(
      id: 'aile_gezinti',
      baslik: 'Eşle Mesire & Gezinti',
      kategori: FaaliyetKategorisi.aile,
      akceMaliyeti: 35,
      aciklama: 'Boğaziçi veya Çamlıca mesiresinde eşle vakfe yapmak.',
      kazanimOzeti: 'Eş Yakınlığı +15, Mutluluk +6',
      minYas: 18,
      gerekliEs: true,
    ),
    Faaliyet(
      id: 'aile_egitim',
      baslik: 'Çocuğu Medreseye/Loncaya Ver',
      kategori: FaaliyetKategorisi.aile,
      akceMaliyeti: 50,
      aciklama: 'Çocuğun eğitim tahsisatını ödeyip ustasına teslim etmek.',
      kazanimOzeti: 'Çocuk Eğitimi +20, Yakınlık +10',
      minYas: 25,
      gerekliCocuk: true,
    ),
  ];
}
