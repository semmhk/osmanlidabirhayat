import 'package:flutter/material.dart';
import '../modeller/karakter.dart';

class VesikalikAvatar extends StatelessWidget {
  final int yas;
  final AvatarGenleri? genler;
  final double genislik;
  final double yukseklik;

  const VesikalikAvatar({
    super.key,
    required this.yas,
    this.genler,
    this.genislik = 68,
    this.yukseklik = 84,
  });

  @override
  Widget build(BuildContext context) {
    final activeGenler = genler ?? AvatarGenleri.rastgele();

    return Container(
      width: genislik,
      height: yukseklik,
      decoration: BoxDecoration(
        color: const Color(0xFF2C221B),
        border: Border.all(color: const Color(0xFFD4AF37), width: 2), // Altın rengi çerçeve
        boxShadow: const [
          BoxShadow(
            color: Color(0x60000000),
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _VesikalikPainter(
                yas: yas,
                genler: activeGenler,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withAlpha(25), width: 1),
              ),
            ),
          ),
          // Osmanlı Mührü / Tuğra rozeti
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xFF8B0000).withAlpha(230), // Osmanlı Kırmızısı
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'DEVLET-İ ALİYYE',
                style: TextStyle(
                  color: Color(0xFFF4EBD9),
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VesikalikPainter extends CustomPainter {
  final int yas;
  final AvatarGenleri genler;

  _VesikalikPainter({
    required this.yas,
    required this.genler,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Parşömen Sepya Arka Plan
    final bgPaint = Paint()..color = const Color(0xFFD8C6A6);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final tenRengi = switch (genler.tenTonu) {
      TenTonu.acik => const Color(0xFFFADBC8),
      TenTonu.bugday => const Color(0xFFE8C39E),
      TenTonu.esmer => const Color(0xFFC6997B),
      TenTonu.koyu => const Color(0xFF8D5B4C),
    };

    final sacRengi = switch (genler.sacRengi) {
      SacRengi.siyah => const Color(0xFF1E1E1E),
      SacRengi.kumral => const Color(0xFF6A4E42),
      SacRengi.kahverengi => const Color(0xFF4A3525),
      SacRengi.beyaz => const Color(0xFFE0E0E0),
    };

    final gozIrisRengi = switch (genler.gozRengi) {
      GozRengi.kahverengi => const Color(0xFF4A2E1B),
      GozRengi.siyah => const Color(0xFF111111),
      GozRengi.ela => const Color(0xFF8C6227),
      GozRengi.yesil => const Color(0xFF2E6B4F),
    };

    final center = Offset(size.width / 2, size.height / 2);
    final yuzCenter = Offset(center.dx, size.height * 0.44);
    final isErkek = genler.cinsiyet == Cinsiyet.erkek;

    // 2. Osmanlı Kaftanı / Kıyafet
    final kiyafetPaint = Paint()
      ..color = isErkek ? const Color(0xFF3B2820) : const Color(0xFF5C1B2E);
    final kiyafetPath = Path()
      ..moveTo(size.width * 0.05, size.height)
      ..lineTo(size.width * 0.95, size.height)
      ..lineTo(size.width * 0.82, size.height * 0.65)
      ..lineTo(size.width * 0.18, size.height * 0.65)
      ..close();
    canvas.drawPath(kiyafetPath, kiyafetPaint);

    // Yakalık Altın Sırma
    final altinYakaPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03;
    final yakaPath = Path()
      ..moveTo(size.width * 0.35, size.height * 0.65)
      ..lineTo(size.width * 0.5, size.height * 0.8)
      ..lineTo(size.width * 0.65, size.height * 0.65);
    canvas.drawPath(yakaPath, altinYakaPaint);

    // 3. Boyun
    final tenPaint = Paint()..color = tenRengi;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.38, size.height * 0.5, size.width * 0.24, size.height * 0.18),
      tenPaint,
    );

    // 4. Yüz Şekli Varyasyonları (yuzSekli)
    final yuzW = size.width * 0.50;
    final yuzH = size.height * 0.46;
    final yuzRect = Rect.fromCenter(center: yuzCenter, width: yuzW, height: yuzH);

    final yuzPath = Path();
    if (genler.yuzSekli == YuzSekli.yuvarlak) {
      yuzPath.addOval(yuzRect);
    } else if (genler.yuzSekli == YuzSekli.koseli) {
      yuzPath.addRRect(RRect.fromRectAndRadius(yuzRect, Radius.circular(size.width * 0.14)));
    } else {
      // Oval
      yuzPath.addOval(yuzRect);
    }
    canvas.drawPath(yuzPath, tenPaint);

    // 5. Gözler ve Kaşlar
    final gozY = yuzCenter.dy - size.height * 0.04;
    final solGozX = yuzCenter.dx - size.width * 0.11;
    final sagGozX = yuzCenter.dx + size.width * 0.11;
    final gozRadius = size.width * 0.045;

    // Göz Akı
    final gozAkPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(solGozX, gozY), gozRadius, gozAkPaint);
    canvas.drawCircle(Offset(sagGozX, gozY), gozRadius, gozAkPaint);

    // İris
    final irisPaint = Paint()..color = gozIrisRengi;
    canvas.drawCircle(Offset(solGozX, gozY), gozRadius * 0.65, irisPaint);
    canvas.drawCircle(Offset(sagGozX, gozY), gozRadius * 0.65, irisPaint);

    // Bebek & Işık noktası
    final bebekPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(solGozX, gozY), gozRadius * 0.3, bebekPaint);
    canvas.drawCircle(Offset(sagGozX, gozY), gozRadius * 0.3, bebekPaint);

    // Kaşlar
    final kasPaint = Paint()
      ..color = (yas > 55 ? Colors.grey.shade400 : sacRengi)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.025
      ..strokeCap = StrokeCap.round;

    final solKasPath = Path()
      ..moveTo(solGozX - size.width * 0.06, gozY - size.height * 0.04)
      ..quadraticBezierTo(solGozX, gozY - size.height * 0.06, solGozX + size.width * 0.06, gozY - size.height * 0.04);
    canvas.drawPath(solKasPath, kasPaint);

    final sagKasPath = Path()
      ..moveTo(sagGozX - size.width * 0.06, gozY - size.height * 0.04)
      ..quadraticBezierTo(sagGozX, gozY - size.height * 0.06, sagGozX + size.width * 0.06, gozY - size.height * 0.04);
    canvas.drawPath(sagKasPath, kasPaint);

    // 6. Karakteristik Osmanlı Burnu
    final burunPaint = Paint()
      ..color = const Color(0xFF6E4A35).withAlpha(140)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.02
      ..strokeCap = StrokeCap.round;

    final burunPath = Path()
      ..moveTo(yuzCenter.dx, gozY + size.height * 0.01)
      ..quadraticBezierTo(
        yuzCenter.dx + size.width * 0.04,
        yuzCenter.dy + size.height * 0.03,
        yuzCenter.dx - size.width * 0.02,
        yuzCenter.dy + size.height * 0.06,
      );
    canvas.drawPath(burunPath, burunPaint);

    // 7. Ağaçlanma / Sakal / Bıyık Stilleri
    final sakalColor = (yas > 60
        ? const Color(0xFFF0F0F0)
        : (yas > 45 ? const Color(0xFF888888) : sacRengi));
    final sakalPaint = Paint()..color = sakalColor;

    if (isErkek && genler.biyikSakalVar && yas >= 16) {
      final agizY = yuzCenter.dy + size.height * 0.10;

      if (genler.biyikSakalStili == BiyikSakalStili.palaBiyik) {
        // Görkemli Pala Bıyık
        final biyikPath = Path()
          ..moveTo(yuzCenter.dx - size.width * 0.20, agizY - size.height * 0.01)
          ..quadraticBezierTo(yuzCenter.dx, agizY - size.height * 0.03, yuzCenter.dx + size.width * 0.20, agizY - size.height * 0.01)
          ..quadraticBezierTo(yuzCenter.dx, agizY + size.height * 0.04, yuzCenter.dx - size.width * 0.20, agizY - size.height * 0.01)
          ..close();
        canvas.drawPath(biyikPath, sakalPaint);
      } else if (genler.biyikSakalStili == BiyikSakalStili.pasaSakali) {
        // Heybetli Paşa Sakalı
        final pasaPath = Path()
          ..moveTo(yuzCenter.dx - size.width * 0.22, yuzCenter.dy + size.height * 0.04)
          ..quadraticBezierTo(
            yuzCenter.dx,
            yuzCenter.dy + size.height * 0.25,
            yuzCenter.dx + size.width * 0.22,
            yuzCenter.dy + size.height * 0.04,
          )
          ..close();
        canvas.drawPath(pasaPath, sakalPaint);
      } else if (genler.biyikSakalStili == BiyikSakalStili.cemberSakal) {
        // Çember Sakal
        final cemberPath = Path()
          ..moveTo(yuzCenter.dx - size.width * 0.18, yuzCenter.dy + size.height * 0.06)
          ..quadraticBezierTo(
            yuzCenter.dx,
            yuzCenter.dy + size.height * 0.18,
            yuzCenter.dx + size.width * 0.18,
            yuzCenter.dy + size.height * 0.06,
          )
          ..lineTo(yuzCenter.dx + size.width * 0.14, yuzCenter.dy + size.height * 0.04)
          ..quadraticBezierTo(
            yuzCenter.dx,
            yuzCenter.dy + size.height * 0.12,
            yuzCenter.dx - size.width * 0.14,
            yuzCenter.dy + size.height * 0.04,
          )
          ..close();
        canvas.drawPath(cemberPath, sakalPaint);
      } else {
        // Kirli Sakal
        final kirliPaint = Paint()
          ..color = sakalColor.withAlpha(160)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(yuzCenter.dx, yuzCenter.dy + size.height * 0.14), size.width * 0.12, kirliPaint);
      }
    }

    // 8. Osmanlı Baş Giyimi (Fes / Sarık / Takke / Yaşmak)
    if (isErkek) {
      if (genler.basGiyimi == BasGiyimi.fes || yas < 40) {
        // Kırmızı Osmanlı Fesi ve Siyah Püskül
        final fesPaint = Paint()..color = const Color(0xFF8B0000);
        final fesRect = Rect.fromLTWH(
          yuzCenter.dx - size.width * 0.24,
          yuzCenter.dy - size.height * 0.28,
          size.width * 0.48,
          size.height * 0.22,
        );
        canvas.drawRRect(RRect.fromRectAndRadius(fesRect, Radius.circular(size.width * 0.04)), fesPaint);

        // Fes Altın Şerit & Püskül
        final puskulPaint = Paint()
          ..color = Colors.black
          ..strokeWidth = size.width * 0.02;
        canvas.drawLine(
          Offset(yuzCenter.dx + size.width * 0.15, yuzCenter.dy - size.height * 0.26),
          Offset(yuzCenter.dx + size.width * 0.24, yuzCenter.dy - size.height * 0.12),
          puskulPaint,
        );
      } else if (genler.basGiyimi == BasGiyimi.sarik) {
        // Beyaz Osmanlı Sarığı
        final sarikPaint = Paint()..color = const Color(0xFFFAFAFA);
        canvas.drawCircle(
          Offset(yuzCenter.dx, yuzCenter.dy - size.height * 0.20),
          size.width * 0.28,
          sarikPaint,
        );
        final sarikKavukPaint = Paint()..color = const Color(0xFF8B0000);
        canvas.drawCircle(
          Offset(yuzCenter.dx, yuzCenter.dy - size.height * 0.22),
          size.width * 0.14,
          sarikKavukPaint,
        );
      } else {
        // Nakışlı Takke
        final takkePaint = Paint()..color = const Color(0xFF2E6B4F);
        final takkeRect = Rect.fromLTWH(
          yuzCenter.dx - size.width * 0.24,
          yuzCenter.dy - size.height * 0.22,
          size.width * 0.48,
          size.height * 0.16,
        );
        canvas.drawRRect(RRect.fromRectAndRadius(takkeRect, Radius.circular(size.width * 0.1)), takkePaint);
      }
    } else {
      // Kadınlar: Osmanlı Yaşmak ve Hotoz Örtüsü
      final yasmakPaint = Paint()..color = const Color(0xFFF5F0E6);
      canvas.drawCircle(
        Offset(yuzCenter.dx, yuzCenter.dy - size.height * 0.16),
        size.width * 0.30,
        yasmakPaint,
      );
      final altinTaciPaint = Paint()
        ..color = const Color(0xFFD4AF37)
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.03;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(yuzCenter.dx, yuzCenter.dy - size.height * 0.16), radius: size.width * 0.28),
        3.14,
        3.14,
        false,
        altinTaciPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _VesikalikPainter oldDelegate) =>
      oldDelegate.yas != yas || oldDelegate.genler != genler;
}
