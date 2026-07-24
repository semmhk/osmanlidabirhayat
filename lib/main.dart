import 'package:flutter/material.dart';
import 'ekranlar/oyun_ekrani.dart';
import 'modeller/olay.dart';
import 'motor/olay_yukleyici.dart';
import 'motor/oyun_motoru.dart';
import 'sabitler/renkler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final yukleyici = OlayYukleyici();
  final tumOlaylar = await yukleyici.tumunuYukle();

  runApp(OsmanlidaBirHayatApp(tumOlaylar: tumOlaylar));
}

class OsmanlidaBirHayatApp extends StatelessWidget {
  final List<Olay> tumOlaylar;

  const OsmanlidaBirHayatApp({super.key, required this.tumOlaylar});

  @override
  Widget build(BuildContext context) {
    final motor = OyunMotoru(tumOlaylar: tumOlaylar);
    motor.yilYasa(); // İlk yılı başlat

    return MaterialApp(
      title: 'Osmanlı\'da Bir Hayat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Renkler.kagitKoyu,
        primaryColor: Renkler.damga,
        fontFamily: 'Roboto',
      ),
      home: OyunEkrani(motor: motor),
    );
  }
}
