import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:foodorder_userapp/Backend/cartbacknd.dart';
import 'package:foodorder_userapp/Design&Ui/konst.dart';
import 'package:foodorder_userapp/LocationService/Location.dart';
import 'package:foodorder_userapp/Screens/homepage.dart';
import 'package:provider/provider.dart';

class FetchLoc extends StatefulWidget {
  const FetchLoc({Key? key}) : super(key: key);

  @override
  _FetchLocState createState() => _FetchLocState();
}

class _FetchLocState extends State<FetchLoc> {
  Timer? _timer;
  var er;
  @override
  void initState() {
     EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
       });
    onStart();
    super.initState();
  }

  void onStart() async {
    var res = Provider.of<Location>(context, listen: false);
    try {
      await res.determinePosition();
    } catch (e) {
      setState(() {
        er = e;
      });
    }
    Future.delayed(Duration(seconds: 2), () {
      try {
        if (er == null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (con) => MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                      
                      create: (BuildContext context) { return Cart(); },),
                      ChangeNotifierProvider(create: (BuildContext context) {return Location();},)
                      
                    ],
                    child:MyHomePage(
                        lat: res.lat,
                        lon:res.lon,
                         ),
                    
                  )));
        }
      } catch (e) {
        print('$e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locService = Provider.of<Location>(context);
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage('images/LOGO.png'))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Delivering To',
                  style: bigtextStyle,
                ),
                Hero(
                  tag: 'icon',
                  child: Icon(
                    Icons.location_on,
                    color: Colors.orange,
                    size: 28,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 25,
            ),
            FutureBuilder(
                      future: locService.getAddress(locService.lat, locService.lon),
                      builder: (context,AsyncSnapshot snap) {
                        if(snap.data==null){
                           return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(child: Text('Locating', style: bigtextStyle)),
                              SizedBox(
                                width: 20,
                              ),
                              CircularProgressIndicator(),
                            ],
                          );

                        }
                        return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                           snap.data['results'][0]['address_components'][1]['long_name'],
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          snap.data["results"][0]["formatted_address"] ,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  );
                       
                      }
                    )
                //     : AlertDialog(
                //         title: Text(er),
                //       )
                // : Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Column(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: Text(
                //             locService.adrs?.subLocality ?? toString(),
                //             style: TextStyle(
                //                 fontSize: 22, fontWeight: FontWeight.bold),
                //           ),
                //         ),
                //         SizedBox(
                //           height: 5,
                //         ),
                //         Text(
                //           locService.adrs?.addressLine ?? toString(),
                //           style: TextStyle(
                //               fontSize: 16,
                //               color: Colors.black.withOpacity(0.5)),
                //         ),
                //       ],
                //     ),
                //   ),
          ],
        )),
      ),
    );
  }
}
