import 'package:flutter/material.dart';

class RideOptionsPage extends StatefulWidget {
  const RideOptionsPage({super.key, required this.destination});
  final String destination;

  @override
  State<RideOptionsPage> createState() => _RideOptionsPageState();
}

class _RideOptionsPageState extends State<RideOptionsPage> {
  String selected = 'motorcycle';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _RouteMapPainter(),
              child: const SizedBox.expand(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: const Color(0xFFFFFBF5),
                  shape: const CircleBorder(),
                  elevation: 3,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Color(0xFF171817)),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: 175,
            left: 74,
            child: _MapPoint(
              icon: Icons.my_location_rounded,
              color: Color(0xFF171817),
            ),
          ),
          const Positioned(
            top: 335,
            right: 72,
            child: _MapPoint(
              icon: Icons.location_on_rounded,
              color: Color(0xFFB98B52),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFBF5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 25,
                    offset: Offset(0, -8),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD7D0C5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        const Expanded(
                          child: Text(
                            'اختار رحلتك',
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Color(0xFF171817),
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          widget.destination,
                          textDirection: TextDirection.rtl,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF817A70),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _RideCard(
                      selected: selected == 'motorcycle',
                      icon: Icons.two_wheeler_rounded,
                      title: 'موتوسيكل',
                      subtitle: 'الأسرع والأوفر',
                      eta: '3 - 5 د',
                      price: '38 ج',
                      onTap: () => setState(() => selected = 'motorcycle'),
                    ),
                    const SizedBox(height: 10),
                    _RideCard(
                      selected: selected == 'car',
                      icon: Icons.directions_car_filled_rounded,
                      title: 'عربية',
                      subtitle: 'راحة أكتر في مشوارك',
                      eta: '4 - 7 د',
                      price: '60 ج',
                      onTap: () => setState(() => selected = 'car'),
                    ),
                    const SizedBox(height: 13),
                    const Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 15, color: Color(0xFF9A9388)),
                        SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'السعر استرشادي، والكباتن هيبعتوا عروضهم بعد الطلب.',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Color(0xFF817A70),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: () => _showSearching(context),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF171817),
                          foregroundColor: const Color(0xFFFFFBF5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: const Text(
                          'اطلب الرحلة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
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

  void _showSearching(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFFFBF5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => const SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 26, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFFB98B52),
                ),
              ),
              SizedBox(height: 18),
              Text(
                'بندور على كباتن قريبين منك...',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Color(0xFF171817),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 7),
              Text(
                'هتظهرلك العروض وتختار الأنسب ليك.',
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Color(0xFF817A70), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  const _RideCard({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.eta,
    required this.price,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final String eta;
  final String price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFFFF7E9) : const Color(0xFFF1ECE4),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? const Color(0xFFB98B52)
                  : Colors.transparent,
              width: 1.4,
            ),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: const Color(0xFF171817), size: 27),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Color(0xFF171817),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '$subtitle • $eta',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Color(0xFF817A70),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                price,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Color(0xFF171817),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapPoint extends StatelessWidget {
  const _MapPoint({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 10),
        ],
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _RouteMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFEAE7E0));

    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    for (var i = -3; i < 10; i++) {
      final y = i * 85.0;
      canvas.drawLine(
        Offset(-40, y),
        Offset(size.width + 50, y + 190),
        road,
      );
    }

    final route = Paint()
      ..color = const Color(0xFFB98B52)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(size.width * .23, 195)
      ..cubicTo(
        size.width * .35,
        240,
        size.width * .47,
        290,
        size.width * .60,
        300,
      )
      ..cubicTo(
        size.width * .70,
        310,
        size.width * .75,
        335,
        size.width * .78,
        350,
      );

    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
