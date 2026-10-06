import 'package:flutter/material.dart';

import 'active_trip_page.dart';

class CaptainArrivingPage extends StatelessWidget {
  const CaptainArrivingPage({
    super.key,
    required this.captainName,
    required this.vehicle,
    required this.eta,
    required this.price,
    required this.rating,
    required this.destination,
    required this.vehicleType,
    this.plate = 'س و هـ 2451',
  });

  final String captainName,
      vehicle,
      eta,
      price,
      destination,
      vehicleType,
      plate;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      body: Stack(
        children: [
          const Positioned.fill(child: _ArrivalMap()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Material(
                    color: const Color(0xFFFFFBF5),
                    shape: const CircleBorder(),
                    elevation: 3,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Color(0xFF171817)),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBF5),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(color: Color(0x22000000), blurRadius: 10)
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 16, color: Color(0xFFB98B52)),
                        const SizedBox(width: 6),
                        Text(
                          '$eta للوصول',
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: Color(0xFF171817),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            top: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const _MapMarker(
                  icon: Icons.person_pin_circle_rounded,
                  color: Color(0xFFB98B52),
                ),
                _MapMarker(
                  icon: vehicleType == 'motorcycle'
                      ? Icons.two_wheeler_rounded
                      : Icons.directions_car_filled_rounded,
                  color: const Color(0xFF171817),
                ),
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
                boxShadow: [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 28,
                    offset: Offset(0, -8),
                  )
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
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'الكابتن في الطريق إليك',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0xFF171817),
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'متوقع يوصل خلال $eta',
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: Color(0xFF817A70),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: const BoxDecoration(
                            color: Color(0xFF171817),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person_rounded,
                              color: Color(0xFFFFFBF5), size: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                captainName,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  color: Color(0xFF171817),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '$vehicle • $plate',
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                    color: Color(0xFF817A70),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    rating.toString(),
                                    style: const TextStyle(
                                      color: Color(0xFF171817),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const Icon(Icons.star_rounded,
                                      color: Color(0xFFB98B52), size: 15),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              price,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                color: Color(0xFF171817),
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const Text(
                              'أجرة الرحلة',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: Color(0xFF817A70),
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4EFE7),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: Color(0xFFB98B52), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              destination,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF171817),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.chat_bubble_outline_rounded),
                              label: const Text('رسالة'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF171817),
                                side:
                                    const BorderSide(color: Color(0xFFD8D0C5)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: FilledButton.icon(
                              onPressed: () => _showCallDialog(context),
                              icon: const Icon(Icons.call_rounded),
                              label: const Text('اتصال'),
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF171817),
                                foregroundColor: const Color(0xFFFFFBF5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 11),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ActiveTripPage(
                                captainName: captainName,
                                vehicle: vehicle,
                                price: price,
                                destination: destination,
                                vehicleType: vehicleType,
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFB98B52),
                          foregroundColor: const Color(0xFF171817),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'محاكاة وصول الكابتن وبدء الرحلة',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton(
                      onPressed: () => _showCancelSheet(context),
                      child: const Text(
                        'إلغاء الرحلة',
                        style: TextStyle(
                          color: Color(0xFF9A4B42),
                          fontWeight: FontWeight.w700,
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

  void _showCallDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFFBF5),
        title: const Text('اتصال بالكابتن',
            textDirection: TextDirection.rtl, textAlign: TextAlign.right),
        content: Text(
            'سيتم الاتصال بـ $captainName عند ربط رقم الكابتن الحقيقي.',
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'))
        ],
      ),
    );
  }

  void _showMessageSheet(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFFFBF5),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26))),
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
            20, 20, 20, MediaQuery.of(sheetContext).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('رسالة إلى $captainName',
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                  color: Color(0xFF171817),
                  fontSize: 17,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          TextField(
              controller: controller,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: Color(0xFF171817)),
              decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  filled: true,
                  fillColor: const Color(0xFFF1ECE4),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none))),
          const SizedBox(height: 12),
          SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF171817)),
                  child: const Text('إرسال'))),
        ]),
      ),
    );
  }

  void _showCancelSheet(BuildContext context) {
    const reasons = [
      'الكابتن بعيد',
      'وقت الوصول طويل',
      'غيّرت رأيي',
      'طلبت الرحلة بالخطأ',
      'سبب آخر'
    ];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFFFBF5),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('ليه عايز تلغي الرحلة؟',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        color: Color(0xFF171817),
                        fontSize: 19,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('اختيار السبب بيساعدنا نحسن التجربة.',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(color: Color(0xFF817A70), fontSize: 11)),
                const SizedBox(height: 12),
                ...reasons.map((reason) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      trailing: const Icon(Icons.radio_button_unchecked_rounded,
                          color: Color(0xFFB98B52)),
                      title: Text(reason,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              color: Color(0xFF171817),
                              fontWeight: FontWeight.w700)),
                      onTap: () {
                        Navigator.pop(sheetContext);
                        Navigator.of(context).popUntil((route) =>
                            route.settings.name == '/home' || route.isFirst);
                      },
                    )),
              ]),
        ),
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  const _MapMarker({required this.icon, required this.color});
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFBF5),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0x33000000), blurRadius: 12),
        ],
      ),
      child: Icon(icon, color: color, size: 25),
    );
  }
}

class _ArrivalMap extends StatelessWidget {
  const _ArrivalMap();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ArrivalMapPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _ArrivalMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
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
      ..moveTo(55, 185)
      ..cubicTo(
        size.width * .32,
        220,
        size.width * .62,
        155,
        size.width - 55,
        185,
      );

    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
