import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import 'otp_page.dart';

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

  String get firebasePhone {
    final phone = controller.text.trim();
    return '+20${phone.substring(1)}';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (!valid || loading) return;
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
      error = null;
    });

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: firebasePhone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
        } on FirebaseAuthException catch (e) {
          if (!mounted) return;
          setState(() {
            loading = false;
            error = _messageFor(e.code);
          });
        }
      },
      verificationFailed: (e) {
        if (!mounted) return;
        setState(() {
          loading = false;
          error = _messageFor(e.code);
        });
      },
      codeSent: (verificationId, resendToken) {
        if (!mounted) return;
        setState(() => loading = false);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OtpPage(
              phone: controller.text.trim(),
              verificationId: verificationId,
              resendToken: resendToken,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (_) {
        if (mounted) setState(() => loading = false);
      },
    );
  }

  String _messageFor(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return 'رقم الموبايل غير صحيح.';
      case 'too-many-requests':
        return 'تم إرسال محاولات كثيرة. حاول مرة تانية بعد شوية.';
      case 'network-request-failed':
        return 'تأكد من اتصال الإنترنت وحاول مرة تانية.';
      case 'operation-not-allowed':
        return 'تسجيل الدخول بالموبايل غير مفعّل على Firebase.';
      default:
        return 'تعذر إرسال الكود حالياً. حاول مرة تانية.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.charcoal,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 12, 22, 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: _CircleButton(
                  icon: Icons.arrow_back_rounded,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              const _MiniBrand(),
              const SizedBox(height: 34),
              const Text(
                'رقم موبايلك',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'هنبعتلك كود تأكيد علشان نأمّن حسابك ونبدأ مشوارك.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.textMuted,
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
                    color: AppColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .5,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '01XXXXXXXXX',
                    hintStyle: const TextStyle(color: Color(0xFF77776F)),
                    filled: true,
                    fillColor: AppColors.surface,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          '+20',
                          style: TextStyle(
                            color: AppColors.bronzeLight,
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
                      borderSide:
                          const BorderSide(color: AppColors.bronze, width: 1.4),
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
                  style: const TextStyle(
                    color: Color(0xFFE6A79D),
                    fontSize: 12,
                  ),
                ),
              ],
              const Spacer(flex: 2),
              SizedBox(
                height: 58,
                child: FilledButton(
                  onPressed: valid && !loading ? _sendCode : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.ivory,
                    foregroundColor: AppColors.charcoal,
                    disabledBackgroundColor: AppColors.surface,
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
                            color: AppColors.charcoal,
                          ),
                        )
                      : const Text(
                          'إرسال كود التأكيد',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
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

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(icon, color: AppColors.ivory),
        ),
      );
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
                color: AppColors.charcoal,
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
