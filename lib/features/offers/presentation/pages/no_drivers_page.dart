import 'package:flutter/material.dart';

class NoDriversPage extends StatelessWidget {
  const NoDriversPage({
    super.key,
    required this.destination,
    required this.vehicleType,
  });

  final String destination;
  final String vehicleType;

  @override
  Widget build(BuildContext context) {
    final vehicleLabel = vehicleType == 'motorcycle' ? 'موتوسيكل' : 'عربية';

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F1E8),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF171817)),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 92,
                height: 92,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFBF5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_taxi_outlined,
                  size: 43,
                  color: Color(0xFFB98B52),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'مفيش كباتن متاحين دلوقتي',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF171817),
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                'ملقيناش $vehicleLabel قريب يقدر يستقبل الرحلة حالياً. جرّب تاني بعد شوية أو غيّر نوع المركبة.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF817A70),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFFB98B52),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        destination,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF171817),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF171817),
                    foregroundColor: const Color(0xFFFFFBF5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF171817),
                    side: const BorderSide(color: Color(0xFFD8D0C5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'تغيير نوع المركبة',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
