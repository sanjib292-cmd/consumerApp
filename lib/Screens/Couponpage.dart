import 'package:flutter/material.dart';
import 'package:foodorder_userapp/Backend/couponBackend.dart';
import 'package:foodorder_userapp/Design&Ui/addedcartSnackbar.dart';
import 'package:foodorder_userapp/Design&Ui/loadingShimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';

class CouponPage extends StatefulWidget {
  var fromcartpage;
  var toke;
  CouponPage({this.fromcartpage,this.toke});

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  @override
  Widget build(BuildContext context) {
    var coupon=Provider.of<CouponBackend>(context,listen: false);
    return Scaffold(appBar: AppBar(title: Text('Offers',style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
    centerTitle: true,
    
    ),
    body: Column(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: coupon.getCoupon(),
          builder: (context,AsyncSnapshot snap) {
            if(snap.connectionState==ConnectionState.waiting){
             return   Align(
          alignment: Alignment.topLeft,
          child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[200]!,
              child: Card(
               // elevation: 15,
                child: ClipPath(
                  child: Container(
                    height: 20,
                    width:180,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(color: Colors.grey, width: 4))),
                  ),
                  clipper: ShapeBorderClipper(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3))),
                ),
              ),
            ),
        );
            }
            if(snap.connectionState==ConnectionState.none){
              return Text('No Coupon..');
            }
            return Container(
              height: MediaQuery.of(context).size.height/2,
              child: ListView.builder(
                itemCount: snap.data.length,
                itemBuilder: (context,index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                      color: Colors.red, //                   <--- border color
                  width: 2.0,
                    )),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text('CODE: ${snap.data[index]['couponCode']}',style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),Text('Get 10% off',style: GoogleFonts.poppins(color:Colors.red),)],
                        ),
                        SizedBox(height: 10,),
                        Text('Valid on orders with items worth ${snap.data[index]['minValue']}',style: GoogleFonts.poppins(),),
                        SizedBox(height: 10,),
                        Text(snap.data[index]['offerDiscription']),
                        widget.fromcartpage==null?Container(): OutlinedButton(onPressed: ()async{
                         await coupon.applyCoupon(snap.data[index]['couponCode'], widget.toke);
                         if(coupon.applied!=null){
                             showDialog(
          context: context,
          builder: (con) {
            return CustomDialogBox(
              title: "${coupon.applied['message']}",
              descriptions:
                  "Total savings: ₹${double.parse(coupon.applied['totalDiscount']).toStringAsFixed(1)}",
             // text: "Login",
             // img: '${Jwt.parseJwt(userDetails)['imgurl']}',
            );
          });
                       
                           snackBar('${coupon.applied}', context);

                         }
                          snackBar('${coupon.problem}', context);
                        },child: Text('APPLY'),),
            
                        
                      ],
                    ),
                  );
                }
              ),
            );
          }
        ),
      )
    ],),
    );

  }
}
class CustomDialogBox extends StatefulWidget {
  var title, descriptions, text;
  var img;
  var function;

  CustomDialogBox({this.title, this.descriptions, this.text, this.img,this.function});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions,
                style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 22,
              ),
              widget.text!=null?
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  color: Colors.green,
                  child:widget.text?FlatButton(
                      onPressed:widget.function,
                      child: Text(
                        widget.text,
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.white),
                      )):Container(),
                ),
              ):
              Container()
            ],
          ),
        ),
        // Positioned(
        //   left: Constants.padding,
        //   right: Constants.padding,
        //   child: CircleAvatar(
        //       backgroundColor: Colors.transparent,
        //       radius: Constants.avatarRadius,
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.all(Radius.circular(50)),
        //         child: Image.network(widget.img??'https://image.shutterstock.com/image-vector/caution-exclamation-mark-white-red-260nw-1055269061.jpg'),
        //       )),
        // ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 20;
  static const double avatarRadius = 45;
}