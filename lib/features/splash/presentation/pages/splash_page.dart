import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/yalla_go_logo.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 1000));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _scale = Tween<double>(begin: .88,end: 1).animate(CurvedAnimation(parent: _controller,curve: Curves.easeOutBack));
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 1900), () {
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.navyDeep, AppColors.navy, Color(0xFF08445B)],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: -90,bottom: -120,
              child: Container(width: 300,height: 300,decoration: BoxDecoration(shape: BoxShape.circle,color: AppColors.turquoise.withOpacity(.10))),
            ),
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: const YallaGoLogo(size: 118,darkBackground: true),
                ),
              ),
            ),
            const Positioned(
              left: 24,right: 24,bottom: 46,
              child: Text(
                'مشوارك .. بيدك',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(color: Color(0xFFD9F6F8),fontSize: 15,fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
