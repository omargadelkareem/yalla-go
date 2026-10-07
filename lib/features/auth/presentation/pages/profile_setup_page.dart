import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/session/rider_session.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({
    super.key,
    required this.phone,
    required this.phoneKey,
  });

  final String phone;
  final String phoneKey;

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final nameController = TextEditingController();
  bool loading = false;
  String? error;

  bool get valid => nameController.text.trim().length >= 3;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!valid || loading) return;
    FocusScope.of(context).unfocus();
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final ref = FirebaseDatabase.instance.ref('usersByPhone/${widget.phoneKey}');
      await ref.set({
        'name': nameController.text.trim(),
        'phone': widget.phone,
        'phoneInternational': '+${widget.phoneKey}',
        'role': 'rider',
        'createdAt': ServerValue.timestamp,
        'updatedAt': ServerValue.timestamp,
      });

      RiderSession.setUser(
        key: widget.phoneKey,
        phoneNumber: widget.phone,
        riderName: nameController.text.trim(),
      );

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (_) => false,
      );
    } on FirebaseException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.code == 'permission-denied'
            ? 'قاعدة البيانات لا تسمح بإنشاء الحساب حالياً.'
            : 'تعذر إنشاء الحساب. حاول مرة تانية.';
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
                    onPressed: loading ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.ivory),
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 74,
                  height: 74,
                  decoration: BoxDecoration(
                    color: AppColors.ivory,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.background,
                    size: 34,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'نعرفك أكتر',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'رقمك ${widget.phone} جديد عندنا. اكتب اسمك ونجهز حسابك فوراً.',
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.textMutedDark,
                  fontSize: 14,
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 28),
              Directionality(
                textDirection: TextDirection.rtl,
                child: TextField(
                  controller: nameController,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onChanged: (_) => setState(() => error = null),
                  onSubmitted: (_) => _createAccount(),
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: 'الاسم بالكامل',
                    hintStyle: const TextStyle(color: Color(0xFF77776F)),
                    prefixIcon: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.turquoiseDark,
                    ),
                    filled: true,
                    fillColor: AppColors.white,
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
                  onPressed: valid && !loading ? _createAccount : null,
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
                          'إنشاء الحساب',
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
