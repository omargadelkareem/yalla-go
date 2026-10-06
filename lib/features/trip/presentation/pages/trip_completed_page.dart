import 'package:flutter/material.dart';

class TripCompletedPage extends StatefulWidget {
  const TripCompletedPage({
    super.key,
    required this.captainName,
    required this.price,
    required this.destination,
  });

  final String captainName, price, destination;

  @override
  State<TripCompletedPage> createState() => _TripCompletedPageState();
}

class _TripCompletedPageState extends State<TripCompletedPage> {
  int rating = 0;
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void finish() {
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(height: 42),
              Container(
                width: 82,
                height: 82,
                decoration: const BoxDecoration(
                  color: Color(0xFF171817),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded,
                    color: Color(0xFFD7B27A), size: 44),
              ),
              const SizedBox(height: 20),
              const Text(
                'وصلت بالسلامة',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: Color(0xFF171817),
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                widget.destination,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF817A70), fontSize: 12),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF5),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(color: Color(0x16000000), blurRadius: 18)
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('إجمالي الرحلة',
                            style: TextStyle(
                                color: Color(0xFF817A70), fontSize: 12)),
                        Text(
                          widget.price,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: Color(0xFF171817),
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28, color: Color(0xFFE7E0D6)),
                    const Row(
                      textDirection: TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('طريقة الدفع',
                            style: TextStyle(
                                color: Color(0xFF817A70), fontSize: 12)),
                        Row(
                          children: [
                            Text('كاش',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                    color: Color(0xFF171817),
                                    fontWeight: FontWeight.w800)),
                            SizedBox(width: 6),
                            Icon(Icons.payments_outlined,
                                color: Color(0xFFB98B52), size: 20),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'قيّم رحلتك مع ${widget.captainName}',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF171817),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    onPressed: () => setState(() => rating = i + 1),
                    icon: Icon(
                      i < rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: const Color(0xFFB98B52),
                      size: 34,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: commentController,
                maxLines: 3,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Color(0xFF171817)),
                decoration: InputDecoration(
                  hintText: 'اكتب تعليقاً عن الرحلة (اختياري)',
                  hintTextDirection: TextDirection.rtl,
                  hintStyle:
                      const TextStyle(color: Color(0xFF817A70), fontSize: 12),
                  filled: true,
                  fillColor: const Color(0xFFFFFBF5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(17),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: finish,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF171817),
                    foregroundColor: const Color(0xFFFFFBF5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Text(
                    rating == 0 ? 'تخطي' : 'إرسال التقييم',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w900),
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
