import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/orderBackend.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  var id;
  OrderDetails({this.id});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  @override
  Widget build(BuildContext context) {
    print(widget.id);
    var getorder = Provider.of<OrderBackend>(context, listen: false);
    Future getOrderDetails(id) async {
      var order = await getorder.getorderbyId(id);
      return order;
    }

    Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+91'+phoneNumber,
    );
    await launch(launchUri.toString());
  }


    return Scaffold(
      appBar: AppBar(
         iconTheme: IconThemeData(
    color: Colors.black, //change your color here
  ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(''),
      ),
      body: FutureBuilder(
        future: getOrderDetails(widget.id),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print(snapshot.data);
          return Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Summary',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 22)),
                SizedBox(
                  height: 5,
                ),
                Text('${snapshot.data['restroName']['name']}',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 18)),
                GestureDetector(
                  onTap: (){
                    makePhoneCall('${snapshot.data['restroName']['phone']}');
                  },
                  child: Text(
                      'Call ${snapshot.data['restroName']['name']} (${snapshot.data['restroName']['phone']})',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.red)),
                ),
                Row(
                  children: [
                    Text('Order status: ',style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    Text('${snapshot.data['orderStatus']}',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,color: snapshot.data['orderStatus']=="Delivered"?Colors.green:Colors.red)),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Your Order',style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    Text('${snapshot.data['shortOrderid']}',style: GoogleFonts.poppins(fontWeight: FontWeight.w500))
                  ],
                ),
                Divider(),
                Container(
                  height: MediaQuery.of(context).size.height/8.5,
                  child: ListView.builder(
                      itemCount: snapshot.data['orderItems'].length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    snapshot.data['orderItems'][index]
                                                            ['item']['isveg']
                                                        ? 'images/veg.png'
                                                        : 'images/non-veg.png'))),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                          '${snapshot.data['orderItems'][index]['item']['itemName']}',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 20)),
                                    ],
                                  ),
                                   Text(
                                  '${snapshot.data['orderItems'][index]['quantity']} X ₹${snapshot.data['orderItems'][index]['item']['price']}',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 20))
                                ],
                              ),
                              Divider(),

                             
                            ],
                          ),
                        );
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order total:',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18)),
                    Text('₹${snapshot.data['orderTotal']}',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.green,fontSize: 18))
                  ],
                ),
                Divider(),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Payment:',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18)),
                    Text(snapshot.data['paymentId'] == null?'COD':'CARD',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.green,fontSize: 18)),
                    
                  ],
                ),
                Divider(),
                snapshot.data['orderStatus']=="Ordred"||snapshot.data['orderStatus']=="Canceled"||snapshot.data['orderStatus']=="Preapration"?
                Text('Current status: ${snapshot.data['orderStatus']}',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18)):
                snapshot.data['orderStatus']=="Accepted by delivery partner"||snapshot.data['orderStatus']=="Delivery partner reached at Restraunt"?
                Column(
                  children: [
                    Row(
                      children: [
                        Text("Your order assigned to: ",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18)),
                        Text("${snapshot.data['delBoy']['name']}".toUpperCase(),style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.green))
                      ],
                    ),
                    SizedBox(height: 5,),
                    GestureDetector(
                      onTap: (){
                        makePhoneCall('${snapshot.data['delBoy']['phone']}');
                      },
                      child: Row(
                        children: [
                          Icon(FontAwesomeIcons.mobileAlt,size: 22,),
                          Text("Call: ",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.red)),
                          Text('${snapshot.data['delBoy']['phone']}',style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18,color: Colors.red)),
                        ],
                      ),
                    )
                  ],
                ):
                Text('Delivered by: ${snapshot.data['delBoy']['name']}'.toUpperCase(),style: GoogleFonts.poppins(fontWeight: FontWeight.w600,fontSize: 18))
              ],
            ),
          );
        },
      ),
    );
  }
}
