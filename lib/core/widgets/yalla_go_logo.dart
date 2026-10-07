import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class YallaGoLogo extends StatelessWidget {
  const YallaGoLogo({
    super.key,
    this.size = 86,
    this.showName = true,
    this.darkBackground = false,
  });

  final double size;
  final bool showName;
  final bool darkBackground;

  @override
  Widget build(BuildContext context) {
    final nameColor = darkBackground ? AppColors.white : AppColors.navy;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _LogoPainter()),
        ),
        if (showName) ...[
          SizedBox(height: size * .14),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: size * .34,
                height: 1,
                fontWeight: FontWeight.w900,
                letterSpacing: -1.2,
              ),
              children: [
                TextSpan(text: 'Yalla ', style: TextStyle(color: nameColor)),
                const TextSpan(text: 'Go', style: TextStyle(color: AppColors.turquoise)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final center = Offset(size.width / 2, size.height / 2);
    final navy = Paint()..color = AppColors.navy;
    final teal = Paint()..color = AppColors.turquoise;
    final white = Paint()..color = AppColors.white;

    canvas.drawCircle(center, s * .48, white);

    final outer = Path()
      ..moveTo(s * .13, s * .26)
      ..quadraticBezierTo(s * .50, s * -.02, s * .87, s * .26)
      ..lineTo(s * .75, s * .39)
      ..quadraticBezierTo(s * .50, s * .20, s * .25, s * .39)
      ..close();
    canvas.drawPath(outer, navy);

    final left = Path()
      ..moveTo(s * .10, s * .31)
      ..quadraticBezierTo(s * .26, s * .48, s * .43, s * .57)
      ..lineTo(s * .43, s * .90)
      ..quadraticBezierTo(s * .17, s * .70, s * .10, s * .31)
      ..close();
    canvas.drawPath(left, navy);

    final road = Path()
      ..moveTo(s * .90, s * .30)
      ..quadraticBezierTo(s * .63, s * .45, s * .54, s * .91)
      ..lineTo(s * .43, s * .91)
      ..lineTo(s * .43, s * .55)
      ..quadraticBezierTo(s * .68, s * .45, s * .90, s * .30)
      ..close();
    canvas.drawPath(road, navy);

    final y = Path()
      ..moveTo(s * .17, s * .28)
      ..lineTo(s * .48, s * .51)
      ..lineTo(s * .81, s * .27)
      ..lineTo(s * .72, s * .48)
      ..lineTo(s * .53, s * .63)
      ..lineTo(s * .47, s * .63)
      ..lineTo(s * .28, s * .48)
      ..close();
    canvas.drawPath(y, teal);

    final dash = Paint()
      ..color = AppColors.white
      ..strokeWidth = s * .035
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(s * .70, s * .58), Offset(s * .67, s * .66), dash);
    canvas.drawLine(Offset(s * .64, s * .72), Offset(s * .61, s * .80), dash);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
