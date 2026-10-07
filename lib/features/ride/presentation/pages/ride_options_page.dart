import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../trip/presentation/pages/captain_arriving_page.dart';
import '../../../../core/session/rider_session.dart';
import '../../../../core/theme/app_colors.dart';

class RideOptionsPage extends StatefulWidget {
  const RideOptionsPage({
    super.key,
    required this.destination,
    this.pickup = 'موقعي الحالي - سوهاج',
    this.pickupLatitude,
    this.pickupLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
  });

  final String destination;
  final String pickup;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final double? destinationLatitude;
  final double? destinationLongitude;

  @override
  State<RideOptionsPage> createState() => _RideOptionsPageState();
}

class _RideOptionsPageState extends State<RideOptionsPage> {
  final MapController mapController = MapController();

  String selected = 'motorcycle';
  bool creatingRide = false;
  String? activeRideId;
  bool loadingRoute = true;
  String? routeError;
  double? distanceKm;
  double? durationMinutes;
  List<LatLng> routePoints = [];

  double get motorcyclePrice =>
      distanceKm == null ? 0 : (distanceKm! * 6.5).clamp(20, double.infinity);
  double get carPrice =>
      distanceKm == null ? 0 : (distanceKm! * 10).clamp(30, double.infinity);

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    final pickupLat = widget.pickupLatitude;
    final pickupLon = widget.pickupLongitude;
    final destinationLat = widget.destinationLatitude;
    final destinationLon = widget.destinationLongitude;

    if (pickupLat == null ||
        pickupLon == null ||
        destinationLat == null ||
        destinationLon == null) {
      if (!mounted) return;
      setState(() {
        loadingRoute = false;
        routeError = 'تعذر حساب المسافة: اختر نقطة بداية ووجهة محددتين على الخريطة.';
      });
      return;
    }

    try {
      final coordinates =
          '$pickupLon,$pickupLat;$destinationLon,$destinationLat';
      final uri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/$coordinates'
        '?overview=full&geometries=geojson&steps=false',
      );
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('routing failed');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data['code'] != 'Ok') {
        throw Exception('no route');
      }
      final routes = data['routes'] as List<dynamic>;
      if (routes.isEmpty) throw Exception('no route');

      final route = routes.first as Map<String, dynamic>;
      final geometry = route['geometry'] as Map<String, dynamic>;
      final coordinatesList = geometry['coordinates'] as List<dynamic>;
      final points = coordinatesList.map((point) {
        final pair = point as List<dynamic>;
        return LatLng(
          (pair[1] as num).toDouble(),
          (pair[0] as num).toDouble(),
        );
      }).toList();

      if (!mounted) return;
      setState(() {
        distanceKm = (route['distance'] as num).toDouble() / 1000;
        durationMinutes = (route['duration'] as num).toDouble() / 60;
        routePoints = points;
        loadingRoute = false;
        routeError = null;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || routePoints.isEmpty) return;
        final bounds = LatLngBounds.fromPoints(routePoints);
        mapController.fitCamera(
          CameraFit.bounds(
            bounds: bounds,
            padding: const EdgeInsets.fromLTRB(42, 90, 42, 390),
          ),
        );
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        loadingRoute = false;
        routeError = 'تعذر حساب الطريق حالياً. حاول مرة تانية.';
      });
    }
  }

  String _priceLabel(double value) {
    if (loadingRoute) return '...';
    if (routeError != null) return '--';
    return '${value.ceil()} ج';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(
                  widget.pickupLatitude ?? 26.5569,
                  widget.pickupLongitude ?? 31.6948,
                ),
                initialZoom: 13.5,
                minZoom: 4,
                maxZoom: 19,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.yalla_go',
                  maxNativeZoom: 19,
                ),
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 5,
                        color: AppColors.turquoise,
                      ),
                    ],
                  ),
                if (widget.pickupLatitude != null &&
                    widget.pickupLongitude != null &&
                    widget.destinationLatitude != null &&
                    widget.destinationLongitude != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          widget.pickupLatitude!,
                          widget.pickupLongitude!,
                        ),
                        width: 44,
                        height: 44,
                        child: const _MapPoint(
                          icon: Icons.my_location_rounded,
                          color: Color(0xFF171817),
                        ),
                      ),
                      Marker(
                        point: LatLng(
                          widget.destinationLatitude!,
                          widget.destinationLongitude!,
                        ),
                        width: 44,
                        height: 44,
                        child: const _MapPoint(
                          icon: Icons.location_on_rounded,
                          color: Color(0xFFB98B52),
                        ),
                      ),
                    ],
                  ),
                RichAttributionWidget(
                  attributions: const [
                    TextSourceAttribution('OpenStreetMap contributors'),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: Material(
                  color: AppColors.white,
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .72,
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
                    const SizedBox(height: 12),
                    _TripSummary(
                      pickup: widget.pickup,
                      destination: widget.destination,
                      loading: loadingRoute,
                      error: routeError,
                      distanceKm: distanceKm,
                      durationMinutes: durationMinutes,
                      onRetry: _loadRoute,
                    ),
                    const SizedBox(height: 12),
                    _RideCard(
                      selected: selected == 'motorcycle',
                      vehicleType: 'motorcycle',
                      title: 'موتوسيكل',
                      subtitle: 'الأسرع والأوفر',
                      eta: durationMinutes == null
                          ? '--'
                          : '${durationMinutes!.ceil()} د',
                      price: _priceLabel(motorcyclePrice),
                      onTap: () => setState(() => selected = 'motorcycle'),
                    ),
                    const SizedBox(height: 10),
                    _RideCard(
                      selected: selected == 'car',
                      vehicleType: 'car',
                      title: 'عربية',
                      subtitle: 'راحة أكتر في مشوارك',
                      eta: durationMinutes == null
                          ? '--'
                          : '${durationMinutes!.ceil()} د',
                      price: _priceLabel(carPrice),
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
                    const SizedBox(height: 18),
                    if (activeRideId != null)
                      _LiveOffersSheet(
                        rideId: activeRideId!,
                        destination: widget.destination,
                        vehicleType: selected,
                      )
                    else
                      SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: loadingRoute || routeError != null || creatingRide
                            ? null
                            : _createRideRequest,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: creatingRide
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Color(0xFFFFFBF5),
                                ),
                              )
                            : const Text(
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
          ),
        ],
      ),
    );
  }

  Future<void> _createRideRequest() async {
    final riderKey = RiderSession.phoneKey;
    if (riderKey == null || distanceKm == null || durationMinutes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('سجل دخولك وحدد الرحلة مرة تانية.', textDirection: TextDirection.rtl)),
      );
      return;
    }

    setState(() => creatingRide = true);
    try {
      final requestRef = FirebaseDatabase.instance.ref('rideRequests').push();
      final price = selected == 'motorcycle' ? motorcyclePrice.ceil() : carPrice.ceil();

      await requestRef.set({
        'rideId': requestRef.key,
        'riderPhoneKey': riderKey,
        'riderName': RiderSession.name ?? '',
        'riderPhone': RiderSession.phone ?? '',
        'pickup': {
          'name': widget.pickup,
          'lat': widget.pickupLatitude,
          'lng': widget.pickupLongitude,
        },
        'destination': {
          'name': widget.destination,
          'lat': widget.destinationLatitude,
          'lng': widget.destinationLongitude,
        },
        'distanceKm': double.parse(distanceKm!.toStringAsFixed(2)),
        'durationMinutes': durationMinutes!.ceil(),
        'vehicleType': selected,
        'indicativePrice': price,
        'status': 'searching',
        'createdAt': ServerValue.timestamp,
      });

      if (!mounted) return;
      setState(() => activeRideId = requestRef.key!);
    } on FirebaseException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.code == 'permission-denied'
                ? 'صلاحيات قاعدة البيانات تمنع إنشاء الرحلة.'
                : 'تعذر إنشاء الرحلة. حاول مرة تانية.',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => creatingRide = false);
    }
  }

}

class _LiveOffersSheet extends StatelessWidget {
  const _LiveOffersSheet({
    required this.rideId,
    required this.destination,
    required this.vehicleType,
  });

  final String rideId;
  final String destination;
  final String vehicleType;

  @override
  Widget build(BuildContext context) {
    final offersRef = FirebaseDatabase.instance.ref('rideOffers/$rideId');
    return StreamBuilder<DatabaseEvent>(
      stream: offersRef.onValue,
      builder: (context, snapshot) {
        final raw = snapshot.data?.snapshot.value;
        final offers = <MapEntry<String, Map<String, dynamic>>>[];
        if (raw is Map) {
          raw.forEach((key, value) {
            if (value is Map) {
              offers.add(MapEntry(
                key.toString(),
                Map<String, dynamic>.from(value),
              ));
            }
          });
        }

        if (offers.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.surfaceSoft,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              textDirection: TextDirection.rtl,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFFB98B52),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'بندور على كباتن قريبين منك...',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Color(0xFF171817),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                const Expanded(
                  child: Text(
                    'عروض الكباتن',
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Color(0xFF171817),
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  '${offers.length} عرض',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Color(0xFF8C6535),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ...offers.map((entry) {
              final data = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: _LiveOfferCard(
                  data: data,
                  onAccept: () => _accept(
                    context,
                    entry.key,
                    data,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }

  Future<void> _accept(
    BuildContext context,
    String offerId,
    Map<String, dynamic> data,
  ) async {
    await FirebaseDatabase.instance.ref('rideRequests/$rideId').update({
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

class _LiveOfferCard extends StatelessWidget {
  const _LiveOfferCard({required this.data, required this.onAccept});

  final Map<String, dynamic> data;
  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final name = (data['driverName'] ?? 'كابتن Yalla Go').toString();
    final vehicle = (data['vehicle'] ?? 'مركبة').toString();
    final eta = data['etaMinutes'] ?? '--';
    final price = data['price'] ?? '--';
    final rating = (data['rating'] as num?)?.toDouble() ?? 5.0;
    final trips = (data['tripsCount'] as num?)?.toInt() ?? 0;

    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Color(0xFFE2EAF0)),
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              const CircleAvatar(
                radius: 23,
                backgroundColor: Color(0xFF171817),
                child: Icon(Icons.person_rounded, color: Color(0xFFFFFBF5)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      name,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Color(0xFF171817),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '$vehicle • $eta د • ⭐ $rating • $trips رحلة',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Color(0xFF817A70),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$price ج',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: Color(0xFF171817),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: FilledButton(
              onPressed: onAccept,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              child: const Text(
                'اختيار العرض',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _RideCard extends StatelessWidget {
  const _RideCard({
    required this.selected,
    required this.vehicleType,
    required this.title,
    required this.subtitle,
    required this.eta,
    required this.price,
    required this.onTap,
  });

  final bool selected;
  final String vehicleType;
  final String title;
  final String subtitle;
  final String eta;
  final String price;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFE8FAFB) : AppColors.surfaceSoft,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? AppColors.turquoise : Colors.transparent,
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
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: _VehicleArtwork(type: vehicleType),
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

class _VehicleArtwork extends StatelessWidget {
  const _VehicleArtwork({required this.type});
  final String type;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VehiclePainter(type == 'car'),
      child: const SizedBox.expand(),
    );
  }
}

class _VehiclePainter extends CustomPainter {
  const _VehiclePainter(this.isCar);
  final bool isCar;

  @override
  void paint(Canvas canvas, Size size) {
    final navy = Paint()..color = AppColors.navy;
    final teal = Paint()..color = AppColors.turquoise;
    final glass = Paint()..color = const Color(0xFFDCECF1);
    final tire = Paint()..color = const Color(0xFF172A38);
    if (isCar) {
      final body = RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width*.08,size.height*.42,size.width*.84,size.height*.34),
        Radius.circular(size.height*.12),
      );
      canvas.drawRRect(body, Paint()..color=AppColors.white);
      canvas.drawRRect(body, Paint()..style=PaintingStyle.stroke..strokeWidth=2..color=AppColors.navy);
      final roof=Path()
        ..moveTo(size.width*.28,size.height*.43)
        ..lineTo(size.width*.40,size.height*.24)
        ..lineTo(size.width*.68,size.height*.24)
        ..lineTo(size.width*.82,size.height*.43)
        ..close();
      canvas.drawPath(roof, glass);
      canvas.drawLine(Offset(size.width*.53,size.height*.25),Offset(size.width*.53,size.height*.43),navy..strokeWidth=1.5);
      canvas.drawRect(Rect.fromLTWH(size.width*.10,size.height*.58,size.width*.08,size.height*.05),teal);
      canvas.drawCircle(Offset(size.width*.28,size.height*.76),size.height*.10,tire);
      canvas.drawCircle(Offset(size.width*.74,size.height*.76),size.height*.10,tire);
      canvas.drawCircle(Offset(size.width*.28,size.height*.76),size.height*.045,Paint()..color=Colors.white);
      canvas.drawCircle(Offset(size.width*.74,size.height*.76),size.height*.045,Paint()..color=Colors.white);
    } else {
      canvas.drawCircle(Offset(size.width*.26,size.height*.72),size.height*.15,tire);
      canvas.drawCircle(Offset(size.width*.76,size.height*.72),size.height*.15,tire);
      canvas.drawCircle(Offset(size.width*.26,size.height*.72),size.height*.10,Paint()..color=Colors.white);
      canvas.drawCircle(Offset(size.width*.76,size.height*.72),size.height*.10,Paint()..color=Colors.white);
      final frame=Paint()..color=AppColors.turquoise..strokeWidth=4..strokeCap=StrokeCap.round;
      canvas.drawLine(Offset(size.width*.28,size.height*.68),Offset(size.width*.48,size.height*.48),frame);
      canvas.drawLine(Offset(size.width*.48,size.height*.48),Offset(size.width*.62,size.height*.70),frame);
      canvas.drawLine(Offset(size.width*.28,size.height*.68),Offset(size.width*.62,size.height*.70),frame);
      canvas.drawLine(Offset(size.width*.62,size.height*.70),Offset(size.width*.73,size.height*.40),navy..strokeWidth=4);
      canvas.drawLine(Offset(size.width*.69,size.height*.40),Offset(size.width*.84,size.height*.38),navy);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width*.39,size.height*.39,size.width*.25,size.height*.12),const Radius.circular(8)),navy);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(size.width*.35,size.height*.31,size.width*.22,size.height*.08),const Radius.circular(8)),teal);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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
      decoration: const BoxDecoration(
        color: Color(0xFFFFFBF5),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0x33000000), blurRadius: 10),
        ],
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _TripSummary extends StatelessWidget {
  const _TripSummary({
    required this.pickup,
    required this.destination,
    required this.loading,
    required this.error,
    required this.distanceKm,
    required this.durationMinutes,
    required this.onRetry,
  });

  final String pickup;
  final String destination;
  final bool loading;
  final String? error;
  final double? distanceKm;
  final double? durationMinutes;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          _SummaryLine(
            icon: Icons.my_location_rounded,
            text: pickup,
            color: AppColors.navy,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: Divider(height: 1, color: Color(0xFFDCD5CA)),
          ),
          _SummaryLine(
            icon: Icons.location_on_rounded,
            text: destination,
            color: AppColors.turquoise,
          ),
          const SizedBox(height: 10),
          if (loading)
            const Row(
              textDirection: TextDirection.rtl,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFB98B52),
                  ),
                ),
                SizedBox(width: 7),
                Text(
                  'بنحسب أفضل طريق...',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Color(0xFF817A70), fontSize: 10),
                ),
              ],
            )
          else if (error != null)
            Row(
              textDirection: TextDirection.rtl,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 15, color: Color(0xFFB98B52)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    error!,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Color(0xFF817A70),
                      fontSize: 10,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onRetry,
                  child: const Text('إعادة'),
                ),
              ],
            )
          else
            Row(
              textDirection: TextDirection.rtl,
              children: [
                const Icon(Icons.route_rounded,
                    size: 15, color: Color(0xFF817A70)),
                const SizedBox(width: 5),
                const Text(
                  'الطريق الفعلي',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: Color(0xFF817A70), fontSize: 10),
                ),
                const Spacer(),
                Text(
                  '${distanceKm!.toStringAsFixed(1)} كم • ${durationMinutes!.ceil()} د',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Color(0xFF171817),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.icon, required this.text, required this.color});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    textDirection: TextDirection.rtl,
    children: [
      Icon(icon, size: 17, color: color),
      const SizedBox(width: 8),
      Expanded(
        child: Text(text, textDirection: TextDirection.rtl, textAlign: TextAlign.right,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Color(0xFF171817), fontSize: 11, fontWeight: FontWeight.w700)),
      ),
    ],
  );
}
