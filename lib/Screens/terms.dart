import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Termscondition extends StatefulWidget {
  const Termscondition({ Key? key }) : super(key: key);

  @override
  _TermsconditionState createState() => _TermsconditionState();
}

class _TermsconditionState extends State<Termscondition> {
   String data='';
  fetchData()async{
    String text;
    text=await rootBundle.loadString('images/t&c.txt');
    setState(() {
      data=text;
    });
  }
  @override
  void initState() {
    fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         iconTheme: IconThemeData(
    color: Colors.black, //change your color here
  ),
        title: Text('Terms & Conditions ',style: GoogleFonts.poppins(color:Colors.black,fontWeight: FontWeight.w700)),backgroundColor: Colors.white,elevation: 0,centerTitle: true,),
      body: SingleChildScrollView(child: SafeArea(child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Text(data,style: GoogleFonts.poppins(fontWeight:FontWeight.w500,fontSize: 14)),
      )))
      
    );
  }
}