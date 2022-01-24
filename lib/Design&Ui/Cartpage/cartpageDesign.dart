// import 'package:flutter/material.dart';

// class CartpageDesign extends StatefulWidget {
//   const CartpageDesign({ Key? key }) : super(key: key);

//   @override
//   _CartpageDesignState createState() => _CartpageDesignState();
// }

// class _CartpageDesignState extends State<CartpageDesign> {
//   @override
//   Widget build(BuildContext context) {
//    // return  createSubTitleandCartlist(getcart, checkoutonpress, staRtpayment) {
//     return FutureBuilder(
//         future: getcart,
//         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           if (snapshot.data == null) {
//             return Center(child: CircularProgressIndicator());
//           } else {
//             print(snapshot.data);
//             var cart = Provider.of<Cart>(context, listen: false);

//             Map<String, dynamic> payload = Jwt.parseJwt(tOken);
//             print('$tOken mfs');

//             return Column(
//               children: [
//                 Container(
//                   alignment: Alignment.topLeft,
//                   child: Text(
//                     "Total(${snapshot.data['products'].length}) Items",
//                     style: GoogleFonts.poppins(),
//                   ),
//                   margin: EdgeInsets.only(left: 12, top: 4),
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   primary: false,
//                   itemBuilder: (context, position) {
//                     finitemcount =
//                         snapshot.data['products'][position]['quantity'];
//                     return createCartListItem(
//                       snapshot.data['products'][position]['item']['itemName'],
//                       snapshot.data['products'][position]['price'],
//                       snapshot.data['products'][position]['item']['itmImg'],
//                       () async {
//                         final SharedPreferences sharedPreferences =
//                             await SharedPreferences.getInstance();
//                         var token =
//                             sharedPreferences.getString('Account Details');
//                         Map<String, dynamic> payloads = Jwt.parseJwt(token!);

//                         await cart.addToCart(
//                             payloads['id'],
//                             snapshot.data['products'][position]['item'],
//                             snapshot.data['products'][position]['quantity'],
//                             snapshot.data['products'][position]['item']
//                                 ['price'],
//                             token,
//                             snapshot.data['products'][position]['item']
//                                 ['restroId'],
//                             snapshot.data['products'][position]['item']['_id']);
//                         if (cart.sucessFullyaded != null) {
//                           setState(() {
//                             finitemcount =
//                                 snapshot.data['products'][position]['quantity'];
//                           });
//                           snackBar('${cart.sucessFullyaded}', context);
//                         } else {
//                           snackBar('${cart.notAdded}', context);
//                         }
//                       },
//                       finitemcount,
//                       () async {
//                         final SharedPreferences sharedPreferences =
//                             await SharedPreferences.getInstance();
//                         var token =
//                             sharedPreferences.getString('Account Details');
//                         Map<String, dynamic> payloads = Jwt.parseJwt(token!);
//                         await cart.removequentity(
//                             snapshot.data['products'][position]['item']['_id'],
//                             snapshot.data['products'][position]['item']
//                                 ['price'],
//                             token,
//                             snapshot.data['products'][position]['item']
//                                 ['restroId'],
//                             payloads['id'],
//                             snapshot.data['products'][position]['item'],
//                             snapshot.data['products'][position]['quantity'],
//                             snapshot.data['products'][position]['_id']);
//                         if (cart.sucessFullyaded != null) {
//                           setState(() {
//                             finitemcount =
//                                 snapshot.data['products'][position]['quantity'];
//                           });
//                           snackBar('${cart.sucessFullyaded}', context);
//                         } else {
//                           snackBar('${cart.notAdded}', context);
//                         }
//                       },
//                     );
//                   },
//                   itemCount: snapshot.data['products'].length,
//                 ),
//                 Container(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Container(
//                             margin: EdgeInsets.only(left: 30),
//                             child: Text(
//                               "Total",
//                               style: GoogleFonts.poppins(),
//                             ),
//                           ),
//                           FutureBuilder(
//                               future: getcart,
//                               builder: (BuildContext context,
//                                   AsyncSnapshot<dynamic> snapshot) {
//                                 if (snapshot.hasData) {
//                                   int total = 0;
//                                   sum = snapshot.data['products'].fold(
//                                       0, (prev, next) => prev + next['price']);
//                                 }
//                                 return Container(
//                                   margin: EdgeInsets.only(right: 30),
//                                   child: Text(
//                                     '$sum',
//                                     style: GoogleFonts.poppins(),
//                                   ),
//                                 );
//                               }),
//                         ],
//                       ),
//                       SizedBox(height: 8),
//                       RaisedButton(
//                         onPressed: () async {
//                           //     new MaterialPageRoute(builder: (context) => CheckOutPage()));
//                           await checkoutonpress();
//                           staRtpayment();

//                           // Navigator.push(context,
//                           //     new MaterialPageRoute(builder: (context) => CheckOutpage()));
//                         },
//                         color: Colors.green,
//                         padding: EdgeInsets.only(
//                             top: 12, left: 60, right: 60, bottom: 12),
//                         shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(24))),
//                         child: Text(
//                           "Checkout",
//                           style: GoogleFonts.poppins(),
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                     ],
//                   ),
//                   margin: EdgeInsets.only(top: 16),
//                 )
//               ],
//             );
//           }
//         });
//   }
//   }
// }