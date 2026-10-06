import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../offers/presentation/pages/driver_offers_page.dart';
import '../../../offers/presentation/pages/no_drivers_page.dart';

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
  bool simulateNoDrivers = false;
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
      backgroundColor: const Color(0xFFF6F1E8),
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
                        color: const Color(0xFFB98B52),
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
                      icon: Icons.two_wheeler_rounded,
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
                      icon: Icons.directions_car_filled_rounded,
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
                    const SizedBox(height: 10),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Switch(
                          value: simulateNoDrivers,
                          activeColor: const Color(0xFFB98B52),
                          onChanged: (value) =>
                              setState(() => simulateNoDrivers = value),
                        ),
                        const SizedBox(width: 7),
                        const Expanded(
                          child: Text(
                            'وضع تجربة: لا يوجد كباتن',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Color(0xFF817A70),
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: loadingRoute || routeError != null
                            ? null
                            : () => _showSearching(context),
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
          ),
        ],
      ),
    );
  }

  void _showSearching(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(.32),
      builder: (dialogContext) {
        Future.delayed(const Duration(milliseconds: 1800), () {
          if (!dialogContext.mounted) return;
          Navigator.pop(dialogContext);
          if (simulateNoDrivers) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NoDriversPage(
                  destination: widget.destination,
                  vehicleType: selected,
                ),
              ),
            ).then((retry) {
              if (retry == true && context.mounted) {
                setState(() => simulateNoDrivers = false);
                _showSearching(context);
              }
            });
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DriverOffersPage(
                destination: widget.destination,
                vehicleType: selected,
              ),
            ),
          );
        });
        return Dialog(
          backgroundColor: const Color(0xFFFFFBF5),
          insetPadding: const EdgeInsets.symmetric(horizontal: 42),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(24, 28, 24, 26),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              SizedBox(
                  width: 42,
                  height: 42,
                  child: CircularProgressIndicator(
                      strokeWidth: 3, color: Color(0xFFB98B52))),
              SizedBox(height: 20),
              Text('بندور على كباتن قريبين منك...',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFF171817),
                      fontSize: 17,
                      fontWeight: FontWeight.w800)),
              SizedBox(height: 7),
              Text('ثواني وهتظهرلك العروض المتاحة',
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF817A70), fontSize: 12)),
            ]),
          ),
        );
      },
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
              color: selected ? const Color(0xFFB98B52) : Colors.transparent,
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
        color: const Color(0xFFF1ECE4),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        children: [
          _SummaryLine(
            icon: Icons.my_location_rounded,
            text: pickup,
            color: const Color(0xFF171817),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: Divider(height: 1, color: Color(0xFFDCD5CA)),
          ),
          _SummaryLine(
            icon: Icons.location_on_rounded,
            text: destination,
            color: const Color(0xFFB98B52),
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
