import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class FirstPage extends StatefulWidget {
  var lat;
  var lon;
  FirstPage({this.lat, this.lon});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    TextStyle smallTextstyl = GoogleFonts.poppins(
        textStyle: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.black.withOpacity(0.5)));
    var restroandMenu = Provider.of<AllRestaurent>(context, listen: false);
    // print(restroandMenu.getCusinetypes());

    restroandMenu.getCusinetypes(context);
    return Scaffold(
      
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
              SliverToBoxAdapter(
                child: Container(),
              ),
            FutureBuilder(
                future: restroandMenu.getCusinetypes(context),
                builder: (con, AsyncSnapshot snapshot) {
                  //  print(snapshot.data());
                  if (snapshot.data != null) {
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
                                                  product:
                                                      snapshot.data[indx]
                                                          ['restro']),
                                            );
                                          }));
                                        },
                                        child: CircleAvatar(
                                          minRadius: 26,
                                          maxRadius: 36,
                                          child:  CircleAvatar(
                                             minRadius: 25,
                                          maxRadius: 35,
                                            child: ClipOval(
                                                         // borderRadius: BorderRadius.circular(25.0),
                                                          child: FadeInImage(
                                                            fit: BoxFit
                                                                          .cover,
                                                              //fit: BoxFit.cover,
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
                                                              placeholder:AssetImage( 'images/FoodVector.jpg',),
                                                                 image: snapshot.data[indx]['imgUrl']!=null?NetworkImage(snapshot.data[indx]['imgUrl']):NetworkImage(''),),
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
                          child: CarouselSlider(
                            items: [
                              //CarouselItms(img:'images/PicsArt_10-03-10.53.04.jpg'),
                              CarouselItms(
                                  img: 'images/PicsArt_10-08-12.13.44.jpg'),
                              CarouselItms(
                                  img: 'images/PicsArt_10-08-12.19.34.jpg'),
                            ],
                            options: CarouselOptions(
                              aspectRatio: 16 / 17,
                              autoPlay: true,
                            ),
                          ),
                        ),
                        SizedBox(height: 3,),
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
                                'Nearby Restaurents',
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
      
                      FutureBuilder(
                          future: restroandMenu.getAllrestaurent(context),
                          builder: (ctx, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return ShimmerContainer();
                            }
                            return SliverList(
                              delegate:SliverChildBuilderDelegate((con,inx){
                                return
                                ListView.builder(
                                  shrinkWrap: true,
                                   physics: NeverScrollableScrollPhysics(),
                                   itemCount: snapshot.data.length,
                                  itemBuilder: (
                                    (context, index) {
                                     // print(snapshot.data[index]['rating']);
                                    return Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Container(
                                        child: GestureDetector(
                                            onTap: () {
                                              snapshot.data[index]['isOpen']?
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (con) {
                                                return ChangeNotifierProvider(
                                                    create:
                                                        (BuildContext context) {
                                                      return Cart();
                                                    },
                                                    child: RestroMenu(
                                                      restroDetails:
                                                          snapshot.data[index],
                                                    ));
                                              })):snackBar('Restraunt is currently closed',context);
                                            },
                                            child: Container(
                                              //padding: EdgeInsets.all(15),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              child: Card(
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                        flex: 4,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Container(
                                                            child: Stack(
                                                              children: [
                                                                Positioned(
                                                                  bottom: 1,
                                                                  right: 1,
                                                                  child:  snapshot.data[index]
                                                                                  [
                                                                                  'rating'].fold(0,(avg,ele)=>avg+ele/snapshot.data[index]
                                                                                  [
                                                                                  'rating'].length)==0?
                                                                                  Container(
                                                                                    padding: EdgeInsets.only(left:2,right: 2),
                                                                                    height: 15,
                                                                                    width: 35,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: BorderRadius.circular(5),
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                    
                                                                                    //: 150,
                                                                                    child: AutoSizeText('New',style: GoogleFonts.poppins(color:Colors.white,fontSize: 15,fontWeight: FontWeight.w500),)):
                                                                                  Container(
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Colors.green,),
                                                                                   //padding: EdgeInsets.all(5),
                                                                                    height: 15,
                                                                                    width: 35,
                                                                                    
                                                                                    child: Center(
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Icon(Icons.star,size: 13,color: Colors.white,),
                                                                                          AutoSizeText('${snapshot.data[index]
                                                                                  [
                                                                                  'rating'].fold(0,(avg,ele)=>avg+ele/snapshot.data[index]
                                                                                  [
                                                                                  'rating'].length)}',style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 10),),
                                                                                        ],
                                                                                      ),
                                                                                    )) )
                                                              ],
                                                            ),
                                                            // padding: EdgeInsets.all(15),
                                                            decoration:
                                                                BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                                8),
                                                                    image:
                                                                        DecorationImage(
                                                                          // invertColors: snapshot.data[
                                                                          //       index]['isOpen'],
                                                                      image:
                                                                          NetworkImage(
                                                                        snapshot.data[
                                                                                index]
                                                                            [
                                                                            'imgurl'],
                                                                      ),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                          colorFilter:
                                                                           snapshot.data[
                                                                                index]['isOpen']?null:

                                                                        ColorFilter.matrix(<double>[
 0.2126,0.7152,0.0722,0,0,
 0.2126,0.7152,0.0722,0,0,
 0.2126,0.7152,0.0722,0,0,
 0,0,0,1,0,
])
                                                                    )),
                                                          ),
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                                          child: AutoSizeText(
                                                                              snapshot.data[index]
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
                                                                        Alignment
                                                                            .topLeft,
                                                                    child:
                                                                        Container(
                                                                      height: 20,
                                                                      width: 200,
                                                                      child: ListView
                                                                          .builder(
                                                                        scrollDirection:
                                                                            Axis.horizontal,
                                                                        itemCount: snapshot
                                                                            .data[
                                                                                index]
                                                                                [
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
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child:snapshot.data[index]['cord']!=null? AutoSizeText(
                                                                        (Geolocator.distanceBetween(snapshot.data[index]['cord']['lat'], snapshot.data[index]['cord']['lon'], widget.lat, widget.lon) /
                                                                                    1000)
                                                                                .toStringAsFixed(
                                                                                    2) +
                                                                            ' KM',
                                                                        style:
                                                                            smallTextstyl):Container()
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex: 1,
                                                                  child: Align(
                                                                    alignment: Alignment.topLeft,
                                                                    child: AutoSizeText(snapshot.data[index]['isOpen']?'Open':'Closed',style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color:snapshot.data[index]['isOpen']? Colors.green.withOpacity(0.6):Colors.red.withOpacity(0.6))),),
                                                                ),
                                                                
                                                              ],
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            )
                                            ),
                                      ),
                                    );
                                  }));
                      
                              },
                              childCount: 1
                              ) 
                            );
                                    }),
        
          ],
        ),
      ),
    );
  }
}
