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
    this.genislik = 56,
    this.yukseklik = 68,
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
            blurRadius: 3,
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
                border: Border.all(color: Colors.black.withAlpha(30), width: 1),
              ),
            ),
          ),
          // Osmanlı Mührü / Tuğra rozeti
          Positioned(
            bottom: 2,
            right: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              decoration: BoxDecoration(
                color: const Color(0xFF8B0000).withAlpha(220), // Osmanlı Kırmızısı
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'DEVLET-İ ALİYYE',
                style: TextStyle(
                  color: Color(0xFFF4EBD9),
                  fontSize: 5.5,
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
    // Parşömen Sepya Arka Plan
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
      SacRengi.beyaz => const Color(0xFFDCDCDC),
    };

    final center = Offset(size.width / 2, size.height / 2);

    // Omuzlar / Kıyafet
    final kiyafetPaint = Paint()..color = const Color(0xFF4A3B32);
    final path = Path()
      ..moveTo(size.width * 0.1, size.height)
      ..lineTo(size.width * 0.9, size.height)
      ..lineTo(size.width * 0.8, size.height * 0.65)
      ..lineTo(size.width * 0.2, size.height * 0.65)
      ..close();
    canvas.drawPath(path, kiyafetPaint);

    // Boyun
    final tenPaint = Paint()..color = tenRengi;
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.4, size.height * 0.5, size.width * 0.2, size.height * 0.18),
      tenPaint,
    );

    // Yüz
    final yuzRadius = size.width * 0.25;
    final yuzCenter = Offset(center.dx, size.height * 0.42);
    canvas.drawCircle(yuzCenter, yuzRadius, tenPaint);

    // Gözler
    final gozPaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(yuzCenter.dx - 5, yuzCenter.dy - 2), 1.8, gozPaint);
    canvas.drawCircle(Offset(yuzCenter.dx + 5, yuzCenter.dy - 2), 1.8, gozPaint);

    // Sakal / Bıyık
    if (genler.biyikSakalVar && genler.cinsiyet == Cinsiyet.erkek) {
      final sakalPaint = Paint()..color = (yas > 55 ? Colors.white70 : sacRengi);
      final sakalPath = Path()
        ..moveTo(yuzCenter.dx - 8, yuzCenter.dy + 4)
        ..quadraticBezierTo(yuzCenter.dx, yuzCenter.dy + 16, yuzCenter.dx + 8, yuzCenter.dy + 4)
        ..close();
      canvas.drawPath(sakalPath, sakalPaint);
    }

    // Saç / Sarık / Fes Dokusu
    final sacPaint = Paint()..color = (yas > 60 ? Colors.grey.shade400 : sacRengi);
    if (genler.sacStili != SacStili.kel) {
      final sacArc = Rect.fromCircle(center: Offset(yuzCenter.dx, yuzCenter.dy - 4), radius: yuzRadius);
      canvas.drawArc(sacArc, 3.14, 3.14, true, sacPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _VesikalikPainter oldDelegate) =>
      oldDelegate.yas != yas || oldDelegate.genler != genler;
}
