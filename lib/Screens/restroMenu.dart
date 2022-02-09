import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/cartbacknd.dart';
import 'package:foodorder_userapp/Design&Ui/Cartpage/addedcartSnackbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestroMenu extends StatefulWidget {
  var restroDetails;
  RestroMenu({this.restroDetails});

  @override
  _RestroMenuState createState() => _RestroMenuState();
}

class _RestroMenuState extends State<RestroMenu> {
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("${widget.restroDetails['name']}",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                        fontSize: 21, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(image: NetworkImage('${widget.restroDetails['imgurl']}'),fit:BoxFit.fill,
                colorFilter:new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop))),
              height: MediaQuery.of(context).size.height/4.8,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      width: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.restroDetails['cusineType'].length,
                        itemBuilder: (BuildContext context, int indx) {
                          return AutoSizeText(
                              '${widget.restroDetails['cusineType'][indx]['cusineType']} ,',
                              style: GoogleFonts.poppins(
                                  fontSize: 19, fontWeight: FontWeight.bold,color: Colors.white));
                        },
                      ),
                    ),
                  ),
                       Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    child: AutoSizeText('${widget.restroDetails['address']['city']}',
                        style: GoogleFonts.poppins(
                            fontSize: 19, fontWeight: FontWeight.w600,color: Colors.white)),
                  )),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text('${widget.restroDetails['address']['zipcode']}',
                      style: GoogleFonts.poppins(
                         fontSize: 19, fontWeight: FontWeight.w600,color: Colors.white))),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(8)),
                  height: 30,
                  width: 80,
                  //color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(2, 5, 5, 5),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.stopwatch,
                          size: 20,
                          color: Colors.orange,
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: AutoSizeText(
                              '${widget.restroDetails['preaprationTime']}',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
                ],
              ),
            ),
       
            SizedBox(
              height: 5,
            ),
            Divider(
              height: 25,
              color: Colors.grey[300],
            ),
            Expanded( 
              child: SingleChildScrollView(
                  child: ListView.builder(
                      itemCount: widget.restroDetails['cusineType'].length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Card(
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                  children: [
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: widget
                                            .restroDetails['cusineType'][index]
                                                ['restro'][0]['items']
                                            .length,
                                        itemBuilder: (context, indx) {
                                          // print(
                                          //     'this is   ${widget.restroDetails['cusineType'][index]['restro']}');
                                          // Text(
                                          //       "snap.data[index]['restro'][0]['items'][indx]['itemName']")
                                          return Container(
                                            height: 155,
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.black
                                                          .withAlpha(100),
                                                      blurRadius: 10.0),
                                                ]),
                                            child: Column(
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      //mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Container(
                                                              height: 18,
                                                              width: 18,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]
                                                                            [
                                                                            'isveg']
                                                                        ? 'images/veg.png'
                                                                        : 'images/non-veg.png')),
                                                              )),
                                                        ),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    8, 4, 8, 4),
                                                            child: Text(
                                                              widget.restroDetails['cusineType']
                                                                              [
                                                                              index]
                                                                          [
                                                                          'restro']
                                                                      [
                                                                      0]['items']
                                                                  [
                                                                  indx]['itemName'],
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Text('₹',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .green)),
                                                              Text(
                                                                widget
                                                                    .restroDetails[
                                                                        'cusineType']
                                                                        [index][
                                                                        'restro']
                                                                        [0][
                                                                        'items']
                                                                        [indx][
                                                                        'price']
                                                                    .toString(),
                                                                style: GoogleFonts
                                                                    .poppins(
                                                                        fontSize:
                                                                            16),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                          
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      // child: Align(
                                                      //   alignment: Alignment.topRight,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: 90,
                                                            width: 90,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                              child:
                                                                  FadeInImage(
                                                                imageErrorBuilder:
                                                                    (con, obj,
                                                                        stack) {
                                                                  return Container(
                                                                    height: 120,
                                                                    width: 100,
                                                                    child: Image.asset(
                                                                        'images/FoodVector.jpg',
                                                                        height: double
                                                                            .infinity,
                                                                        fit: BoxFit
                                                                            .cover),
                                                                  );
                                                                },
                                                                fit: BoxFit
                                                                    .cover,
                                                                image: NetworkImage(
                                                                    "${widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]['itmImg']}"),
                                                                placeholder:
                                                                    AssetImage(
                                                                        'images/FoodVector.jpg'),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                              width: 90,
                                                              child: widget.restroDetails['cusineType'][index]['restro'][0]
                                                                              ['items']
                                                                          [indx]
                                                                      [
                                                                      'inStock']
                                                                  ? MaterialButton(
                                                                      color: Colors
                                                                          .green,
                                                                      onPressed:
                                                                          () async {
                                                                        final SharedPreferences
                                                                            sp =
                                                                            await SharedPreferences.getInstance();
                                                                        var userId =
                                                                            sp.getString('Account Details');
                                                                        if (userId ==
                                                                            null) {
                                                                          return snackBar(
                                                                              'Please login to add this to cart',
                                                                              context);
                                                                        }
                                                                        Map<String,
                                                                                dynamic>
                                                                            payload =
                                                                            Jwt.parseJwt(userId);
                                                                            print(widget.restroDetails['cord']['lon']);
                                                                        await cart.addToCart(
                                                                            id:payload['id'],
                                                                            item:widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx],
                                                                            quantity:1,
                                                                            price:widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]['price'],
                                                                            token:userId,
                                                                            restroId:widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]['restroId'],
                                                                           itmid: widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]['_id'],
                                                                            lat:widget.restroDetails['cord']['lat'],
                                                                            lon:widget.restroDetails['cord']['lon']);
                                                                        // cart.sucessFullyaded !=
                                                                        //         null
                                                                        //     ? 
                                                                           cart.sucessFullyaded !=
                                                                  null
                                                              ? snackBar(
                                                                  '${cart.sucessFullyaded}',
                                                                  context)
                                                              : Alert(
                                                                  context:
                                                                      context,
                                                                  type: AlertType
                                                                      .warning,
                                                                  title: "Cart",
                                                                  desc:
                                                                      "Your cart contains item from another restraunt",
                                                                  buttons: [
                                                                    DialogButton(
                                                                      child:
                                                                          Text(
                                                                        "Replace",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 20),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        await cart
                                                                            .deletCart(userId);
                                                                        await cart.addToCart(
                                                                            id:payload['id'],
                                                                            item:widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx],
                                                                            quantity:1,
                                                                            price:widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]['price'],
                                                                            token:userId,
                                                                            restroId:widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]['restroId'],
                                                                           itmid: widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]['_id'],
                                                                            lat:widget.restroDetails['cord']['lat'],
                                                                            lon:widget.restroDetails['cord']['lon']);
                                                                        snackBar(
                                                                            '${cart.sucessFullyaded}',
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      color: Color.fromRGBO(
                                                                          0,
                                                                          179,
                                                                          134,
                                                                          1.0),
                                                                    ),
                                                                    DialogButton(
                                                                      child:
                                                                          Text(
                                                                        "Cancel",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 20),
                                                                      ),
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.pop(context),
                                                                      gradient:
                                                                          LinearGradient(
                                                                              colors: [
                                                                            Color.fromRGBO(
                                                                                116,
                                                                                116,
                                                                                191,
                                                                                1.0),
                                                                            Color.fromRGBO(
                                                                                52,
                                                                                138,
                                                                                199,
                                                                                1.0)
                                                                          ]),
                                                                    )
                                                                  ],
                                                                ).show();
                                                        
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'ADD',
                                                                        style: GoogleFonts.poppins(
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w700),
                                                                      ))
                                                                  : Text(
                                                                      'Currently not in stock',
                                                                      style: GoogleFonts.poppins(
                                                                          color:
                                                                              Colors.red),
                                                                    ))
                                                        ],
                                                      ),
                                                    ),
                                                    //)
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        })
                                  ],
                                  title: Text(
                                      '${widget.restroDetails['cusineType'][index]['cusineType']}(${widget.restroDetails['cusineType'][index]['restro'][0]['items'].length})',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.red.withOpacity(.7),
                                      ))),
                            ),
                            SizedBox(height: 10)
                          ],
                        );
                      })),
            )
          ],
        ),
      ),
    );
  }
}
