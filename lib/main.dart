import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ekranlar/ana_menu_ekrani.dart';
import 'sabitler/renkler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const OsmanlidaBirHayatApp());
}

class OsmanlidaBirHayatApp extends StatelessWidget {
  const OsmanlidaBirHayatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Osmanlı\'da Bir Hayat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Renkler.kagitKoyu,
        primaryColor: Renkler.damga,
        fontFamily: 'Roboto',
      ),
      home: const AnaMenuEkrani(),
    );
  }
}
