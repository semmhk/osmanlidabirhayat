import '../modeller/karakter.dart';

abstract class OzetUretici {
  static String lakapUret(Karakter k) {
    if (k.bakiye >= 500) return "Karun Misali";
    if (k.bakiye >= 200) return "Tuzu Kuru Efendi";
    if (k.itibar > 75) return "Ahalinin Sevgilisi";
    if (k.zeka > 75) return "Allame-i Cihan";
    if (k.mutluluk > 75) return "Gönül Ehli";
    if (k.bakiye < -50) return "Borçlu Fakir";
    if (k.itibar < 15) return "Bednam";
    return "Sıradan Reaya";
  }

  static String mahalleNotuUret(Karakter k) {
    String not;
    if (k.itibar > 70 && k.bakiye < 50) {
      not = "Akçesi azdı ama kahvede sözü geçerdi. Cenazesi kalabalıktı.";
    } else if (k.bakiye > 200 && k.itibar < 40) {
      not = "Zengindi ama selamı pahalıydı. Mahalleli helvalığına ortak oldu.";
    } else if (k.mutluluk > 70) {
      not = "Çehresi daima gülerdi. Komşular bile hüzünlendi.";
    } else if (k.zeka > 70) {
      not = "'Okumuş, alim kimsedir' dediler. Kitapları medreseye bağışlandı.";
    } else {
      not = "İyi bir kuldu. Kahvesini taze içer, mahalleliyle iyi geçinirdi.";
    }

    final unvan = k.meslekUnvaniGetir();
    if (unvan != 'İşsiz' && unvan != 'Talebe' && unvan != 'Çocuk') {
      not += " Ömrü boyunca $unvan olarak hizmet verdi.";
    }

    if (k.bayraklar.contains('ikinci_evlilik') && k.esAdi != null) {
      if (k.cocukAdlari.isNotEmpty) {
        not += " İki kez dirlik kurdu, ikinci baharında eşi ${k.esAdi} ve ${k.cocukAdlari.length} evladıyla huzura erdi.";
      } else {
        not += " İki kez dirlik kurdu, ikinci baharında eşi ${k.esAdi} ile huzur buldu.";
      }
    } else if (k.bayraklar.contains('dul_bosanmis') && k.esAdi == null) {
      not += " Kısmet ve vefat sonrası kalan ömrünü yalnız tamamladı.";
    } else if (k.esAdi != null && k.cocukAdlari.isNotEmpty) {
      not += " Eşi ${k.esAdi} ve ${k.cocukAdlari.length} evladıyla mülkünde güzel bir ömür sürdü.";
    } else if (k.esAdi != null) {
      not += " Eşi ${k.esAdi} ile aynı yastıkta kocadı.";
    }

    return not;
  }

  static String olumOzetiUret(Karakter k) {
    final lakap = lakapUret(k);
    final not = mahalleNotuUret(k);
    final bakiyeFormatli = Karakter.paraFormatla(k.bakiye);
    final unvan = k.meslekUnvaniGetir();
    final olumNedeniMetni = k.olumNedeni ?? 'Ecel / Yaşlılığa bağlı doğal ölüm';

    return '''ADI SOYADI : ${k.isim}
YAŞADIĞI   : ${k.yas} yıl (${k.takvimYili})
ÖLÜM NEDENİ: $olumNedeniMetni
LAKABI     : "$lakap"
MESLEĞİ    : $unvan

SON DURUM  :
  Sağlık ${k.saglik} · Mutluluk ${k.mutluluk} · Zeka ${k.zeka}
  Bakiye $bakiyeFormatli · İtibar ${k.itibar}

MAHALLE NOTU:
$not

Hakk'ın rahmetine kavuştu. Ruhuna Fatiha.''';
  }
}
