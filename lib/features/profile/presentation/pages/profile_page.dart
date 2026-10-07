import 'package:flutter/material.dart';
import '../../../../core/session/rider_session.dart';
import '../../../../core/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(title: const Text('حسابي'), centerTitle: true),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const CircleAvatar(
          radius: 42,
          backgroundColor: AppColors.navy,
          child: Icon(Icons.person_rounded, color: AppColors.white, size: 44),
        ),
        const SizedBox(height: 12),
        Text(
          RiderSession.name ?? 'مستخدم Yalla Go',
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: const TextStyle(color: AppColors.navy,fontSize: 20,fontWeight: FontWeight.w900),
        ),
        Text(
          RiderSession.phone ?? '',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textMutedDark),
        ),
        const SizedBox(height: 26),
        const _Tile(Icons.person_outline_rounded, 'تعديل البيانات'),
        const _Tile(Icons.bookmark_border_rounded, 'الأماكن المحفوظة'),
        const _Tile(Icons.notifications_none_rounded, 'الإشعارات'),
        const _Tile(Icons.language_rounded, 'اللغة'),
        const _Tile(Icons.logout_rounded, 'تسجيل الخروج', danger: true),
      ],
    ),
  );
}

class _Tile extends StatelessWidget {
  const _Tile(this.icon, this.title, {this.danger = false});
  final IconData icon;
  final String title;
  final bool danger;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(color: AppColors.white,borderRadius: BorderRadius.circular(17)),
    child: ListTile(
      leading: Icon(Icons.chevron_left_rounded,color: danger ? const Color(0xFFB84646) : AppColors.navy),
      trailing: Icon(icon,color: danger ? const Color(0xFFB84646) : AppColors.turquoise),
      title: Text(
        title,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        style: TextStyle(color: danger ? const Color(0xFFB84646) : AppColors.navy,fontWeight: FontWeight.w700),
      ),
    ),
  );
}
