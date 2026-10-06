import 'package:flutter/material.dart';

class DriverOffersPage extends StatelessWidget {
  const DriverOffersPage({super.key,required this.destination,required this.vehicleType});
  final String destination,vehicleType;

  @override
  Widget build(BuildContext context){
    final data=vehicleType=='motorcycle'
      ? const [_Offer('أحمد محمد','Honda 2023','3 د','36 ج',4.9,326),_Offer('محمود علي','Bajaj 2022','5 د','38 ج',4.8,211),_Offer('محمد حسن','Honda 2021','6 د','40 ج',4.7,148)]
      : const [_Offer('أحمد محمد','Hyundai Verna','4 د','58 ج',4.9,326),_Offer('محمود علي','Chevrolet Optra','6 د','60 ج',4.8,211),_Offer('محمد حسن','Nissan Sunny','7 د','63 ج',4.7,148)];
    return Scaffold(backgroundColor:const Color(0xFFF6F1E8),body:Stack(children:[
      const Positioned.fill(child:_Map()),
      SafeArea(child:Padding(padding:const EdgeInsets.all(16),child:Align(alignment:Alignment.topLeft,child:Material(
        color:const Color(0xFFFFFBF5),shape:const CircleBorder(),elevation:3,
        child:IconButton(onPressed:()=>Navigator.pop(context),icon:const Icon(Icons.arrow_back_rounded,color:Color(0xFF171817))))))),
      Align(alignment:Alignment.bottomCenter,child:Container(height:MediaQuery.of(context).size.height*.56,
        padding:const EdgeInsets.fromLTRB(18,12,18,18),
        decoration:const BoxDecoration(color:Color(0xFFFFFBF5),borderRadius:BorderRadius.vertical(top:Radius.circular(30)),
          boxShadow:[BoxShadow(color:Color(0x22000000),blurRadius:28,offset:Offset(0,-8))]),
        child:SafeArea(top:false,child:Column(children:[
          Container(width:38,height:4,decoration:BoxDecoration(color:const Color(0xFFD7D0C5),borderRadius:BorderRadius.circular(20))),
          const SizedBox(height:14),
          Row(textDirection:TextDirection.rtl,children:[
            const Expanded(child:Text('عروض الكباتن',textDirection:TextDirection.rtl,textAlign:TextAlign.right,
              style:TextStyle(color:Color(0xFF171817),fontSize:22,fontWeight:FontWeight.w800))),
            Container(padding:const EdgeInsets.symmetric(horizontal:10,vertical:6),decoration:BoxDecoration(color:const Color(0xFFFFF1D8),borderRadius:BorderRadius.circular(20)),
              child:Text('${data.length} عروض',textDirection:TextDirection.rtl,style:const TextStyle(color:Color(0xFF8C6535),fontSize:11,fontWeight:FontWeight.w700)))
          ]),
          const SizedBox(height:4),
          Align(alignment:Alignment.centerRight,child:Text(destination,textDirection:TextDirection.rtl,overflow:TextOverflow.ellipsis,
            style:const TextStyle(color:Color(0xFF817A70),fontSize:11))),
          const SizedBox(height:12),
          Expanded(child:ListView.separated(padding:EdgeInsets.zero,itemCount:data.length,separatorBuilder:(_,__)=>const SizedBox(height:10),
            itemBuilder:(_,i)=>_Card(data:data[i])))
        ])))
      ))
    ]));
  }
}
class _Card extends StatelessWidget{
 const _Card({required this.data}); final _Offer data;
 @override Widget build(BuildContext context)=>Container(padding:const EdgeInsets.all(14),decoration:BoxDecoration(
   color:const Color(0xFFF4EFE7),borderRadius:BorderRadius.circular(20),border:Border.all(color:const Color(0xFFE6DED2))),
   child:Column(children:[
    Row(textDirection:TextDirection.rtl,children:[
      Container(width:52,height:52,decoration:const BoxDecoration(color:Color(0xFF171817),shape:BoxShape.circle),
        child:const Icon(Icons.person_rounded,color:Color(0xFFFFFBF5),size:29)),
      const SizedBox(width:11),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.end,children:[
        Text(data.name,textDirection:TextDirection.rtl,style:const TextStyle(color:Color(0xFF171817),fontSize:15,fontWeight:FontWeight.w800)),
        const SizedBox(height:3),
        Row(mainAxisAlignment:MainAxisAlignment.end,children:[
          Text('${data.trips} رحلة',textDirection:TextDirection.rtl,style:const TextStyle(color:Color(0xFF817A70),fontSize:10)),
          const SizedBox(width:8),const Icon(Icons.star_rounded,color:Color(0xFFB98B52),size:15),
          Text(data.rating.toString(),style:const TextStyle(color:Color(0xFF171817),fontSize:11,fontWeight:FontWeight.w700))
        ]),
        Text('${data.vehicle} • ${data.eta}',textDirection:TextDirection.rtl,style:const TextStyle(color:Color(0xFF817A70),fontSize:10))
      ])),
      const SizedBox(width:10),
      Text(data.price,textDirection:TextDirection.rtl,style:const TextStyle(color:Color(0xFF171817),fontSize:20,fontWeight:FontWeight.w900))
    ]),
    const SizedBox(height:12),
    SizedBox(width:double.infinity,height:44,child:FilledButton(onPressed:(){},style:FilledButton.styleFrom(
      backgroundColor:const Color(0xFF171817),foregroundColor:const Color(0xFFFFFBF5),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(14))),
      child:const Text('اختيار العرض',style:TextStyle(fontWeight:FontWeight.w800))))
   ]));
}
class _Offer{
 const _Offer(this.name,this.vehicle,this.eta,this.price,this.rating,this.trips);
 final String name,vehicle,eta,price; final double rating; final int trips;
}
class _Map extends StatelessWidget{
 const _Map();
 @override Widget build(BuildContext context)=>CustomPaint(painter:_Painter(),child:const SizedBox.expand());
}
class _Painter extends CustomPainter{
 @override void paint(Canvas canvas,Size size){
  canvas.drawColor(const Color(0xFFEAE7E0));
  final road=Paint()..color=Colors.white..strokeWidth=8..strokeCap=StrokeCap.round;
  for(var i=-3;i<10;i++){final y=i*85.0;canvas.drawLine(Offset(-40,y),Offset(size.width+50,y+190),road);}
  final pin=Paint()..color=const Color(0xFF171817);
  canvas.drawCircle(Offset(size.width*.30,180),8,pin);canvas.drawCircle(Offset(size.width*.62,235),8,pin);canvas.drawCircle(Offset(size.width*.77,145),8,pin);
 }
 @override bool shouldRepaint(CustomPainter oldDelegate)=>false;
}