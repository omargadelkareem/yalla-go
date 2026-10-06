import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../ride/presentation/pages/ride_options_page.dart';

class DestinationPage extends StatefulWidget {
  const DestinationPage({super.key});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  final pickupController = TextEditingController(text: 'موقعي الحالي - سوهاج');
  final destinationController = TextEditingController();
  bool editingPickup = false;
  bool locating = false;
  Position? currentPosition;

  final List<String> places = const [
    'جامعة سوهاج الجديدة',
    'جامعة سوهاج القديمة',
    'ميدان الثقافة - سوهاج',
    'ميدان العروبة - سوهاج',
    'محطة قطار سوهاج',
    'مستشفى سوهاج الجامعي',
    'كورنيش النيل - سوهاج',
    'شارع الجمهورية - سوهاج',
  ];

  TextEditingController get activeController =>
      editingPickup ? pickupController : destinationController;

  List<String> get results {
    final query = activeController.text.trim();
    if (query.isEmpty) return places.take(4).toList();
    return places.where((place) => place.contains(query)).toList();
  }

  @override
  void dispose() {
    pickupController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  Future<void> useCurrentLocation() async {
    if (locating) return;
    setState(() => locating = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        _showLocationMessage('فعّل خدمة الموقع GPS وحاول مرة تانية.');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        _showLocationMessage(
          permission == LocationPermission.deniedForever
              ? 'صلاحية الموقع مرفوضة نهائياً. فعّلها من إعدادات التطبيق.'
              : 'لازم تسمح بالوصول للموقع علشان نحدد نقطة الانطلاق.',
        );
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
        pickupController.text = 'موقعي الحالي';
        editingPickup = false;
      });
      _showLocationMessage('تم تحديد موقعك الحالي بنجاح.');
    } catch (_) {
      if (!mounted) return;
      _showLocationMessage('تعذر تحديد موقعك حالياً. حاول مرة تانية.');
    } finally {
      if (mounted) setState(() => locating = false);
    }
  }

  void _showLocationMessage(String message) {
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

  void selectPlace(String place) {
    setState(() {
      activeController.text = place;
      activeController.selection =
          TextSelection.collapsed(offset: activeController.text.length);
    });
    if (editingPickup) {
      setState(() => editingPickup = false);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RideOptionsPage(
          pickup: pickupController.text.trim(),
          destination: destinationController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      body: Stack(
        children: [
          const Positioned.fill(child: _DestinationMap()),
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
          const Align(
            alignment: Alignment(0, -0.22),
            child: _CenterPin(),
          ),
          Positioned(
            right: 16,
            bottom: 390,
            child: Material(
              color: const Color(0xFFFFFBF5),
              shape: const CircleBorder(),
              elevation: 3,
              child: IconButton(
                onPressed: locating ? null : useCurrentLocation,
                icon: locating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.3,
                          color: Color(0xFFB98B52),
                        ),
                      )
                    : const Icon(
                        Icons.my_location_rounded,
                        color: Color(0xFF171817),
                      ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 455),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
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
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'حدد مشوارك',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0xFF171817),
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _LocationField(
                      controller: pickupController,
                      hint: 'من أين؟',
                      icon: Icons.my_location_rounded,
                      active: editingPickup,
                      onTap: () => setState(() => editingPickup = true),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 9),
                    _LocationField(
                      controller: destinationController,
                      hint: 'إلى أين؟',
                      icon: Icons.location_on_rounded,
                      active: !editingPickup,
                      autofocus: true,
                      onTap: () => setState(() => editingPickup = false),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        activeController.text.trim().isEmpty
                            ? 'أماكن مقترحة'
                            : 'نتائج البحث',
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: Color(0xFF817A70),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Flexible(
                      child: results.isEmpty
                          ? const Center(
                              child: Text(
                                'لا توجد نتائج مطابقة',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(color: Color(0xFF817A70)),
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: results.length,
                              separatorBuilder: (_, __) => const Divider(
                                height: 1,
                                color: Color(0xFFE7E0D6),
                              ),
                              itemBuilder: (_, index) {
                                final place = results[index];
                                return ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  onTap: () => selectPlace(place),
                                  leading: Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1ECE4),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.location_on_outlined,
                                      color: Color(0xFFB98B52),
                                      size: 19,
                                    ),
                                  ),
                                  title: Text(
                                    place,
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Color(0xFF171817),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                );
                              },
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

class _LocationField extends StatelessWidget {
  const _LocationField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.active,
    required this.onTap,
    required this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      onTap: onTap,
      onChanged: onChanged,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      cursorColor: const Color(0xFF171817),
      style: const TextStyle(
        color: Color(0xFF171817),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        hintStyle: const TextStyle(color: Color(0xFF817A70)),
        suffixIcon: Icon(icon,
            color: active ? const Color(0xFFB98B52) : const Color(0xFF817A70)),
        filled: true,
        fillColor: const Color(0xFFF1ECE4),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: active ? const Color(0xFFB98B52) : Colors.transparent,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xFFB98B52), width: 1.3),
        ),
      ),
    );
  }
}

class _CenterPin extends StatelessWidget {
  const _CenterPin();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.location_on_rounded, color: Color(0xFFB98B52), size: 48),
        SizedBox(height: 2),
        Text(
          'حرّك الخريطة لتحديد النقطة',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Color(0xFF171817),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _DestinationMap extends StatelessWidget {
  const _DestinationMap();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xFFE8E5DE));
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final minor = Paint()
      ..color = const Color(0xFFD3CFC7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (var i = -3; i < 10; i++) {
      final y = i * 85.0;
      canvas.drawLine(Offset(-40, y), Offset(size.width + 50, y + 190), road);
      canvas.drawLine(
          Offset(-20, y + 32), Offset(size.width + 40, y + 222), minor);
    }
    for (var i = -1; i < 8; i++) {
      final x = i * 80.0;
      canvas.drawLine(Offset(x, -30), Offset(x + 170, size.height), road);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
