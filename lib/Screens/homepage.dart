import 'dart:async';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/LoginRegisterapi.dart';
import 'package:foodorder_userapp/Backend/cartbacknd.dart';
import 'package:foodorder_userapp/Backend/couponBackend.dart';
import 'package:foodorder_userapp/Backend/getallRestaurents.dart';
import 'package:foodorder_userapp/Backend/orderBackend.dart';
import 'package:foodorder_userapp/Backend/paymentrzrpay.dart';
import 'package:foodorder_userapp/Design&Ui/Cartpage/addedcartSnackbar.dart';
import 'package:foodorder_userapp/LocationService/Location.dart';
import 'package:foodorder_userapp/Screens/Couponpage.dart';
import 'package:foodorder_userapp/Screens/cartpage.dart';
import 'package:foodorder_userapp/Screens/firstpage.dart';
import 'package:foodorder_userapp/Screens/LoginorRegister.dart';
import 'package:badges/badges.dart';
import 'package:foodorder_userapp/Screens/serchpage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'AccountPage.dart';

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  var address;
  var sublocallity;
  var lat, lon;
  MyHomePage({this.address, this.sublocallity, this.lat, this.lon});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  checkInernetonnection()async{
  //final bool isConnected = await InternetConnectionChecker().hasConnection;
  final StreamSubscription<InternetConnectionStatus> listener =
      InternetConnectionChecker().onStatusChange.listen(
    (InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          break;
        case InternetConnectionStatus.disconnected:
          return snackBar('Internet not connected', context);

      }
    },
  );

  // close listener after 30 seconds, so the program doesn't run forever
  await Future<void>.delayed(const Duration(seconds: 30));
  await listener.cancel();
  }
  bool isUser = false;
  var token;
  var obtainedIsuser;
  int currentIndex = 0;

  Future getifUser() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var data = sharedPreferences.getBool('isUser');
    if(data==null){
       sharedPreferences.setBool('isUser', false);
    }
    return data;
    // yield* Stream.periodic(Duration(seconds: 1), (_) {
    //   if (data == null) {
    //     sharedPreferences.setBool('isUser', false);
    //   }
    //   //print('$data is lick');
    //   return data;
    //   //return cart.getCart(sharedPreferences.getString('Account Details'));
    // });
  }

  Future getToken() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    // setState(() {
    token = sp.getString('Account Details');
    //});
  }

  // checkIftokenExp() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   print(JwtDecoder.getExpirationDate(
  //       sharedPreferences.getString('Account Details').toString()));
  //   if (JwtDecoder.isExpired(
  //       sharedPreferences.getString('Account Details').toString())) {
  //     print('exp');
  //     //final pref = await SharedPreferences.getInstance();
  //     await sharedPreferences.remove('Account Details');
  //     await sharedPreferences.setBool('isUser', false);
  //     snackBar('You are logedout', context);
  //   }
  // }

  @override
  void initState() {
    getToken();
    // getIfuserLogedin();
    //checkIftokenExp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkInernetonnection();
    var loc= Provider.of<Location>(context,listen: false);
    getToken();
    //checkIftokenExp();
   
    var cart = Provider.of<Cart>(context, listen: false);
    Future getcartNumber() async {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      // yield* Stream.periodic(Duration(seconds: 2), (_) {
        return cart.getCart(sharedPreferences.getString('Account Details'));
     // }).asyncMap((event) async => await event);
    }
   // getcartNumber();

    final List<Widget> _children = [
      ChangeNotifierProvider(
          create: (BuildContext context) {
            return AllRestaurent();
          },
          child: FirstPage(
            lat: widget.lat,
            lon: widget.lon,
          )),
      ChangeNotifierProvider(create: (BuildContext context) { return AllRestaurent(); },
      child: Serchpage()),
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (BuildContext context) { return AllRestaurent(); },),
            ChangeNotifierProvider(create: (BuildContext context) => Cart()),
            ChangeNotifierProvider(
                create: (BuildContext con) => Paymentrzrpay()),
            ChangeNotifierProvider(
              create: (BuildContext context) => OrderBackend(),
            ),
             ChangeNotifierProvider(
              create: (BuildContext context) => Location(),
            )
          ],
          child: CartPage(
            latlng: LatLng(widget.lat, widget.lon),
          )),
      FutureBuilder(
        builder: (con, snap) {
          // print(snap.data);
          // print(snap.connectionState);
          if (snap.data == false) {
            return LoginOrRegister(lat: widget.lat,lon: widget.lon,);
          } else if (snap.data == null) {
            return Center(child: Lottie.asset('images/Accountpageanimation.json'));
          }
          return MultiProvider(providers: [
            ChangeNotifierProvider(create: (BuildContext context) {
              return RegisterUser();
            }),
            MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (BuildContext context) {
                return AllRestaurent();
              }),
              ChangeNotifierProvider(create: (BuildContext context) {
                return Location();
              }),
              ],
              // child: ChangeNotifierProvider(create: (BuildContext context) {
              //   return AllRestaurent();
              // }),
            )
          ], child: AccountPage());
        },
        future: getifUser(),
      )
    ];
    // print('hloo from home ${widget.address}');
    return WillPopScope(
      onWillPop: () async{
        if(currentIndex==0){
          return true;
        }
        setState(() {
        currentIndex=0;
      }); 
      return false; },
      child: Scaffold(
          extendBodyBehindAppBar: false,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            onTap: (int indx) {
              setState(() {
                currentIndex = indx;
              });
            },
            currentIndex: currentIndex,
            items: [
              bottomappbarItms(FontAwesomeIcons.utensils, 'Home'),
              bottomappbarItms(FontAwesomeIcons.search, 'Explore'),
              BottomNavigationBarItem(
                  icon: Badge(
                    badgeContent: FutureBuilder(
                      future: getcartNumber(),
                      builder: (context, AsyncSnapshot snp) {
                        return Text(snp.data == null
                            ? ''
                            : snp.data['products'].length.toString());
                      },
                    ),
                    child: Icon(
                      FontAwesomeIcons.pizzaSlice,
                      size: 20,
                    ),
                  ),
                  title: Text('Cart')),
              bottomappbarItms(FontAwesomeIcons.user, 'Account'),
            ],
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              //backwardsCompatibility: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FaIcon(
                                FontAwesomeIcons.mapMarkerAlt,
                                color: Colors.orange,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              FutureBuilder(
                                future: loc.getAddress(widget.lat, widget.lon),
                                builder: (context,AsyncSnapshot snap) {
                                  if(snap.data==null){
                                  return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[200]!,
                                        child: Card(
                                         // elevation: 15,
                                          child: ClipPath(
                                            child: Container(
                          height: 20,
                          width:55,
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(color: Colors.grey, width: 4))),
                                            ),
                                            clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3))),
                                          )));
                                   // return CircularProgressIndicator();
                                  }
                                  return Text(
                                    '${snap.data['results'][0]['address_components'][1]['long_name']}',
                                    style: TextStyle(color: Colors.black),
                                  );
                                }
                              ),
                              
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: FutureBuilder(
                              future: loc.getAddress(widget.lat, widget.lon),
                              builder: (context,AsyncSnapshot snapshot) {
                                if(snapshot.data==null){
                                  return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[200]!,
                                        child: Card(
                                         // elevation: 15,
                                          child: ClipPath(
                                            child: Container(
                          height: 20,
                          width:100,
                          decoration: BoxDecoration(
                            border: Border(
                                right: BorderSide(color: Colors.grey, width: 4))),
                                            ),
                                            clipper: ShapeBorderClipper(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3))),
                                          )));
                                }
                                return Container(
                                  height: 20,
                                  width: 250,
                                  child: Text(
                                    '${snapshot.data["results"][0]["formatted_address"]}'+ '..',
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5), fontSize: 12),
                                  ),
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ChangeNotifierProvider(create: (BuildContext context) { return CouponBackend(); },
                        child: CouponPage());
                      }));
                    },
                    child: Container(
                                height: 40,
                                width: 30,
                                child: Image.asset('images/discount.png')),
                  )
                ],
              ),
              elevation: 0,
              backgroundColor: Colors.white,
            ),
          ),
          body:  _children[currentIndex]),
    );
  }

  BottomNavigationBarItem bottomappbarItms(IconData icn, String txt) {
    return BottomNavigationBarItem(
        icon: FaIcon(
          icn,
          size: 20,
        ),
        title: Text(txt));
  }
}
