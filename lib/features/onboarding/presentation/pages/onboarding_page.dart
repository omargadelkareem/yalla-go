import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  static const _pages = [
    (
      icon: Icons.route_rounded,
      title: 'مشوارك.. بطريقتك',
      description: 'حدد وجهتك وشوف السعر الاسترشادي قبل ما تطلب رحلتك.',
    ),
    (
      icon: Icons.local_offer_rounded,
      title: 'اختار العرض المناسب',
      description: 'استقبل عروض الكباتن القريبين وقارن السعر ووقت الوصول براحتك.',
    ),
    (
      icon: Icons.verified_user_rounded,
      title: 'رحلة أوضح من البداية',
      description: 'بيانات الكابتن والرحلة قدامك، من أول الطلب لحد ما توصل.',
    ),
  ];

  void _next() {
    if (_index == _pages.length - 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
              child: Row(
                children: [
                  const Text(
                    'YALLA GO',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                      color: AppColors.ivory,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.welcome,
                    ),
                    child: const Text(
                      'تخطي',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 210,
                          height: 210,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                AppColors.bronze.withValues(alpha: .18),
                                AppColors.bronze.withValues(alpha: .02),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 104,
                              height: 104,
                              decoration: BoxDecoration(
                                color: AppColors.ivory,
                                borderRadius: BorderRadius.circular(34),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x33000000),
                                    blurRadius: 28,
                                    offset: Offset(0, 16),
                                  ),
                                ],
                              ),
                              child: Icon(
                                page.icon,
                                color: AppColors.charcoal,
                                size: 48,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 44),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 29,
                            height: 1.25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 16,
                            height: 1.7,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: i == _index ? 28 : 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: i == _index
                              ? AppColors.bronze
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.ivory,
                        foregroundColor: AppColors.charcoal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        _index == _pages.length - 1 ? 'ابدأ الآن' : 'التالي',
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
