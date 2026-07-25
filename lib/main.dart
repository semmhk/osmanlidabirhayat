import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'ekranlar/ana_menu_ekrani.dart';
import 'sabitler/stiller.dart';

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
        scaffoldBackgroundColor: Stiller.sepyaArkaplan,
        primaryColor: Stiller.altinSarisi,
        textTheme: GoogleFonts.loraTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home: const AnaMenuEkrani(),
    );
  }
}
