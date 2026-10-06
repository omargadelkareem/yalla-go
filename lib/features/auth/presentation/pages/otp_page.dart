import 'package:flutter/material.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, required this.phone});
  final String phone;
  @override
  State<OtpPage> createState() => _OtpPageState();
}
class _OtpPageState extends State<OtpPage> {
  final controller=TextEditingController();
  @override
  void dispose(){controller.dispose();super.dispose();}
  @override
  Widget build(BuildContext context){
    final complete=controller.text.length==6;
    return Scaffold(
      appBar:AppBar(backgroundColor:Colors.transparent),
      body:SafeArea(child:Padding(padding:const EdgeInsets.fromLTRB(24,18,24,28),child:Column(
        crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          const Text('كود التأكيد',textDirection:TextDirection.rtl,textAlign:TextAlign.right,
            style:TextStyle(color:AppColors.textPrimary,fontSize:31,fontWeight:FontWeight.w900)),
          const SizedBox(height:10),
          Text('دخل الكود المكوّن من 6 أرقام اللي اتبعت على '+widget.phone,textDirection:TextDirection.rtl,textAlign:TextAlign.right,
            style:const TextStyle(color:AppColors.textMuted,fontSize:15,height:1.5)),
          const SizedBox(height:34),
          TextField(controller:controller,keyboardType:TextInputType.number,autofocus:true,maxLength:6,textAlign:TextAlign.center,
            onChanged:(_)=>setState((){}),style:const TextStyle(color:AppColors.textPrimary,fontSize:27,fontWeight:FontWeight.w800,letterSpacing:12),
            decoration:InputDecoration(counterText:'',hintText:'••••••',filled:true,fillColor:AppColors.surface,
              border:OutlineInputBorder(borderRadius:BorderRadius.circular(18),borderSide:BorderSide.none))),
          const Spacer(),
          SizedBox(height:58,child:FilledButton(
            onPressed:complete?()=>Navigator.pushNamedAndRemoveUntil(context,AppRoutes.home,(_)=>false):null,
            style:FilledButton.styleFrom(backgroundColor:AppColors.ivory,foregroundColor:AppColors.charcoal,
              disabledBackgroundColor:AppColors.surface,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(18))),
            child:const Text('تأكيد',style:TextStyle(fontSize:17,fontWeight:FontWeight.w800))))
        ])))
    );
  }
}