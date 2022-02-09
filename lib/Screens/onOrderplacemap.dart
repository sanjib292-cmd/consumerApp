import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/cartbacknd.dart';
import 'package:foodorder_userapp/Backend/getallRestaurents.dart';
import 'package:foodorder_userapp/Design&Ui/Cartpage/addedcartSnackbar.dart';
import 'package:foodorder_userapp/LocationService/Location.dart';
import 'package:foodorder_userapp/Screens/fetchLocfirstpage.dart';
import 'package:foodorder_userapp/Screens/homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OnorderPlace extends StatefulWidget {
  LatLng sourceloc;
  var destloc;
  var orderDetails;

  OnorderPlace({required this.sourceloc, this.destloc, this.orderDetails});

  @override
  _OnorderPlaceState createState() => _OnorderPlaceState();
}

class _OnorderPlaceState extends State<OnorderPlace> {
 // GoogleMapController controller;
  getRestrobyId() async {
    var restro = Provider.of<AllRestaurent>(context, listen: false);
    var orderedrestro =
        await restro.getRestrobyId(widget.orderDetails['restroName']);
    return orderedrestro;
  }

  var orderRestro;
  Completer<GoogleMapController> _controller = Completer();
  
  Set<Marker> _markers = {};
  var sourceIcon;
  var destinationIcon;
  Set<Polyline> _polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];

  void setSourceAndDestinationIcons() async {
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 5), 'images/homwmarker.png')
        .then((value) => sourceIcon = value);
    await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 5), 'images/restromrk2.png')
        .then((value) => destinationIcon = value);
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    getJsonmap('images/retromap.json').then((value) => controller.setMapStyle(value));
    controller.showMarkerInfoWindow(MarkerId('destPin') );
    //controller.setMapStyle()
    setMapPins();
    setPolylines();
  }

  void setMapPins() {
    setState(() {
      // source pin
      _markers.add(Marker(
        flat: true,
          markerId: MarkerId('sourcePin'),
          position: widget.sourceloc,
          icon: sourceIcon));
      // destination pin
      _markers.add(Marker(
        flat: true,
        infoWindow: InfoWindow(title: 'Restro'),
          markerId: MarkerId('destPin'),
          position: widget.destloc,
          icon: destinationIcon));
    });
  }

  void customLaunch(cmnd) async {
    if (await canLaunch(cmnd)) {
      await launch(cmnd);
    } else {
      snackBar('Cant perform this opration', context);
    }
  }

  setPolylines() async {
    PolylineResult result = await (polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDN2f-K_FFbXH-DrAOxwlRvNy3L9z9asyg",
        PointLatLng(widget.sourceloc.latitude, widget.sourceloc.longitude),
        PointLatLng(widget.destloc.latitude, widget.destloc.longitude)));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      Polyline polyline = Polyline(
        width: 3,
          polylineId: PolylineId('poly'),
          color: Color.fromARGB(255, 40, 122, 198),
          patterns: [PatternItem.dash(30), PatternItem.gap(8)],
            points: MapsCurvedLines.getPointsOnCurve(widget.sourceloc, widget.destloc),
          );
      _polylines.add(polyline);
    });
  }

    void setMapstyle(String mapStyle,GoogleMapController controller){

  _controller.complete(controller);
  }

  @override
  void initState() {
    getRestrobyId();
    setSourceAndDestinationIcons();
    super.initState();
  }


  Future<String> getJsonmap(String path)async{
    return await rootBundle.loadString(path);

  }


  @override
  Widget build(BuildContext context) {

    //print(widget.destloc);
    //print('from map page ${(widget.orderDetails).runtimeType}');
    // print('hlo ${widget.destloc}  ${widget.sourceloc}');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
          actions: <Widget>[
           new IconButton(
             icon: new Icon(Icons.close,color: Colors.black,),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              return ChangeNotifierProvider(create: (BuildContext context) { return Location(); },
              child: FetchLoc());
            })),
           ),
         ],
          title: Column(
            children: [
              // widget.orderDetails['dateOrderd']
              Text(
                widget.orderDetails != null
                    ? 'ORDER ${widget.orderDetails['shortOrderid']}'
                    : 'null',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
              ),
              // Text(
              //   '${Timestamp.fromDate(DateTime.parse(widget.orderDetails['dateOrderd']))}',
              //   style: GoogleFonts.poppins(color: Colors.black),
              // )
            ],
          ),
          backwardsCompatibility: true,
          elevation: 0,
          backgroundColor: Colors.transparent),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 7,
          child: FutureBuilder(
            future: getRestrobyId(),
            builder: (con, AsyncSnapshot snp) {
              if (snp.data != null) {
                //print(snp.data.runtimeType);
                return Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0, left: 12),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                  image: DecorationImage(
                                      image:
                                          NetworkImage('${snp.data["imgurl"]}'),
                                      fit: BoxFit.fill)),
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '''${snp.data['name']} \n has received your order''',
                                  style: GoogleFonts.poppins(),
                                  maxLines: 2,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                                onTap: () {
                                  customLaunch('tel:${snp.data['phone']}');
                                },
                                child: Icon(
                                  FontAwesomeIcons.phone,
                                  color: Colors.orange,
                                ))
                          ],
                        ),
                      ],
                    ),
                    //Text('${snp.data}'),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ),
        color: Colors.white,
      ),
      body: GoogleMap(
          markers: _markers,
          zoomGesturesEnabled: false,
          myLocationEnabled: false,
          onMapCreated: onMapCreated,
          polylines: _polylines,
          initialCameraPosition: CameraPosition(
            target: widget.sourceloc,
            zoom: 12,
          )),
    );
  }
}
