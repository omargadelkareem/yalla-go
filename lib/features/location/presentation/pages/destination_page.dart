import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DestinationPage extends StatefulWidget {
  const DestinationPage({super.key});
  @override
  State<DestinationPage> createState()=>_DestinationPageState();
}
class _DestinationPageState extends State<DestinationPage>{
  final controller=TextEditingController();
  @override void dispose(){controller.dispose();super.dispose();}
  @override
  Widget build(BuildContext context){
    return Scaffold(backgroundColor:const Color(0xFFF6F1E8),body:Stack(children:[
      const Positioned.fill(child:_DestinationMap()),
      SafeArea(child:Padding(padding:const EdgeInsets.all(16),child:Align(alignment:Alignment.topLeft,
        child:Material(color:const Color(0xFFFFFBF5),shape:const CircleBorder(),elevation:3,
          child:IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.arrow_back_rounded,color:Color(0xFF171817))))))),
      Align(alignment:Alignment.bottomCenter,child:Container(
        constraints:const BoxConstraints(maxHeight:360),
        padding:const EdgeInsets.fromLTRB(20,12,20,24),
        decoration:const BoxDecoration(color:Color(0xFFFFFBF5),borderRadius:BorderRadius.vertical(top:Radius.circular(30)),
          boxShadow:[BoxShadow(color:Color(0x22000000),blurRadius:25,offset:Offset(0,-8))]),
        child:SafeArea(top:false,child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          Center(child:Container(width:38,height:4,decoration:BoxDecoration(color:const Color(0xFFD7D0C5),borderRadius:BorderRadius.circular(20)))),
          const SizedBox(height:16),
          const Text('حدد وجهتك',textDirection:TextDirection.rtl,textAlign:TextAlign.right,
            style:TextStyle(color:Color(0xFF171817),fontSize:23,fontWeight:FontWeight.w800)),
          const SizedBox(height:13),
          TextField(controller:controller,textDirection:TextDirection.rtl,
            decoration:InputDecoration(hintText:'ابحث عن مكان أو عنوان',prefixIcon:const Icon(Icons.search_rounded),
              filled:true,fillColor:const Color(0xFFF1ECE4),border:OutlineInputBorder(borderRadius:BorderRadius.circular(16),borderSide:BorderSide.none))),
          const SizedBox(height:12),
          const _Place(icon:Icons.home_rounded,title:'المنزل',subtitle:'أضف عنوان المنزل'),
          const _Place(icon:Icons.work_rounded,title:'العمل',subtitle:'أضف عنوان العمل'),
          const _Place(icon:Icons.location_on_outlined,title:'اختيار من الخريطة',subtitle:'حرّك الخريطة وحدد المكان بدقة'),
        ]))
      ))
    ]));
  }
}
class _Place extends StatelessWidget{
 const _Place({required this.icon,required this.title,required this.subtitle});
 final IconData icon;final String title,subtitle;
 @override Widget build(BuildContext context)=>ListTile(
   contentPadding:EdgeInsets.zero,leading:Container(width:42,height:42,decoration:BoxDecoration(color:const Color(0xFFF1ECE4),borderRadius:BorderRadius.circular(13)),child:Icon(icon,color:const Color(0xFF171817),size:20)),
   title:Text(title,textDirection:TextDirection.rtl,textAlign:TextAlign.right,style:const TextStyle(color:Color(0xFF171817),fontWeight:FontWeight.w700,fontSize:14)),
   subtitle:Text(subtitle,textDirection:TextDirection.rtl,textAlign:TextAlign.right,style:const TextStyle(color:Color(0xFF817A70),fontSize:11)),
   trailing:const Icon(Icons.chevron_right_rounded,color:Color(0xFF9A9388)));
}
class _DestinationMap extends StatelessWidget{
 const _DestinationMap();
 @override Widget build(BuildContext context)=>CustomPaint(painter:_Painter(),child:const Center(child:Padding(
   padding:EdgeInsets.only(bottom:250),child:Icon(Icons.location_on_rounded,color:AppColors.bronze,size:48))));
}
class _Painter extends CustomPainter{
 @override void paint(Canvas c,Size s){c.drawColor(const Color(0xFFEAE7E0));final p=Paint()..color=Colors.white..strokeWidth=8..strokeCap=StrokeCap.round;for(var i=-3;i<10;i++){final y=i*85.0;c.drawLine(Offset(-40,y),Offset(s.width+50,y+190),p);}for(var i=-1;i<8;i++){final x=i*80.0;c.drawLine(Offset(x,-30),Offset(x+170,s.height),p);}}
 @override bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}