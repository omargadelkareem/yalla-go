import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: AppColors.ivory,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.near_me_rounded,
                    color: AppColors.charcoal,
                    size: 42,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'أهلاً بيك في Yalla Go',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'مشوارك في سوهاج يبدأ من هنا.',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 58,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.ivory,
                    foregroundColor: AppColors.charcoal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'تسجيل الدخول برقم الموبايل',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'بالمتابعة أنت توافق على شروط الاستخدام وسياسة الخصوصية',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
