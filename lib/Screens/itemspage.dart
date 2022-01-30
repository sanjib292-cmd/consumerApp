import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/cartbacknd.dart';
import 'package:foodorder_userapp/Design&Ui/addedcartSnackbar.dart';
import 'package:foodorder_userapp/LocationService/Location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemsPage extends StatefulWidget {
  var product;

  var appBartitle;
  var filter;
  var lat;
  var lon;
  ItemsPage({this.product, this.appBartitle, this.filter, this.lat, this.lon});
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  // / final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;
  int indexofRestro = 0;
  Color cl = Colors.orange.shade400;

  @override
  void initState() {
    super.initState();
    onStart();
  }

  Future items() async {
    var res = await widget.product;
    print(res);
    return res;
  }

  onStart() async {
    var res = Provider.of<Location>(context, listen: false);
    try {
      await res.determinePosition();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var res = Provider.of<Location>(context, listen: false);
    var cart = Provider.of<Cart>(context, listen: false);
    print('${res.adrs} lol');
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '${widget.appBartitle}',
            style: GoogleFonts.poppins(color: Colors.black),
          ),
          elevation: 2,
          backgroundColor: Colors.white,
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer ? 0 : 1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer ? 0 : categoryHeight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: FutureBuilder(
                        future: items(),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.data == null) {
                            return CircularProgressIndicator();
                          }
                          print('not null');

                          return Container(
                            height: MediaQuery.of(context).size.width / 3,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    //print('this fuvking ${snapshot.data[index]}');
                                    setState(() {
                                      indexofRestro = index;
                                      cl = Colors.blue;
                                    });
                                    print(indexofRestro);
                                  },
                                  child: Container(
                                    width: 150,
                                    margin: EdgeInsets.only(right: 20),
                                    height: categoryHeight,
                                    decoration: BoxDecoration(
                                        color: cl,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "${snapshot.data[index]['restroNam']['name']}",
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            (Geolocator.distanceBetween(
                                                            snapshot.data[index]
                                                                    [
                                                                    'restroNam']
                                                                ['cord']['lat'],
                                                            snapshot.data[index]
                                                                    [
                                                                    'restroNam']
                                                                ['cord']['lon'],
                                                            widget.lat,
                                                            widget.lon) /
                                                        1000)
                                                    .toStringAsFixed(2) +
                                                ' KM away..',
                                            style: GoogleFonts.poppins(
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${snapshot.data[index]['items'].length} Items",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: widget.product[indexofRestro]['items'].length,
                      itemBuilder: (con, ind) {
                        return Container(
                          height: 155,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withAlpha(100),
                                    blurRadius: 10.0),
                              ]),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    //mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Container(
                                            height: 18,
                                            width: 18,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(widget
                                                                      .product[
                                                                  indexofRestro]
                                                              ['items'][ind]
                                                          ["isveg"]
                                                      ? 'images/veg.png'
                                                      : 'images/non-veg.png')),
                                            )),
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 4, 8, 4),
                                          child: Text(
                                            widget.product[indexofRestro]
                                                ['items'][ind]["itemName"],
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Text('₹',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.green)),
                                            Text(
                                              widget.product[indexofRestro]
                                                      ['items'][ind]['price']
                                                  .toString(),
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    // child: Align(
                                    //   alignment: Alignment.topRight,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: FadeInImage(
                                              imageErrorBuilder:
                                                  (con, obj, stack) {
                                                return Container(
                                                  height: 120,
                                                  width: 100,
                                                  child: Image.asset(
                                                      'images/FoodVector.jpg',
                                                      height: double.infinity,
                                                      fit: BoxFit.cover),
                                                );
                                              },
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  "${widget.product[indexofRestro]['items'][ind]['itmImg']}"),
                                              placeholder: AssetImage(
                                                  'images/FoodVector.jpg'),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            width: 90,
                                            child: widget.product[indexofRestro]
                                                    ['items'][ind]["inStock"]
                                                ? MaterialButton(
                                                    color: Colors.green,
                                                    onPressed: () async {
                                                      final SharedPreferences
                                                          sp =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      var userId = sp.getString(
                                                          'Account Details');
                                                      if (userId == null) {
                                                        return snackBar(
                                                            'Please login to add this to cart',
                                                            context);
                                                      }
                                                      Map<String, dynamic>
                                                          payload =
                                                          Jwt.parseJwt(userId);
                                                      // print(widget.restroDetails['cord']['lon']);
                                                      await cart.addToCart(
                                                          id:payload['id'],
                                                          item: widget.product[indexofRestro]
                                                              ['items'][ind],
                                                          quantity: 1,
                                                          price: widget.product[indexofRestro]
                                                                  ['items'][ind]
                                                              ['price'],
                                                          token: userId,
                                                          restroId: widget.product[indexofRestro]
                                                                  ['items'][ind]
                                                              ['restroId'],
                                                          itmid: widget.product[
                                                                  indexofRestro]
                                                              ['items'][ind]['_id'],
                                                          lat: widget.lat,
                                                          lon: widget.lon);
                                                      cart.sucessFullyaded !=
                                                              null
                                                          ? snackBar(
                                                              '${cart.sucessFullyaded}',
                                                              context)
                                                          : snackBar(
                                                              '${cart.notAdded}',
                                                              context);
                                                    },
                                                    child: Text(
                                                      'ADD',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ))
                                                : Text(
                                                    'Currently not in stock',
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.red),
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
                        // Container(
                        //     height: 150,
                        //     margin: const EdgeInsets.symmetric(
                        //         horizontal: 20, vertical: 10),
                        //     decoration: BoxDecoration(
                        //         borderRadius:
                        //             BorderRadius.all(Radius.circular(20.0)),
                        //         color: Colors.white,
                        //         boxShadow: [
                        //           BoxShadow(
                        //               color: Colors.black.withAlpha(100),
                        //               blurRadius: 10.0),
                        //         ]),
                        //     child: Padding(
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 20.0, vertical: 10),
                        //       child: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           Column(
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: <Widget>[
                        //               Padding(
                        //                 padding: const EdgeInsets.only(
                        //                     top: 8.0, left: 8),
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     Text(
                        //                       widget
                        //                                   .product[
                        //                                       indexofRestro]
                        //                                       ['items'][ind]
                        //                                       ["itemName"]
                        //                                   .length >=
                        //                               12
                        //                           ? "${widget.product[indexofRestro]['items'][ind]["itemName"]}"
                        //                                   .substring(0, 12) +
                        //                               '..'
                        //                           : " ${widget.product[indexofRestro]['items'][ind]["itemName"]}",
                        //                       overflow: TextOverflow.ellipsis,
                        //                       style: GoogleFonts.poppins(
                        //                           fontSize: 18,
                        //                           fontWeight: FontWeight.bold),
                        //                     ),
                        //                     Container(
                        //                         height: 18,
                        //                         width: 18,
                        //                         decoration: BoxDecoration(
                        //                           image: DecorationImage(
                        //                               image: AssetImage(widget
                        //                                               .product[
                        //                                           indexofRestro]
                        //                                       [
                        //                                       'items'][ind]["isveg"]
                        //                                   ? 'images/veg.png'
                        //                                   : 'images/non-veg.png')),
                        //                         ))
                        //                   ],
                        //                 ),
                        //               ),
                        //               // Text(
                        //               //   post["brand"],
                        //               //   style: const TextStyle(fontSize: 17, color: Colors.grey),
                        //               // ),
                        //               SizedBox(
                        //                 height: 10,
                        //               ),
                        //               Padding(
                        //                 padding:
                        //                     const EdgeInsets.only(left: 8.0),
                        //                 child: Text(
                        //                   "₹ ${widget.product[indexofRestro]['items'][ind]["price"]}",
                        //                   style: GoogleFonts.poppins(
                        //                       fontSize: 18,
                        //                       color: Colors.black,
                        //                       fontWeight: FontWeight.bold),
                        //                 ),
                        //               ),
                        //               widget.product[indexofRestro]['items']
                        //                       [ind]["inStock"]
                        //                   ? TextButton(
                        //                       onPressed: () async {
                        //                         final SharedPreferences sp =
                        //                             await SharedPreferences
                        //                                 .getInstance();
                        //                         var userId = sp.getString(
                        //                             'Account Details');
                        //                             if(userId==null){
                        //                               return
                        //                               snackBar('Please login to add this to cart', context);
                        //                             }
                        //                             print('lolx $userId');
                        //                         Map<String, dynamic> payload =
                        //                             Jwt.parseJwt(userId);

                        //                         print(widget.product[indexofRestro]
                        //                                 ['items'][ind]['price']);
                        //                         await cart.addToCart(
                        //                             id:payload['id'],
                        //                             item:widget.product[indexofRestro]
                        //                                 ['items'][ind],
                        //                             quantity:1,
                        //                             price:widget.product[indexofRestro]
                        //                                 ['items'][ind]['price'],
                        //                             token:userId,
                        //                             restroId:widget.product[indexofRestro]
                        //                                     ['items'][ind]
                        //                                 ['restroId'],
                        //                            itmid: widget.product[indexofRestro]
                        //                                 ['items'][ind]['_id'],
                        //                                 lat:widget.lat,
                        //                                 lon:widget.lon
                        //                            );
                        //                         cart.sucessFullyaded != null
                        //                             ? snackBar(
                        //                                 '${cart.sucessFullyaded}',context)
                        //                             // print('omg ${cart.sucessFullyaded}')
                        //                             :
                        //                             // print(
                        //                             //     'nomg ${cart.notAdded}');
                        //                             snackBar(
                        //                                 '${cart.notAdded}',context);
                        //                       },
                        //                       child: FaIcon(
                        //                           FontAwesomeIcons.cartPlus))
                        //                   : Text('currenty not Available',
                        //                       style: GoogleFonts.poppins(
                        //                           color: Colors.red))
                        //             ],
                        //           ),
                        //           Container(
                        //                                     height: 100,
                        //                                     width: 80,
                        //                                     decoration: BoxDecoration(
                        //                                         borderRadius:
                        //                                             BorderRadius
                        //                                                 .circular(
                        //                                                     5)),
                        //                                     child: ClipRRect(
                        //                                       borderRadius:
                        //                                           BorderRadius
                        //                                               .circular(
                        //                                                   10),
                        //                                       child:
                        //                                           FadeInImage(
                        //                                         imageErrorBuilder:
                        //                                             (con, obj,
                        //                                                 stack) {
                        //                                           return Container(
                        //                                             height: 120,
                        //                                             width: 100,
                        //                                             child: Image.asset(
                        //                                                 'images/FoodVector.jpg',
                        //                                                 height: double
                        //                                                     .infinity,
                        //                                                 fit: BoxFit
                        //                                                     .cover),
                        //                                           );
                        //                                         },
                        //                                         fit: BoxFit
                        //                                             .cover,
                        //                                         image: NetworkImage(
                        //                                             "${widget.product[indexofRestro]['items'][ind]['itmImg']}"),
                        //                                         placeholder:
                        //                                             AssetImage(
                        //                                                 'images/FoodVector.jpg'),
                        //                                       ),
                        //                                     ),
                        //                                   ),

                        //       ],
                        // // "${widget.product[indexofRestro]['items'][ind]['itmImg']}",
                        //     ),
                        //   ));
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
