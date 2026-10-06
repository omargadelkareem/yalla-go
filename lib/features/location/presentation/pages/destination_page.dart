import 'package:flutter/material.dart';
import '../../../ride/presentation/pages/ride_options_page.dart';

class DestinationPage extends StatefulWidget {
  const DestinationPage({super.key});

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  final TextEditingController controller = TextEditingController();

  final List<String> _demoPlaces = const [
    'جامعة سوهاج الجديدة',
    'جامعة سوهاج القديمة',
    'ميدان الثقافة - سوهاج',
    'ميدان العروبة - سوهاج',
    'محطة قطار سوهاج',
    'مستشفى سوهاج الجامعي',
    'كورنيش النيل - سوهاج',
    'شارع الجمهورية - سوهاج',
  ];

  List<String> get _results {
    final query = controller.text.trim();
    if (query.isEmpty) return const [];
    return _demoPlaces.where((place) => place.contains(query)).toList();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

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
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF171817),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: controller.text.isEmpty ? 210 : 410,
              ),
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'رايح فين؟',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Color(0xFF171817),
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      cursorColor: const Color(0xFF171817),
                      style: const TextStyle(
                        color: Color(0xFF171817),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'اكتب اسم الوجهة',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: const TextStyle(
                          color: Color(0xFF817A70),
                          fontWeight: FontWeight.w500,
                        ),
                        suffixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF171817),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF1ECE4),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 17,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (controller.text.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Flexible(
                        child: results.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  'لا توجد نتائج مطابقة',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: Color(0xFF817A70),
                                    fontSize: 13,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: results.length,
                                separatorBuilder: (_, __) => const Divider(
                                  height: 1,
                                  color: Color(0xFFE7E0D6),
                                ),
                                itemBuilder: (context, index) {
                                  final place = results[index];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => RideOptionsPage(
                                            destination: place,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1ECE4),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.location_on_outlined,
                                        color: Color(0xFFB98B52),
                                        size: 20,
                                      ),
                                    ),
                                    title: Text(
                                      place,
                                      textDirection: TextDirection.rtl,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        color: Color(0xFF171817),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
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

class _DestinationMap extends StatelessWidget {
  const _DestinationMap();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapPainter(),
      child: const SizedBox.expand(
        child: Align(
          alignment: Alignment(0, -0.25),
          child: Icon(
            Icons.location_on_rounded,
            color: Color(0xFFB98B52),
            size: 48,
          ),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
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

    for (var i = -1; i < 8; i++) {
      final x = i * 80.0;
      canvas.drawLine(
        Offset(x, -30),
        Offset(x + 170, size.height),
        road,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
