import 'package:flutter/material.dart';
import 'otp_page.dart';
import '../../../../core/theme/app_colors.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});
  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final controller = TextEditingController();
  bool get valid => RegExp(r'^01[0125][0-9]{8}$').hasMatch(controller.text.trim());

  @override
  void dispose() { controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(24,18,24,28),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const Text('رقم موبايلك', textDirection: TextDirection.rtl, textAlign: TextAlign.right,
            style: TextStyle(color: AppColors.textPrimary,fontSize:31,fontWeight:FontWeight.w900)),
          const SizedBox(height:10),
          const Text('هنبعتلك كود تأكيد علشان نأمّن حسابك.', textDirection: TextDirection.rtl,textAlign:TextAlign.right,
            style:TextStyle(color:AppColors.textMuted,fontSize:15)),
          const SizedBox(height:34),
          Directionality(textDirection:TextDirection.ltr,child:TextField(
            controller:controller, keyboardType:TextInputType.phone, autofocus:true,maxLength:11,
            onChanged:(_)=>setState((){}),
            style:const TextStyle(color:AppColors.textPrimary,fontSize:19,fontWeight:FontWeight.w700),
            decoration:InputDecoration(counterText:'',hintText:'01XXXXXXXXX',filled:true,fillColor:AppColors.surface,
              prefixIcon:const Center(widthFactor:1,child:Text('+20',style:TextStyle(color:AppColors.bronzeLight,fontWeight:FontWeight.w800))),
              border:OutlineInputBorder(borderRadius:BorderRadius.circular(18),borderSide:BorderSide.none),
              focusedBorder:OutlineInputBorder(borderRadius:BorderRadius.circular(18),borderSide:const BorderSide(color:AppColors.bronze))
            ))),
          const Spacer(),
          SizedBox(height:58,child:FilledButton(
            onPressed:valid?()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>OtpPage(phone:controller.text.trim()))):null,
            style:FilledButton.styleFrom(backgroundColor:AppColors.ivory,foregroundColor:AppColors.charcoal,
              disabledBackgroundColor:AppColors.surface,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18))),
            child:const Text('متابعة',style:TextStyle(fontSize:17,fontWeight:FontWeight.w800))))
        ]),
      )),
    );
  }
}