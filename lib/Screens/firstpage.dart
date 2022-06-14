import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/LoginRegisterapi.dart';
import 'package:foodorder_userapp/Backend/cartbacknd.dart';
import 'package:foodorder_userapp/Backend/getallRestaurents.dart';
import 'package:foodorder_userapp/Design&Ui/Cartpage/addedcartSnackbar.dart';
import 'package:foodorder_userapp/Design&Ui/carsoulitm.dart';
import 'package:foodorder_userapp/Design&Ui/konst.dart';
import 'package:foodorder_userapp/Design&Ui/loadingShimmer.dart';
import 'package:foodorder_userapp/LocationService/Location.dart';
import 'package:foodorder_userapp/Screens/itemspage.dart';
import 'package:foodorder_userapp/Screens/restroMenu.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:async/async.dart';

class FirstPage extends StatefulWidget {
  var lat;
  var lon;
  var tok;
  FirstPage({this.lat, this.lon, this.tok});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  getCusine() async {
    var restroandMenu = Provider.of<AllRestaurent>(context, listen: false);
    return this._memoizer.runOnce(() async {
      var data = await restroandMenu.getCusinetypes(context);
      return data;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final AsyncMemoizer _memoizer = AsyncMemoizer();

    TextStyle smallTextstyl = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)));
    var restroandMenu = Provider.of<AllRestaurent>(context, listen: false);
    var user = RegisterUser();
    var pro = [];
    // print(restroandMenu.getCusinetypes());

    //restroandMenu.getCusinetypes(context);
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(),
            ),
            FutureBuilder(
                future: getCusine(),
                builder: (con, AsyncSnapshot snapshot) {
                  //  print(snapshot.data());
                  if (snapshot.data != null) {
                    print('cusine${snapshot.data}');
                    return SliverAppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.white,
                      floating: true,
                      expandedHeight: MediaQuery.of(context).size.height / 7,
                      flexibleSpace: FlexibleSpaceBar(
                        background: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (ctx, indx) {
                              return Container(
                                // height: MediaQuery.of(context).size.height/5,
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: GestureDetector(
                                          onTap: () {
                                            print('taped');
                                            print(
                                                '>>>>>>>>>${snapshot.data[indx]}');
                                            pro.clear();

                                            snapshot.data[indx]['restro']
                                                .forEach((e) {
                                              print(">>>>>>>${e['restroNam']}");
                                              if (Geolocator.distanceBetween(
                                                          e['restroNam']['cord']
                                                              [
                                                              'coordinates'][1],
                                                          e['restroNam']['cord']
                                                              [
                                                              'coordinates'][0],
                                                          widget.lat,
                                                          widget.lon) /
                                                      1000 <
                                                  100000) {
                                                pro.add(e);
                                                print(
                                                    'sd ${e['restroNam']['name']}');
                                              }
                                            });
                                            // print(snapshot.data[indx]
                                            //                 ['restro']);
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (ctx) {
                                              return MultiProvider(
                                                providers: [
                                                  ChangeNotifierProvider(
                                                      create: (BuildContext
                                                              context) =>
                                                          Cart()),
                                                  ChangeNotifierProvider(
                                                      create: (BuildContext
                                                              context) =>
                                                          Location())
                                                ],
                                                child: ItemsPage(
                                                    lat: widget.lat,
                                                    lon: widget.lon,
                                                    appBartitle:
                                                        '${snapshot.data[indx]['cusineType']}',
                                                    product: pro),
                                              );
                                            }));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    blurRadius: 5,
                                                    color: Colors.grey,
                                                    spreadRadius: 0.5)
                                              ],
                                            ),
                                            child: CircleAvatar(
                                              minRadius: 26,
                                              maxRadius: 36,
                                              child: CircleAvatar(
                                                minRadius: 25,
                                                maxRadius: 35,
                                                child: AspectRatio(
                                                  aspectRatio: 1 / 1,
                                                  child: ClipOval(
                                                    // borderRadius: BorderRadius.circular(100.0),
                                                    child: FadeInImage(
                                                      fit: BoxFit.cover,
                                                      //fit: BoxFit.cover,
                                                      imageErrorBuilder:
                                                          (con, obj, stack) {
                                                        print('er');
                                                        return CircleAvatar(
                                                          minRadius: 25,
                                                          maxRadius: 35,
                                                          // height: 120,
                                                          // width: 100,
                                                          backgroundImage:
                                                              AssetImage(
                                                            'images/cusine.jpg',
                                                            // height: double
                                                            //     .infinity,
                                                            // fit: BoxFit
                                                            //     .cover
                                                          ),
                                                        );
                                                      },
                                                      placeholder: AssetImage(
                                                        'images/cusine.jpg',
                                                      ),
                                                      image: snapshot.data[indx]
                                                                  ['imgUrl'] !=
                                                              null
                                                          ? NetworkImage(
                                                              snapshot.data[
                                                                      indx]
                                                                  ['imgUrl'])
                                                          : NetworkImage(''),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Center(
                                          child: AutoSizeText(
                                              '${snapshot.data[indx]['cusineType']}',
                                              style: smallTextstyl),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                      //height: MediaQuery.of(context).size.height / 7.2,
                      //title: SizedBox(height: 10,),
                    );
                  }
                  // print('null');
                  return ShimmerCircleAvatar();
                }),
            FutureBuilder(
                future: restroandMenu.getAllrestaurent(
                    context, widget.lat, widget.lon),
                builder: (ctx, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    print('no');
                    return SliverToBoxAdapter();
                  }
                  // if(snapshot.data==null){
                  //   print('none');
                  //   return SliverToBoxAdapter(child: Text('No nearby restaurants',style: GoogleFonts.poppins(color:Colors.red),),);
                  // }
                  print(snapshot.data.length);
                  if (snapshot.data.length == 0) {
                    return SliverToBoxAdapter();
                  }
                  if (snapshot.data.length < 3) {
                    return SliverToBoxAdapter();
                  }
                  // snapshot.data.length==0?

                  return SliverToBoxAdapter(
                      //delegate: SliverChildBuilderDelegate((con, inx) {
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.fire,
                              color: Colors.orange,
                            ),
                            Text('Popular',
                                style: GoogleFonts.poppins(
                                    fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 5,
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          //physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,
                          itemBuilder: ((context, index) {
                            final List activeOrder = snapshot.data;
                            var sorted = activeOrder.sort((a, b) =>
                                b['completedOrders']
                                    .length
                                    .compareTo(a['completedOrders'].length));
                            // print(snapshot.data[index]['rating']);
                            // print(sorted);
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 5,
                                        color: Colors.black,
                                        spreadRadius: 0)
                                  ],
                                ),
                                child: GestureDetector(
                                    onTap: () {
                                      snapshot.data[index]['isOpen']
                                          ? Navigator.push(context,
                                              MaterialPageRoute(builder: (con) {
                                              return ChangeNotifierProvider(
                                                  create:
                                                      (BuildContext context) {
                                                    return Cart();
                                                  },
                                                  child: RestroMenu(
                                                    restroDetails:
                                                        snapshot.data[index],
                                                  ));
                                            }))
                                          : snackBar(
                                              'Restraunt is currently closed',
                                              context);
                                    },
                                    child: Container(
                                      //padding: EdgeInsets.all(15),
                                      // decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(8)),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3,
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Expanded(
                                                flex: 4,
                                                child: Container(
                                                  child: Stack(
                                                    children: [
                                                      Positioned.fill(
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    8),
                                                            topLeft:
                                                                Radius.circular(
                                                                    8),
                                                          ),
                                                          // borderRadius:
                                                          //     BorderRadius
                                                          //         .circular(
                                                          //             8.0),
                                                          child: ColorFiltered(
                                                            colorFilter: snapshot
                                                                            .data[
                                                                        index]
                                                                    ['isOpen']
                                                                ? ColorFilter
                                                                    .matrix(<
                                                                        double>[
                                                                    1,
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    1,
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    1,
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    0,
                                                                    1,
                                                                    0,
                                                                  ])
                                                                : ColorFilter.mode(
                                                                    Colors.grey,
                                                                    BlendMode
                                                                        .saturation),
                                                            child: FadeInImage(
                                                              fit: BoxFit.fill,

                                                              //fit: BoxFit.cover,
                                                              imageErrorBuilder:
                                                                  (con, obj,
                                                                      stack) {
                                                                print('er');
                                                                return Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              8)),
                                                                          image:
                                                                              DecorationImage(
                                                                            // invertColors: snapshot.data[
                                                                            //       index]['isOpen'],
                                                                            image:
                                                                                AssetImage('images/LOGO.png'),
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )),
                                                                );
                                                              },
                                                              placeholder:
                                                                  AssetImage(
                                                                'images/LOGO.png',
                                                              ),
                                                              image: snapshot.data[
                                                                              index]
                                                                          [
                                                                          'imgurl'] !=
                                                                      null
                                                                  ? NetworkImage(
                                                                      snapshot.data[
                                                                              index]
                                                                          [
                                                                          'imgurl'],
                                                                    )
                                                                  : NetworkImage(
                                                                      ''),
                                                            ),
                                                          ),
                                                        ),
                                                        //fit: BoxFit.fill,
                                                      ),
                                                      Positioned(
                                                          bottom: 1,
                                                          right: 1,
                                                          child: snapshot.data[index]['rating'].fold(
                                                                      0,
                                                                      (avg, ele) =>
                                                                          avg +
                                                                          ele /
                                                                              snapshot
                                                                                  .data[index][
                                                                                      'rating']
                                                                                  .length) ==
                                                                  0
                                                              ? Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              2,
                                                                          right:
                                                                              2),
                                                                  height: 15,
                                                                  width: 35,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .green,
                                                                  ),

                                                                  //: 150,
                                                                  child:
                                                                      AutoSizeText(
                                                                    'New',
                                                                    style: GoogleFonts.poppins(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ))
                                                              : Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    color: Colors
                                                                        .green,
                                                                  ),
                                                                  //padding: EdgeInsets.all(5),
                                                                  height: 15,
                                                                  width: 35,
                                                                  child: Center(
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .star,
                                                                          size:
                                                                              13,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        AutoSizeText(
                                                                          '${snapshot.data[index]['rating'].fold(0, (avg, ele) => avg + ele / snapshot.data[index]['rating'].length).toStringAsFixed(1)}',
                                                                          style: GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 10),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )))
                                                    ],
                                                  ),
                                                  // padding: EdgeInsets.all(15),
                                                  // decoration: BoxDecoration(
                                                  //     borderRadius:
                                                  //         BorderRadius.all(
                                                  //           Radius.circular(8)
                                                  //             ),
                                                  //     image: DecorationImage(
                                                  //         // invertColors: snapshot.data[
                                                  //         //       index]['isOpen'],
                                                  //         image: NetworkImage(
                                                  //           snapshot.data[index]
                                                  //               ['imgurl'],
                                                  //         ),
                                                  //         fit: BoxFit.cover,
                                                  //         colorFilter: snapshot
                                                  //                         .data[
                                                  //                     index]
                                                  //                 ['isOpen']
                                                  //             ? null
                                                  //             : ColorFilter
                                                  //                 .matrix(<
                                                  //                     double>[
                                                  //                 0.2126,
                                                  //                 0.7152,
                                                  //                 0.0722,
                                                  //                 0,
                                                  //                 0,
                                                  //                 0.2126,
                                                  //                 0.7152,
                                                  //                 0.0722,
                                                  //                 0,
                                                  //                 0,
                                                  //                 0.2126,
                                                  //                 0.7152,
                                                  //                 0.0722,
                                                  //                 0,
                                                  //                 0,
                                                  //                 0,
                                                  //                 0,
                                                  //                 0,
                                                  //                 1,
                                                  //                 0,
                                                  //               ])
                                                  // )),
                                                )),
                                            Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5.0,
                                                          right: 5.0),
                                                  child: Container(
                                                    child: Column(
                                                      //mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Expanded(
                                                          flex: 1,
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child:
                                                                      Container(
                                                                    // height: 10,
                                                                    width: 150 -
                                                                        16,
                                                                    child: AutoSizeText(
                                                                        snapshot.data[index]
                                                                            [
                                                                            'name'],
                                                                        overflow:
                                                                            TextOverflow
                                                                                .fade,
                                                                        style:
                                                                            restroCardtxtStyle),
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: AutoSizeText(
                                                              snapshot
                                                                          .data[
                                                                              index]
                                                                              [
                                                                              'completedOrders']
                                                                          .length <
                                                                      1
                                                                  ? 'No orders yet'
                                                                  : '${snapshot.data[index]['completedOrders'].length}+ recent orders ',
                                                              style:
                                                                  smallTextstyl,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                      ),
                                    )),
                              ),
                            );
                          }),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1),
                        ),
                      ),
                    ],
                  ));
                }),
            SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                expandedHeight: MediaQuery.of(context).size.height / 3.5,

                // flex: 6,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Column(children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width,
                          child: FutureBuilder(
                              future: restroandMenu.addbanner(context),
                              builder: (context, AsyncSnapshot snap) {
                                if (snap.data == null) {
                                  return CarouselSlider(
                                    items: [
                                      nulCarasoul(
                                        img: 'images/banner1.jpg',
                                      ),
                                      // img: 'https://firebasestorage.googleapis.com/v0/b/mealtime-7fd6c.appspot.com/o/app%20asets%2FPicsArt_10-08-12.13.44.jpg?alt=media&token=a94d832c-d3ba-469f-8d85-b86e27f8ca1c'),
                                      nulCarasoul(
                                        img: 'images/banner2.jpg',
                                      )
                                    ],
                                    options: CarouselOptions(
                                      aspectRatio: 16 / 9,
                                      autoPlay: true,
                                    ),
                                  );
                                }
                                //print(snap.data);
                                return CarouselSlider(
                                  items: [
                                    //CarouselItms(img:'images/PicsArt_10-03-10.53.04.jpg'),
                                    CarouselItms(
                                      img: snap.data['imageUrl1'],
                                      imgt: 'images/banner1.jpg',
                                    ),
                                    CarouselItms(
                                      img: snap.data['imageUrl2'],
                                      imgt: 'images/banner2.jpg',
                                    ),
                                  ],
                                  options: CarouselOptions(
                                    aspectRatio: 16 / 17,
                                    autoPlay: true,
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Container(
                          // height:  MediaQuery.of(context).size.height / 4,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.mapPin,
                                  color: Colors.orange.withOpacity(0.5),
                                ),
                                SizedBox(width: 4),
                                AutoSizeText(
                                  'Nearby Restaurants',
                                  style: GoogleFonts.poppins(
                                      textStyle: semiBigTextstyle),
                                )
                              ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: AutoSizeText('Discover unique tastes near you',
                              style: smallTextstyl),
                        )
                      ]),
                    ],
                  ),
                )),
            // SliverAppBar( automaticallyImplyLeading: false,
            // backgroundColor: Colors.white,
            // expandedHeight: MediaQuery.of(context).size.height / 3.5,

            // // flex: 6,
            // flexibleSpace:FlexibleSpaceBar(background: Container(height: 100),)),
            FutureBuilder(
                future: restroandMenu.getAllrestaurent(
                    context, widget.lat, widget.lon),
                builder: (ctx, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return ShimmerContainer();
                  }
                  if (snapshot.data.length == 0) {
                    return SliverToBoxAdapter(
                      child: Center(
                          child: Text(
                        'No nearby restaurants',
                        style: GoogleFonts.poppins(color: Colors.red),
                      )),
                    );
                  }
                  return SliverList(
                      delegate: SliverChildBuilderDelegate((con, inx) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.length,
                        itemBuilder: ((context, index) {
                          //print(snapshot.data[index]['cord']['coordinates'][0]);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.black,
                                      spreadRadius: 0)
                                ],
                              ),
                              child: GestureDetector(
                                  onTap: () {
                                    snapshot.data[index]['isOpen']
                                        ? Navigator.push(context,
                                            MaterialPageRoute(builder: (con) {
                                            return ChangeNotifierProvider(
                                                create: (BuildContext context) {
                                                  return Cart();
                                                },
                                                child: RestroMenu(
                                                  restroDetails:
                                                      snapshot.data[index],
                                                ));
                                          }))
                                        : snackBar(
                                            'Restraunt is currently closed',
                                            context);
                                  },
                                  child: Container(
                                    //padding: EdgeInsets.all(15),
                                    // decoration: BoxDecoration(
                                    //     borderRadius: BorderRadius.circular(8)),
                                    height:
                                        MediaQuery.of(context).size.height / 3,
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Expanded(
                                              flex: 4,
                                              child: Container(
                                                child: Stack(
                                                  children: [
                                                    Positioned.fill(
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  8),
                                                          topLeft:
                                                              Radius.circular(
                                                                  8),
                                                        ),
                                                        // borderRadius:
                                                        //     BorderRadius
                                                        //         .circular(
                                                        //             8.0),
                                                        child: ColorFiltered(
                                                          colorFilter: snapshot
                                                                          .data[
                                                                      index]
                                                                  ['isOpen']
                                                              ? ColorFilter
                                                                  .matrix(<
                                                                      double>[
                                                                  1,
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  1,
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  1,
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  0,
                                                                  1,
                                                                  0,
                                                                ])
                                                              : ColorFilter.mode(
                                                                  Colors.grey,
                                                                  BlendMode
                                                                      .saturation),
                                                          child: FadeInImage(
                                                            fit: BoxFit.fill,

                                                            //fit: BoxFit.cover,
                                                            imageErrorBuilder:
                                                                (con, obj,
                                                                    stack) {
                                                              print('er');
                                                              return Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                8)),
                                                                        image:
                                                                            DecorationImage(
                                                                          // invertColors: snapshot.data[
                                                                          //       index]['isOpen'],
                                                                          image:
                                                                              AssetImage('images/LOGO.png'),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )),
                                                              );
                                                            },
                                                            placeholder:
                                                                AssetImage(
                                                              'images/LOGO.png',
                                                            ),
                                                            image: snapshot.data[
                                                                            index]
                                                                        [
                                                                        'imgurl'] !=
                                                                    null
                                                                ? NetworkImage(
                                                                    snapshot.data[
                                                                            index]
                                                                        [
                                                                        'imgurl'],
                                                                  )
                                                                : NetworkImage(
                                                                    ''),
                                                          ),
                                                        ),
                                                      ),
                                                      //fit: BoxFit.fill,
                                                    ),
                                                    Positioned(
                                                        bottom: 1,
                                                        right: 1,
                                                        child: snapshot.data[index]['rating'].fold(
                                                                    0,
                                                                    (avg, ele) =>
                                                                        avg +
                                                                        ele /
                                                                            snapshot
                                                                                .data[index][
                                                                                    'rating']
                                                                                .length) ==
                                                                0
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 2,
                                                                        right:
                                                                            2),
                                                                height: 15,
                                                                width: 35,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .green,
                                                                ),

                                                                //: 150,
                                                                child:
                                                                    AutoSizeText(
                                                                  'New',
                                                                  style: GoogleFonts.poppins(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ))
                                                            : Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                //padding: EdgeInsets.all(5),
                                                                height: 15,
                                                                width: 35,
                                                                child: Center(
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .star,
                                                                        size:
                                                                            13,
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                      AutoSizeText(
                                                                        '${snapshot.data[index]['rating'].fold(0, (avg, ele) => avg + ele / snapshot.data[index]['rating'].length).toStringAsFixed(1)}',
                                                                        style: GoogleFonts.poppins(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.white,
                                                                            fontSize: 10),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )))
                                                  ],
                                                ),
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5.0, right: 5.0),
                                                child: Container(
                                                  child: Column(
                                                    //mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: AutoSizeText(
                                                                    snapshot.data[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                    style:
                                                                        semiBigTextstyle),
                                                              ),
                                                            ]),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Container(
                                                            height: 25,
                                                            width: 250,
                                                            child: ListView
                                                                .builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount: snapshot
                                                                  .data[index][
                                                                      'cusineType']
                                                                  .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int indx) {
                                                                return AutoSizeText(
                                                                    '${snapshot.data[index]['cusineType'][indx]['cusineType']} ,',
                                                                    style:
                                                                        smallTextstyl);
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: snapshot.data[
                                                                            index]
                                                                        [
                                                                        'cord'] !=
                                                                    null
                                                                ? AutoSizeText(
                                                                    (Geolocator.distanceBetween(snapshot.data[index]['cord']['coordinates'][1], snapshot.data[index]['cord']['coordinates'][0], widget.lat, widget.lon) /
                                                                                1000)
                                                                            .toStringAsFixed(
                                                                                2) +
                                                                        ' KM',
                                                                    style:
                                                                        smallTextstyl)
                                                                : Container()),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: AutoSizeText(
                                                              snapshot.data[index]
                                                                      ['isOpen']
                                                                  ? 'Open'
                                                                  : 'Closed',
                                                              style: GoogleFonts.poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: snapshot.data[index]
                                                                          [
                                                                          'isOpen']
                                                                      ? Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              0.6)
                                                                      : Colors
                                                                          .red
                                                                          .withOpacity(0.6))),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          );
                        }));
                  }, childCount: 1));
                }),
          ],
        ),
      ),
    );
  }
}
