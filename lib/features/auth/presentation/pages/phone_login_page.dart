import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/session/rider_session.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/yalla_go_logo.dart';
import 'profile_setup_page.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final controller = TextEditingController();
  bool loading = false;
  String? error;

  bool get valid =>
      RegExp(r'^01[0125][0-9]{8}$').hasMatch(controller.text.trim());

  String get normalizedPhone => '20${controller.text.trim().substring(1)}';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (!valid || loading) return;
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final phone = controller.text.trim();
      final snapshot = await FirebaseDatabase.instance
          .ref('usersByPhone/$normalizedPhone')
          .get();

      if (!mounted) return;

      if (snapshot.exists) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        RiderSession.setUser(
          key: normalizedPhone,
          phoneNumber: (data['phone'] ?? phone).toString(),
          riderName: (data['name'] ?? 'مستخدم Yalla Go').toString(),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.home,
          (_) => false,
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProfileSetupPage(
              phone: phone,
              phoneKey: normalizedPhone,
            ),
          ),
        );
      }
    } on FirebaseException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.code == 'permission-denied'
            ? 'قاعدة البيانات لا تسمح بتسجيل الحساب حالياً.'
            : 'تعذر الاتصال بالسيرفر. حاول مرة تانية.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => error = 'حصل خطأ غير متوقع. حاول مرة تانية.');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: AppColors.white,
                  shape: const CircleBorder(),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ivory),
                  ),
                ),
              ),
              const Spacer(),
              const YallaGoLogo(size: 72),
              const SizedBox(height: 34),
              const Text(
                'رقم موبايلك',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'اكتب رقمك علشان ندخل على حسابك أو ننشئ لك حساب جديد.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.textMutedDark,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 28),
              Directionality(
                textDirection: TextDirection.ltr,
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  maxLength: 11,
                  onChanged: (_) => setState(() => error = null),
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .5,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '01XXXXXXXXX',
                    hintStyle: const TextStyle(color: Color(0xFF77776F)),
                    filled: true,
                    fillColor: AppColors.white,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          '+20',
                          style: TextStyle(
                            color: AppColors.turquoiseDark,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(19),
                      borderSide: const BorderSide(
                        color: AppColors.turquoise,
                        width: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
              if (error != null) ...[
                const SizedBox(height: 12),
                Text(
                  error!,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Color(0xFFE6A79D), fontSize: 12),
                ),
              ],
              const Spacer(flex: 2),
              SizedBox(
                height: 58,
                child: FilledButton(
                  onPressed: valid && !loading ? _continue : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.ivory,
                    foregroundColor: AppColors.background,
                    disabledBackgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: loading
                      ? const SizedBox(
                          width: 23,
                          height: 23,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.background,
                          ),
                        )
                      : const Text(
                          'متابعة',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
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

class _MiniBrand extends StatelessWidget {
  const _MiniBrand();

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.rtl,
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: AppColors.ivory,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.near_me_rounded,
                color: AppColors.background,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'YALLA GO',
              style: TextStyle(
                color: AppColors.ivory,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.8,
              ),
            ),
          ],
        ),
      );
}
