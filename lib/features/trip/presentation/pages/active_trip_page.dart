import 'package:flutter/material.dart';
import 'trip_completed_page.dart';

class ActiveTripPage extends StatelessWidget {
  const ActiveTripPage({
    super.key,
    required this.captainName,
    required this.vehicle,
    required this.price,
    required this.destination,
    required this.vehicleType,
  });

  final String captainName, vehicle, price, destination, vehicleType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      body: Stack(
        children: [
          const Positioned.fill(child: _TripMap()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF171817),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 12)],
                  ),
                  child: const Text(
                    'الرحلة جارية الآن',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Color(0xFFFFFBF5), fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: 40,
            right: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _Marker(icon: Icons.my_location_rounded, color: Color(0xFFB98B52)),
                _Marker(
                  icon: vehicleType == 'motorcycle' ? Icons.two_wheeler_rounded : Icons.directions_car_filled_rounded,
                  color: const Color(0xFF171817),
                ),
                const _Marker(icon: Icons.location_on_rounded, color: Color(0xFFB98B52)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFBF5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [BoxShadow(color: Color(0x22000000), blurRadius: 28, offset: Offset(0, -8))],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 38, height: 4, decoration: BoxDecoration(color: const Color(0xFFD7D0C5), borderRadius: BorderRadius.circular(20))),
                    const SizedBox(height: 15),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('في الطريق للوجهة', textDirection: TextDirection.rtl, style: TextStyle(color: Color(0xFF171817), fontSize: 20, fontWeight: FontWeight.w900)),
                              SizedBox(height: 3),
                              Text('حوالي 12 دقيقة للوصول', textDirection: TextDirection.rtl, style: TextStyle(color: Color(0xFF817A70), fontSize: 11)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: const Color(0xFFFFF1D8), borderRadius: BorderRadius.circular(18)),
                          child: const Text('4.8 كم', style: TextStyle(color: Color(0xFF8C6535), fontSize: 12, fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(color: const Color(0xFFF4EFE7), borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Icon(Icons.location_on_outlined, color: Color(0xFFB98B52), size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: Text(destination, textDirection: TextDirection.rtl, textAlign: TextAlign.right, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF171817), fontSize: 12, fontWeight: FontWeight.w700))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(width: 45, height: 45, decoration: const BoxDecoration(color: Color(0xFF171817), shape: BoxShape.circle), child: const Icon(Icons.person_rounded, color: Color(0xFFFFFBF5))),
                        const SizedBox(width: 10),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                          Text(captainName, textDirection: TextDirection.rtl, style: const TextStyle(color: Color(0xFF171817), fontWeight: FontWeight.w800)),
                          Text(vehicle, textDirection: TextDirection.rtl, style: const TextStyle(color: Color(0xFF817A70), fontSize: 10)),
                        ])),
                        Text(price, textDirection: TextDirection.rtl, style: const TextStyle(color: Color(0xFF171817), fontSize: 18, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TripCompletedPage(
                                captainName: captainName,
                                price: price,
                                destination: destination,
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(backgroundColor: const Color(0xFF171817), foregroundColor: const Color(0xFFFFFBF5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                        child: const Text('محاكاة الوصول للوجهة', style: TextStyle(fontWeight: FontWeight.w900)),
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
}

class _Marker extends StatelessWidget {
  const _Marker({required this.icon, required this.color});
  final IconData icon; final Color color;
  @override Widget build(BuildContext context) => Container(width: 44, height: 44, decoration: const BoxDecoration(color: Color(0xFFFFFBF5), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Color(0x33000000), blurRadius: 10)]), child: Icon(icon, color: color, size: 22));
}

class _TripMap extends StatelessWidget {
  const _TripMap();
  @override Widget build(BuildContext context) => CustomPaint(painter: _TripPainter(), child: const SizedBox.expand());
}

class _TripPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFEAE7E0));
    final road = Paint()..color = Colors.white..strokeWidth = 8..strokeCap = StrokeCap.round;
    for (var i = -3; i < 10; i++) {
      final y = i * 85.0;
      canvas.drawLine(Offset(-40, y), Offset(size.width + 50, y + 190), road);
    }
    final route = Paint()..color = const Color(0xFFB98B52)..strokeWidth = 5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final path = Path()..moveTo(55, 200)..cubicTo(size.width * .35, 270, size.width * .62, 130, size.width - 55, 205);
    canvas.drawPath(path, route);
  }
  @override bool shouldRepaint(CustomPainter oldDelegate) => false;
}
