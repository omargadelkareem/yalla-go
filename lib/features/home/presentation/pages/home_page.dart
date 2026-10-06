import 'package:flutter/material.dart';

import '../../../location/presentation/pages/destination_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      body: Stack(
        children: [
          const Positioned.fill(child: _LightMap()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  _MapButton(icon: Icons.menu_rounded, onTap: () {}),
                  const Spacer(),
                  _MapButton(icon: Icons.card_giftcard_rounded, onTap: () {}),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 280,
            child: _MapButton(
              icon: Icons.near_me_rounded,
              onTap: () {},
            ),
          ),
          const Align(
            alignment: Alignment(0, -.05),
            child: _CurrentLocation(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 28,
                      offset: Offset(0, -8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7D0C5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 17),
                    const Text(
                      '👋 أهلاً بيك',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF171817),
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'إلى أين تريد الذهاب؟',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF4F4C47),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Material(
                      color: const Color(0xFFF1ECE4),
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const DestinationPage())),
                        borderRadius: BorderRadius.circular(16),
                        child: const SizedBox(
                          height: 55,
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              SizedBox(width: 16),
                              Icon(Icons.search_rounded,
                                  color: Color(0xFF171817), size: 22),
                              SizedBox(width: 11),
                              Expanded(
                                child: Text(
                                  'ابحث عن مكان أو اختر من الخريطة',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Color(0xFF777168),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _QuickPlace(icon: Icons.home_rounded, label: 'المنزل'),
                        _QuickPlace(icon: Icons.work_rounded, label: 'العمل'),
                        _QuickPlace(
                            icon: Icons.history_rounded, label: 'مواقعي'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  const _MapButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFFBF5),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(icon, color: const Color(0xFF171817), size: 22),
        ),
      ),
    );
  }
}

class _CurrentLocation extends StatelessWidget {
  const _CurrentLocation();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF2D8CFF).withOpacity(.13),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: const Color(0xFF2D8CFF),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: const [
            BoxShadow(color: Color(0x44000000), blurRadius: 8),
          ],
        ),
      ),
    );
  }
}

class _QuickPlace extends StatelessWidget {
  const _QuickPlace({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF1ECE4),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF171817)),
          const SizedBox(width: 6),
          Text(
            label,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Color(0xFF292A27),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _LightMap extends StatelessWidget {
  const _LightMap();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapPainter(),
      child: Container(color: Colors.transparent),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final major = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final minor = Paint()
      ..color = const Color(0xFFD5D1C9)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var i = -3; i < 10; i++) {
      final y = i * 82.0;
      canvas.drawLine(Offset(-40, y), Offset(size.width + 50, y + 190), major);
      canvas.drawLine(
        Offset(-20, y + 35),
        Offset(size.width + 40, y + 225),
        minor,
      );
    }
    for (var i = -1; i < 8; i++) {
      final x = i * 78.0;
      canvas.drawLine(Offset(x, -30), Offset(x + 170, size.height), major);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
