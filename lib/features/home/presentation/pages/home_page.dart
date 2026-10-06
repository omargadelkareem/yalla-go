import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Stack(children:[
      const Positioned.fill(child:_MapPreview()),
      SafeArea(child:Padding(padding:const EdgeInsets.fromLTRB(18,14,18,0),child:Row(children:[
        Material(color:AppColors.charcoal,shape:const CircleBorder(),child:IconButton(onPressed:(){},icon:const Icon(Icons.menu_rounded,color:AppColors.ivory))),
        const Spacer(),
        Container(padding:const EdgeInsets.symmetric(horizontal:14,vertical:10),
          decoration:BoxDecoration(color:AppColors.charcoal,borderRadius:BorderRadius.circular(30)),
          child:const Row(children:[Icon(Icons.location_on_rounded,color:AppColors.bronzeLight,size:17),SizedBox(width:6),
            Text('سوهاج',textDirection:TextDirection.rtl,style:TextStyle(color:AppColors.ivory,fontWeight:FontWeight.w700))]))
      ]))),
      Positioned(left:18,right:18,bottom:22,child:SafeArea(top:false,child:Container(
        padding:const EdgeInsets.all(18),
        decoration:BoxDecoration(color:AppColors.charcoal,borderRadius:BorderRadius.circular(26),
          border:Border.all(color:const Color(0xFF363731)),boxShadow:const [BoxShadow(color:Color(0x55000000),blurRadius:30,offset:Offset(0,15))]),
        child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.stretch,children:[
          const Text('رايح فين؟',textDirection:TextDirection.rtl,textAlign:TextAlign.right,
            style:TextStyle(color:AppColors.textPrimary,fontSize:25,fontWeight:FontWeight.w900)),
          const SizedBox(height:14),
          Container(height:58,padding:const EdgeInsets.symmetric(horizontal:16),
            decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(18)),
            child:const Row(textDirection:TextDirection.rtl,children:[
              Icon(Icons.search_rounded,color:AppColors.bronzeLight),SizedBox(width:12),
              Text('حدد وجهتك',textDirection:TextDirection.rtl,style:TextStyle(color:AppColors.ivory,fontSize:16,fontWeight:FontWeight.w700))
            ])),
          const SizedBox(height:14),
          const Row(textDirection:TextDirection.rtl,children:[
            Icon(Icons.my_location_rounded,color:AppColors.bronze,size:18),SizedBox(width:8),
            Text('موقعك الحالي',textDirection:TextDirection.rtl,style:TextStyle(color:AppColors.textMuted,fontSize:13)),
            Spacer(),Text('جاهز للمشوار',textDirection:TextDirection.rtl,style:TextStyle(color:AppColors.bronzeLight,fontSize:12,fontWeight:FontWeight.w700))
          ])
        ])
      )))
    ]));
  }
}

class _MapPreview extends StatelessWidget {
  const _MapPreview();
  @override
  Widget build(BuildContext context)=>ColoredBox(color:const Color(0xFFDDD6C9),child:CustomPaint(
    painter:_MapPainter(),child:const Center(child:CircleAvatar(radius:25,backgroundColor:AppColors.charcoal,
      child:Icon(Icons.navigation_rounded,color:AppColors.bronzeLight)))));
}
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas,Size size){
    final road=Paint()..color=const Color(0xFFF3EEE5)..strokeWidth=10..strokeCap=StrokeCap.round;
    final minor=Paint()..color=const Color(0xFFC8C0B3)..strokeWidth=2.5;
    for(var i=-2;i<9;i++){final y=size.height*.1+i*105;canvas.drawLine(Offset(-20,y),Offset(size.width+30,y+160),road);canvas.drawLine(Offset(-20,y+42),Offset(size.width+30,y+202),minor);}
    for(var i=0;i<7;i++){final x=i*85.0;canvas.drawLine(Offset(x,-20),Offset(x+180,size.height+20),road);}
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}