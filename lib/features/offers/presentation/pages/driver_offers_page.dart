import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../../trip/presentation/pages/captain_arriving_page.dart';

class DriverOffersPage extends StatelessWidget {
  const DriverOffersPage(
      {super.key, required this.destination, required this.vehicleType, required this.rideId});
  final String destination, vehicleType, rideId;

  @override
  Widget build(BuildContext context) {
    final offersRef = FirebaseDatabase.instance.ref('rideOffers/$rideId');

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
              child: Row(
                children: [
                  Material(
                    color: const Color(0xFFFFFBF5),
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF171817)),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'عروض الكباتن',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Color(0xFF171817),
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  destination,
                  textDirection: TextDirection.rtl,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF817A70), fontSize: 11),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<DatabaseEvent>(
                stream: offersRef.onValue,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFFB98B52)),
                    );
                  }

                  final raw = snapshot.data?.snapshot.value;
                  if (raw is! Map) {
                    return const _WaitingForOffers();
                  }

                  final offers = <MapEntry<String, Map<String, dynamic>>>[];
                  raw.forEach((key, value) {
                    if (value is Map) {
                      offers.add(MapEntry(
                        key.toString(),
                        Map<String, dynamic>.from(value),
                      ));
                    }
                  });

                  if (offers.isEmpty) return const _WaitingForOffers();

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
                    itemCount: offers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final entry = offers[i];
                      final data = entry.value;
                      final offer = _Offer(
                        (data['driverName'] ?? 'كابتن Yalla Go').toString(),
                        (data['vehicle'] ?? 'مركبة').toString(),
                        '${data['etaMinutes'] ?? '--'} د',
                        '${data['price'] ?? '--'} ج',
                        (data['rating'] as num?)?.toDouble() ?? 5.0,
                        (data['tripsCount'] as num?)?.toInt() ?? 0,
                      );
                      return _Card(
                        data: offer,
                        destination: destination,
                        vehicleType: vehicleType,
                        onAccept: () => _acceptOffer(context, entry.key, data),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _acceptOffer(
    BuildContext context,
    String offerId,
    Map<String, dynamic> data,
  ) async {
    final rideRef = FirebaseDatabase.instance.ref('rideRequests/$rideId');
    await rideRef.update({
      'status': 'accepted',
      'acceptedOfferId': offerId,
      'acceptedDriverId': data['driverId'],
      'acceptedAt': ServerValue.timestamp,
    });
    await FirebaseDatabase.instance
        .ref('rideOffers/$rideId/$offerId')
        .update({'status': 'accepted'});

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CaptainArrivingPage(
          captainName: (data['driverName'] ?? 'كابتن Yalla Go').toString(),
          vehicle: (data['vehicle'] ?? 'مركبة').toString(),
          eta: '${data['etaMinutes'] ?? '--'} د',
          price: '${data['price'] ?? '--'} ج',
          rating: (data['rating'] as num?)?.toDouble() ?? 5.0,
          destination: destination,
          vehicleType: vehicleType,
        ),
      ),
    );
  }
}

class _WaitingForOffers extends StatelessWidget {
  const _WaitingForOffers();

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 44,
                height: 44,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xFFB98B52),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'طلب الرحلة اتسجل بنجاح',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF171817),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              const Text(
                'بندور على كباتن قريبين منك، والعروض الحقيقية هتظهر هنا لحظياً.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF817A70),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      );
}

class _Card extends StatelessWidget {
  const _Card({required this.data, required this.destination, required this.vehicleType, required this.onAccept});
  final _Offer data;
  final String destination, vehicleType;
  final VoidCallback onAccept;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: const Color(0xFFF4EFE7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE6DED2))),
      child: Column(children: [
        Row(textDirection: TextDirection.rtl, children: [
          Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                  color: Color(0xFF171817), shape: BoxShape.circle),
              child: const Icon(Icons.person_rounded,
                  color: Color(0xFFFFFBF5), size: 29)),
          const SizedBox(width: 11),
          Expanded(
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(data.name,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                    color: Color(0xFF171817),
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 3),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('${data.trips} رحلة',
                  textDirection: TextDirection.rtl,
                  style:
                      const TextStyle(color: Color(0xFF817A70), fontSize: 10)),
              const SizedBox(width: 8),
              const Icon(Icons.star_rounded,
                  color: Color(0xFFB98B52), size: 15),
              Text(data.rating.toString(),
                  style: const TextStyle(
                      color: Color(0xFF171817),
                      fontSize: 11,
                      fontWeight: FontWeight.w700))
            ]),
            Text('${data.vehicle} • ${data.eta}',
                textDirection: TextDirection.rtl,
                style: const TextStyle(color: Color(0xFF817A70), fontSize: 10))
          ])),
          const SizedBox(width: 10),
          Text(data.price,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                  color: Color(0xFF171817),
                  fontSize: 20,
                  fontWeight: FontWeight.w900))
        ]),
        const SizedBox(height: 12),
        SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton(
                onPressed: onAccept,
                style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF171817),
                    foregroundColor: const Color(0xFFFFFBF5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                child: const Text('اختيار العرض',
                    style: TextStyle(fontWeight: FontWeight.w800))))
      ]));
}

class _Offer {
  const _Offer(
      this.name, this.vehicle, this.eta, this.price, this.rating, this.trips);
  final String name, vehicle, eta, price;
  final double rating;
  final int trips;
}

class _Map extends StatelessWidget {
  const _Map();
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _Painter(), child: const SizedBox.expand());
}

class _Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    for (var i = -3; i < 10; i++) {
      final y = i * 85.0;
      canvas.drawLine(Offset(-40, y), Offset(size.width + 50, y + 190), road);
    }
    final pin = Paint()..color = const Color(0xFF171817);
    canvas.drawCircle(Offset(size.width * .30, 180), 8, pin);
    canvas.drawCircle(Offset(size.width * .62, 235), 8, pin);
    canvas.drawCircle(Offset(size.width * .77, 145), 8, pin);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
