import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/yalla_go_logo.dart';

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
              const Align(alignment: Alignment.center, child: YallaGoLogo(size: 96)),
              const SizedBox(height: 30),
              const Text(
                'أهلاً بيك في Yalla Go',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: AppColors.textDark,
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
                  color: AppColors.textMutedDark,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 58,
                child: FilledButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.phoneLogin),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.turquoise,
                    foregroundColor: AppColors.white,
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
                  color: AppColors.textMutedDark,
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
