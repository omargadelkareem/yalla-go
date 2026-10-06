import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../location/presentation/pages/destination_page.dart';
import '../../../history/presentation/pages/trip_history_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../support/presentation/pages/support_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController mapController = MapController();
  bool mapReady = false;
  bool locating = true;
  Position? currentPosition;
  String locationText = 'جاري تحديد موقعك...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _detectLocation());
  }

  Future<void> _detectLocation() async {
    if (!mounted) return;
    setState(() {
      locating = true;
      locationText = 'جاري تحديد موقعك...';
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          locating = false;
          locationText = 'فعّل GPS لتحديد موقعك';
        });
        _showMessage('فعّل خدمة الموقع GPS ثم اضغط زر تحديد الموقع.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() {
          locating = false;
          locationText = 'لم يتم السماح بالموقع';
        });
        _showMessage('اسمح بالوصول للموقع علشان Yalla Go يحدد نقطة الانطلاق.');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          locating = false;
          locationText = 'صلاحية الموقع موقوفة';
        });
        _showMessage('فعّل صلاحية الموقع من إعدادات التطبيق ثم حاول مرة تانية.');
        return;
      }

      const settings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
      );
      final position = await Geolocator.getCurrentPosition(
        locationSettings: settings,
      );

      if (!mounted) return;
      setState(() {
        currentPosition = position;
        locating = false;
        locationText = 'موقعك الحالي';
      });
      _moveToCurrentLocation();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        locating = false;
        locationText = 'تعذر تحديد الموقع';
      });
      _showMessage('تعذر تحديد موقعك حالياً. حاول مرة تانية.');
    }
  }

  void _moveToCurrentLocation() {
    final position = currentPosition;
    if (!mapReady || position == null) return;
    mapController.move(
      LatLng(position.latitude, position.longitude),
      16.5,
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFFFFFBF5),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    CircleAvatar(
                      radius: 27,
                      backgroundColor: Color(0xFF171817),
                      child: Icon(Icons.person_rounded, color: Color(0xFFFFFBF5)),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('مستخدم Yalla Go', textDirection: TextDirection.rtl, style: TextStyle(color: Color(0xFF171817), fontWeight: FontWeight.w900)),
                        Text('+20 10 0000 0000', style: TextStyle(color: Color(0xFF817A70), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFE7E0D6)),
              _DrawerItem(icon: Icons.history_rounded, label: 'رحلاتي', page: TripHistoryPage()),
              _DrawerItem(icon: Icons.person_outline_rounded, label: 'حسابي', page: ProfilePage()),
              _DrawerItem(icon: Icons.notifications_none_rounded, label: 'الإشعارات', page: NotificationsPage()),
              _DrawerItem(icon: Icons.support_agent_rounded, label: 'المساعدة والدعم', page: SupportPage()),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text('Yalla Go • Sohag', style: TextStyle(color: Color(0xFF817A70), fontSize: 11)),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF6F1E8),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 255,
            child: ClipRect(
              child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: const LatLng(26.5569, 31.6948),
                initialZoom: 13.5,
                minZoom: 4,
                maxZoom: 19,
                onMapReady: () {
                  mapReady = true;
                  _moveToCurrentLocation();
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.yalla_go',
                  maxNativeZoom: 19,
                ),
                if (currentPosition != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(
                          currentPosition!.latitude,
                          currentPosition!.longitude,
                        ),
                        width: 54,
                        height: 54,
                        child: const _UserMapMarker(),
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
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                children: [
                  Builder(builder: (menuContext) => _MapButton(icon: Icons.menu_rounded, onTap: () => Scaffold.of(menuContext).openDrawer())),
                  const Spacer(),
                  _MapButton(icon: Icons.card_giftcard_rounded, onTap: () {}),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 268,
            child: _MapButton(
              icon: locating ? Icons.hourglass_top_rounded : Icons.near_me_rounded,
              onTap: () async {
                if (currentPosition == null) {
                  await _detectLocation();
                } else {
                  _moveToCurrentLocation();
                }
              },
            ),
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
                    const Text(
                      'آخر الوجهات',
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Color(0xFF171817), fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(child: _QuickPlace(icon: Icons.history_rounded, label: 'ميدان الثقافة')),
                        SizedBox(width: 8),
                        Expanded(child: _QuickPlace(icon: Icons.history_rounded, label: 'جامعة سوهاج')),
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

class _LocationStatus extends StatelessWidget {
  const _LocationStatus({
    required this.locating,
    required this.label,
  });

  final bool locating;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 8),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: TextDirection.rtl,
        children: [
          if (locating)
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF2D8CFF),
              ),
            )
          else
            const Icon(Icons.my_location_rounded,
                size: 15, color: Color(0xFF2D8CFF)),
          const SizedBox(width: 6),
          Text(
            label,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: Color(0xFF171817),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserMapMarker extends StatelessWidget {
  const _UserMapMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D8CFF).withOpacity(.16),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 22,
        height: 22,
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

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.icon, required this.label, this.page});
  final IconData icon;
  final String label;
  final Widget? page;
  @override
  Widget build(BuildContext context) => ListTile(
    trailing: Icon(icon, color: const Color(0xFFB98B52)),
    leading: const Icon(Icons.chevron_left_rounded, color: Color(0xFF817A70)),
    title: Text(label, textDirection: TextDirection.rtl, textAlign: TextAlign.right,
      style: const TextStyle(color: Color(0xFF171817), fontWeight: FontWeight.w700)),
    onTap: () {
      Navigator.pop(context);
      if (page != null) Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
    },
  );
}
