import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/cartbacknd.dart';
import 'package:foodorder_userapp/Backend/couponBackend.dart';
import 'package:foodorder_userapp/Backend/getallRestaurents.dart';
import 'package:foodorder_userapp/Backend/orderBackend.dart';
import 'package:foodorder_userapp/Backend/paymentrzrpay.dart';
import 'package:foodorder_userapp/Design&Ui/Cartpage/cartemptyorNull.dart';
import 'package:foodorder_userapp/Design&Ui/addedcartSnackbar.dart';
import 'package:foodorder_userapp/LocationService/Location.dart';
import 'package:foodorder_userapp/Screens/Couponpage.dart';
import 'package:foodorder_userapp/Screens/OrderConfermationspalsh.dart';
import 'package:foodorder_userapp/Screens/firstpage.dart';
import 'package:foodorder_userapp/Screens/onOrderplacemap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  LatLng latlng;
  // var addrs, sublocality;

  CartPage({required this.latlng});
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  var restronam, orderItm, user;
  var tOken;
  var userId;
  var finitemcount;
  var destloc;
  var postedOrder;
  var desc, contact, email;
  var paymentId, delBoycharge;
  Razorpay _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    var postOrder = Provider.of<OrderBackend>(context, listen: false);
    await postOrder
        .postOrder(tOken, restronam, orderItm, user, true,
            widget.latlng.latitude, widget.latlng.longitude, paymentId, sum,delBoycharge)
        .then((value) => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (con) {
              return ChangeNotifierProvider(
                  create: (BuildContext context) {
                    return AllRestaurent();
                  },
                  child: OrderConfirmd(
                    sourceloc: widget.latlng,
                    destloc: destloc,
                    orderDetails: value,
                  ));
            })));

    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  startPayment(
    orderid,
  ) async {
    print('ok $orderid');
    //var startpaymnt=Provider.of<Paymentrzrpay>(context,listen: false);
    var options = {
      'key': 'rzp_test_bSgdTgaBOb05KI',
      'amount': sum * 100,
      'order_id': orderid,
      'name': 'Mealtime',
      'description': '$desc',
      'prefill': {'contact': '$contact', 'email': '$email'}
    };
    try {
      if (orderid == null) {
        return snackBar('ordrid null', context);
      }
      _razorpay.open(options);
    } on Exception catch (e) {
      snackBar(e.toString(), context);
    }
  }

  Future getToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('Account Details');
    setState(() {
      tOken = token;
    });
  }

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
    getToken();
  }

  List studList = [];
  int sum = 0;
  var counter;
  var cartlen;

  @override
  Widget build(BuildContext context) {
    // getToken();
    //getUserid();
    var cart = Provider.of<Cart>(context, listen: false);
    var createPayment = Provider.of<Paymentrzrpay>(context, listen: false);
    var postOrder = Provider.of<OrderBackend>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      body: Builder(
        builder: (context) {
          return tOken != null
              ? ListView(
                  children: <Widget>[
                    //createHeader(),
                    createSubTitleandCartlist(
                        cart.getCart(
                          tOken,
                        ), () async {
                      await createPayment.createPayment(sum * 100);
                      setState(() {
                        paymentId = createPayment.msg;
                      });
                      startPayment(createPayment.msg);
                    }, () async {
                      await postOrder
                          .postOrder(
                              tOken,
                              restronam,
                              orderItm,
                              user,
                              false,
                              widget.latlng.latitude,
                              widget.latlng.longitude,
                              null,
                              sum,
                              delBoycharge)
                          .then((value) {
                        print(value);
                        try {
                          return Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (con) {
                            return ChangeNotifierProvider(
                                create: (BuildContext context) {
                                  return AllRestaurent();
                                },
                                child: OrderConfirmd(
                                  sourceloc: widget.latlng,
                                  destloc: destloc,
                                  orderDetails: value,
                                ));
                          }));
                        } catch (e) {
                          print('$e +shit');
                        }
                      });
                    }),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset('images/taco.png'),
                    ),
                    Text(
                      'Login to view your cart items',
                      style: GoogleFonts.poppins(fontSize: 20),
                    ),
                    MaterialButton(
                      color: Colors.green,
                      onPressed: () {},
                      child: Text('Login'),
                    )
                  ],
                );
        },
      ),
    );
  }

  // createHeader() {
  //   return Container(
  //     alignment: Alignment.topLeft,
  //     child: Text(
  //       "SHOPPING CART",
  //       style: GoogleFonts.poppins(),
  //     ),
  //     margin: EdgeInsets.only(left: 12, top: 12),
  //   );
  // }

  createSubTitleandCartlist(getcart, checkoutonpress, cod) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 2), () => getcart),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset('images/CartpageAnim.json'),
                ),
                Text(
                  'Loading...',
                  style: GoogleFonts.poppins(),
                )
              ],
            );
          }
          if (snapshot.data == null) {
            return CartemptyOrnull(() {
              Navigator.push(context, MaterialPageRoute(builder: (con) {
                return ChangeNotifierProvider(
                    create: (BuildContext context) {
                      return AllRestaurent();
                    },
                    child: FirstPage(
                        lat: widget.latlng.latitude,
                        lon: widget.latlng.longitude));
              }));
            });
          } else {
            print(snapshot.data);
            var cart = Provider.of<Cart>(context, listen: false);
            var location = Provider.of<Location>(context, listen: false);

            // Map<String, dynamic> payload = Jwt.parseJwt(tOken);
            // print('$tOken mfs');

            return Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Total(${snapshot.data['products'].length}) Items",
                    style: GoogleFonts.poppins(),
                  ),
                  margin: EdgeInsets.only(left: 12, top: 4),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemBuilder: (context, position) {
                    finitemcount =
                        snapshot.data['products'][position]['quantity'];
                    return createCartListItem(
                      snapshot.data['products'][position]['item']['itemName'],
                      snapshot.data['products'][position]['price'],
                      snapshot.data['products'][position]['item']['itmImg'],
                      () async {
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        var token =
                            sharedPreferences.getString('Account Details');
                        Map<String, dynamic> payloads = Jwt.parseJwt(token!);

                        await cart.addToCart(
                            id: payloads['id'],
                            item: snapshot.data['products'][position]['item'],
                            quantity: snapshot.data['products'][position]
                                ['quantity'],
                            price: snapshot.data['products'][position]['item']
                                ['price'],
                            token: token,
                            restroId: snapshot.data['products'][position]
                                ['item']['restroId'],
                            itmid: snapshot.data['products'][position]['item']
                                ['_id'],
                            lat: snapshot.data['cord']['lat'],
                            lon: snapshot.data['cord']['lon']);
                        if (cart.sucessFullyaded != null) {
                          setState(() {
                            finitemcount =
                                snapshot.data['products'][position]['quantity'];
                          });
                          snackBar('${cart.sucessFullyaded}', context);
                        } else {
                          snackBar('${cart.notAdded}', context);
                        }
                      },
                      finitemcount,
                      () async {
                        //print(token);
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        var token =
                            sharedPreferences.getString('Account Details');
                        Map<String, dynamic> payloads = Jwt.parseJwt(token!);
                        print(token);
                        await cart.removequentity(
                            snapshot.data['products'][position]['item']['_id'],
                            snapshot.data['products'][position]['item']
                                ['price'],
                            token,
                            snapshot.data['products'][position]['item']
                                ['restroId'],
                            payloads['id'],
                            snapshot.data['products'][position]['item'],
                            snapshot.data['products'][position]['quantity'],
                            snapshot.data['products'][position]['_id']);
                        if (cart.sucessFullyaded != null) {
                          setState(() {
                            finitemcount =
                                snapshot.data['products'][position]['quantity'];
                          });
                          snackBar('${cart.sucessFullyaded}', context);
                        } else {
                          snackBar('${cart.notAdded}', context);
                        }
                      },
                    );
                  },
                  itemCount: snapshot.data['products'].length,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ChangeNotifierProvider(
                                  create: (BuildContext context) {
                                    return CouponBackend();
                                  },
                                  child: CouponPage(
                                    fromcartpage: 'xyz',
                                    toke: tOken,
                                  ));
                            }));
                          },
                          child: Container(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    //mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                          height: 40,
                                          width: 30,
                                          child: Image.asset(
                                              'images/discount.png')),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'APPLY COUPON',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                    ],
                                  ),
                                  snapshot.data['couPonapplied'] == true
                                      ? Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.checkCircle,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                            Text(
                                              ' Applied',
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ],
                                        )
                                      : Container()
                                ],
                              ),
                              height: MediaQuery.of(context).size.height / 12,
                              width: MediaQuery.of(context).size.width),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height /
                                3, //*MediaQuery.of(context).devicePixelRatio,
                            width: MediaQuery.of(context).size.width,

                            //margin: EdgeInsets.only(left: 30),
                            child: FutureBuilder(
                                future: getcart,
                                builder: (context, AsyncSnapshot snap) {
                                  if (snap.data == null) {
                                    return CircularProgressIndicator();
                                  }
                                  return Column(
                                    children: [
                                      AutoSizeText(
                                        "Bill Details",
                                        style: GoogleFonts.poppins(),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText('Item Total:',
                                              style: GoogleFonts.poppins()),
                                          AutoSizeText(
                                              '₹${'${snapshot.data['total']}'}')
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText('Delivery Charge:',
                                              style: GoogleFonts.poppins()),
                                          //Geolocator.distanceBetween(snap.data['cord']['lat'], snap.data['cord']['lon'], widget.latlng.latitude, widget.latlng.longitude) / 1000 * 7==null?
                                          AutoSizeText(
                                              '₹${(Geolocator.distanceBetween(snap.data['cord']['lat'], snap.data['cord']['lon'], widget.latlng.latitude, widget.latlng.longitude) / 1000 * 7).toStringAsFixed(1)}')
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText('Restraunt GST:',
                                              style: GoogleFonts.poppins()),
                                          AutoSizeText(
                                              '₹${(snapshot.data['total'] * 0.05).toStringAsFixed(1)}')
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText('Restraunt Packing:',
                                              style: GoogleFonts.poppins()),
                                          AutoSizeText(
                                              '₹${snapshot.data['products'].length * 10}')
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AutoSizeText('Discount:',
                                              style: GoogleFonts.poppins()),
                                          AutoSizeText(
                                              '₹${snapshot.data['discountValue'].toStringAsFixed(1)}')
                                        ],
                                      ),
                                      Expanded(
                                          child: Divider(
                                        thickness: 1.0,
                                      )),
                                      //SizedBox(height: 5,),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          AutoSizeText(
                                            'To Pay',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w700),
                                          ),
                                          AutoSizeText('₹' +
                                              (snapshot.data['total'] +
                                                      (Geolocator.distanceBetween(
                                                              snap.data['cord']
                                                                  ['lat'],
                                                              snap.data['cord']
                                                                  ['lon'],
                                                              widget.latlng
                                                                  .latitude,
                                                              widget.latlng
                                                                  .longitude) /
                                                          1000 *
                                                          7) +
                                                      (snapshot.data['total'] *
                                                          0.05) +
                                                      (snapshot.data['products']
                                                              .length *
                                                          10) -
                                                      snapshot.data[
                                                          'discountValue'])
                                                  .round()
                                                  .toString())
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              padding: EdgeInsets.all(5),
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height / 6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                      alignment: Alignment.topLeft,
                                      child: AutoSizeText(
                                          'Order will deliver here..')),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.mapMarkerAlt,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      FutureBuilder(
                                          future: location.getAddress(
                                              widget.latlng.latitude,
                                              widget.latlng.longitude),
                                          builder: (con, AsyncSnapshot snap) {
                                            if (snap.data == null) {
                                              return Text('Locating..');
                                            }
                                            return Container(
                                              height: 60,
                                              width: 220,
                                              child: AutoSizeText(
                                                '${snap.data["results"][0]["formatted_address"]}',
                                                style: GoogleFonts.poppins(),
                                              ),
                                            );
                                          })
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: EdgeInsets.all(5),
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height /
                                4, //*MediaQuery.of(context).devicePixelRatio,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  'Cancellation Policy',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700),
                                ),
                                AutoSizeText(
                                    '100% cancellation fee will be applicable if you decide to cancel the order anytime after order placement',
                                    maxLines: 3,
                                    style: GoogleFonts.poppins()),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        'Avoid cancellation as it leads to food wastage',
                                        style: GoogleFonts.poppins(
                                            color:
                                                Colors.black.withOpacity(0.5))))
                              ],
                            ),
                          ),
                          FutureBuilder(
                              future: getcart,
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.hasData) {
                                  // sum = snapshot.data['products'].fold(
                                  //     0, (prev, next) => prev + next['price']);

                                  return Column(
                                    children: [
                                      // Text(
                                      //   '${snapshot.data['total']}',
                                      //   style: GoogleFonts.poppins(),
                                      // ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 4.0, right: 4.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RaisedButton(
                                              onPressed: () {
                                                print(snapshot.data['total'] +
                                                    (Geolocator.distanceBetween(
                                                            snapshot.data['cord']
                                                                ['lat'],
                                                            snapshot.data[
                                                                'cord']['lon'],
                                                            widget.latlng
                                                                .latitude,
                                                            widget.latlng
                                                                .longitude) /
                                                        1000 *
                                                        7) +
                                                    (snapshot
                                                            .data['total'] *
                                                        0.05) +
                                                    (snapshot.data['products']
                                                            .length *
                                                        10) -
                                                    snapshot
                                                        .data['discountValue']
                                                        .round());
                                                setState(() {
                                                  delBoycharge = (Geolocator
                                                              .distanceBetween(
                                                                  snapshot.data[
                                                                          'cord']
                                                                      ['lat'],
                                                                  snapshot.data[
                                                                          'cord']
                                                                      ['lon'],
                                                                  widget.latlng
                                                                      .latitude,
                                                                  widget.latlng
                                                                      .longitude) /
                                                          1000 *
                                                          7)
                                                      .round();
                                                  sum = (snapshot.data['total'] +
                                                          (Geolocator.distanceBetween(
                                                                  snapshot.data[
                                                                          'cord']
                                                                      ['lat'],
                                                                  snapshot.data[
                                                                          'cord']
                                                                      ['lon'],
                                                                  widget.latlng
                                                                      .latitude,
                                                                  widget.latlng
                                                                      .longitude) /
                                                              1000 *
                                                              7) +
                                                          (snapshot.data['total'] *
                                                              0.05) +
                                                          (snapshot
                                                                  .data[
                                                                      'products']
                                                                  .length *
                                                              10) -
                                                          snapshot.data[
                                                              'discountValue'])
                                                      .round();
                                                  destloc = LatLng(
                                                      snapshot.data['cord']
                                                          ['lat'],
                                                      snapshot.data['cord']
                                                          ['lon']);
                                                  ////destloc.latitude=snapshot.data['cord']['lat'];
                                                  restronam =
                                                      snapshot.data['restroId'];
                                                  orderItm =
                                                      snapshot.data['products'];
                                                  user =
                                                      snapshot.data['userId'];
                                                  contact =
                                                      snapshot.data['userId']
                                                          ['phoneNumber'];
                                                  email = snapshot
                                                      .data['userId']['email'];
                                                  desc = snapshot
                                                          .data['products'][0]
                                                      ['item']['itemName'];
                                                });
                                                print(sum);

                                                checkoutonpress();
                                              },
                                              color: Colors.green,
                                              padding: EdgeInsets.only(
                                                  top: 12,
                                                  left: 30,
                                                  right: 30,
                                                  bottom: 12),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(24))),
                                              child: Text(
                                                "PAY ONLINE",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            RaisedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  delBoycharge = (Geolocator
                                                              .distanceBetween(
                                                                  snapshot.data[
                                                                          'cord']
                                                                      ['lat'],
                                                                  snapshot.data[
                                                                          'cord']
                                                                      ['lon'],
                                                                  widget.latlng
                                                                      .latitude,
                                                                  widget.latlng
                                                                      .longitude) /
                                                          1000 *
                                                          7)
                                                      .round();

                                                  sum = (snapshot.data['total'] +
                                                          (Geolocator.distanceBetween(
                                                                  snapshot.data[
                                                                          'cord']
                                                                      ['lat'],
                                                                  snapshot.data[
                                                                          'cord']
                                                                      ['lon'],
                                                                  widget.latlng
                                                                      .latitude,
                                                                  widget.latlng
                                                                      .longitude) /
                                                              1000 *
                                                              7) +
                                                          (snapshot.data['total'] *
                                                              0.05) +
                                                          (snapshot
                                                                  .data[
                                                                      'products']
                                                                  .length *
                                                              10) -
                                                          snapshot.data[
                                                              'discountValue'])
                                                      .round();
                                                  destloc = LatLng(
                                                      snapshot.data['cord']
                                                          ['lat'],
                                                      snapshot.data['cord']
                                                          ['lon']);
                                                  ////destloc.latitude=snapshot.data['cord']['lat'];
                                                  restronam =
                                                      snapshot.data['restroId'];
                                                  orderItm =
                                                      snapshot.data['products'];
                                                  user =
                                                      snapshot.data['userId'];
                                                  contact =
                                                      snapshot.data['userId']
                                                          ['phoneNumber'];
                                                  email = snapshot
                                                      .data['userId']['email'];
                                                  desc = snapshot
                                                          .data['products'][0]
                                                      ['item']['itemName'];
                                                });

                                                cod();
                                              },
                                              color: Colors.green,
                                              padding: EdgeInsets.only(
                                                  top: 12,
                                                  left: 32,
                                                  right: 32,
                                                  bottom: 12),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(24))),
                                              child: Text(
                                                "PAY COD",
                                                style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              }),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                  margin: EdgeInsets.only(top: 16),
                )
              ],
            );
          }
        });
  }

  createCartListItem(name, price, img, addtocart, itemcount, removeCart) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: Colors.blue.shade200,
                    image: DecorationImage(image: NetworkImage("$img"))),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 8, top: 4),
                        child: Text(
                          name,
                          maxLines: 2,
                          softWrap: true,
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Green M",
                        style: GoogleFonts.poppins(),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "₹ $price",
                              style: GoogleFonts.poppins(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: removeCart,
                                    child: Icon(
                                      Icons.remove,
                                      size: 24,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Container(
                                    color: Colors.grey.shade200,
                                    padding: const EdgeInsets.only(
                                        bottom: 2, right: 12, left: 12),
                                    child: Text(
                                      "$finitemcount",
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: addtocart,
                                    child: Icon(
                                      Icons.add,
                                      size: 24,
                                      color: Colors.grey.shade700,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                flex: 100,
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 10, top: 8),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Colors.green),
          ),
        )
      ],
    );
  }
}
