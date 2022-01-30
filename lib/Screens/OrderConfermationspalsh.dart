import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/getallRestaurents.dart';
import 'package:foodorder_userapp/Screens/onOrderplacemap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class OrderConfirmd extends StatefulWidget {
  var sourceloc;
  var destloc;
  var orderDetails;
  OrderConfirmd({this.sourceloc,this.destloc,this.orderDetails});

  @override
  State<OrderConfirmd> createState() => _OrderConfirmdState();
}

class _OrderConfirmdState extends State<OrderConfirmd> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1),(){
      return Navigator.pushReplacement(context,MaterialPageRoute(builder: (context){
        return  ChangeNotifierProvider(create: (BuildContext context) { 
          return AllRestaurent();
         },
        child: OnorderPlace(sourceloc: widget.sourceloc,destloc: widget.destloc,orderDetails: widget.orderDetails,));
      }));
     
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Icon(FontAwesomeIcons.checkCircle,color: Colors.white,size: 44,)),
            SizedBox(height: 10,),
            Text('Thankyou for ordering with us..',style: GoogleFonts.poppins(color:Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
            Text('Order confirmed',style: GoogleFonts.poppins(color:Colors.white,fontSize: 18,fontWeight: FontWeight.w500)),
            SizedBox(height: 20,),
            Text('Order ID ${widget.orderDetails['shortOrderid']}',style: GoogleFonts.poppins(color:Colors.white,fontSize: 18,fontWeight: FontWeight.w600))

          ],
          
        ),
      ),
      
    );
  }
}