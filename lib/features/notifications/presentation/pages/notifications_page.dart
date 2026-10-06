import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool allRead = false;

  final notifications = const [
    _NotificationData(
      icon: Icons.local_taxi_rounded,
      title: 'رحلتك جاهزة',
      body: 'الكباتن القريبين منك يقدروا يرسلوا عروضهم بمجرد طلب الرحلة.',
      time: 'الآن',
    ),
    _NotificationData(
      icon: Icons.shield_outlined,
      title: 'رحلة آمنة وواضحة',
      body: 'راجع بيانات الكابتن والعربية والسعر قبل اختيار العرض.',
      time: 'اليوم',
    ),
    _NotificationData(
      icon: Icons.location_on_outlined,
      title: 'Yalla Go في سوهاج',
      body: 'بنجهز تجربة أسرع لاختيار مشوارك ومقارنة عروض الكباتن.',
      time: 'أمس',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F1E8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'الإشعارات',
          style: TextStyle(
            color: Color(0xFF171817),
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF171817)),
        ),
        actions: [
          TextButton(
            onPressed: allRead ? null : () => setState(() => allRead = true),
            child: const Text('قراءة الكل'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, index) {
          final item = notifications[index];
          final unread = !allRead && index == 0;
          return Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: unread
                    ? const Color(0xFFB98B52)
                    : const Color(0xFFE7E0D6),
              ),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1ECE4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: const Color(0xFFB98B52)),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xFF171817),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          if (unread)
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFFB98B52),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        item.body,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xFF817A70),
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        item.time,
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          color: Color(0xFF9A9388),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NotificationData {
  const _NotificationData({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
  });

  final IconData icon;
  final String title;
  final String body;
  final String time;
}
