import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/LoginRegisterapi.dart';
import 'package:foodorder_userapp/Backend/getallRestaurents.dart';
import 'package:foodorder_userapp/Design&Ui/Cartpage/addedcartSnackbar.dart';
import 'package:foodorder_userapp/Design&Ui/konst.dart';
import 'package:foodorder_userapp/Design&Ui/loadingShimmer.dart';
import 'package:foodorder_userapp/Screens/LoginorRegister.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  var user;
  AccountPage({this.user});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  Future getuserByid(token) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var userdetails = sharedPreferences.getString('Account Details');
    //Map<String, dynamic> payload = Jwt.parseJwt(token);
    var getuser = Provider.of<RegisterUser>(context, listen: false);
    // print(payload['id'] + 'lol');
    var user = await getuser.getUser(userdetails, context);
    return user;
  }

  var userDetails;
  getUserdetails() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var userdetails = sharedPreferences.getString('Account Details');
    setState(() {
      userDetails = userdetails;
    });
    getuserByid(userDetails);
  }

  checkIftokenExp() async {
    await getUserdetails();
    if (JwtDecoder.isExpired(userDetails)) {
      Navigator.push(
          context, MaterialPageRoute(builder: (ctx) => LoginOrRegister()));
    }
  }

  @override
  void initState() {
    checkIftokenExp();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var rate = Provider.of<AllRestaurent>(context, listen: false);
    DateFormat dateFormat = DateFormat.yMMMMd('en_US').add_jm();
    // var location = Provider.of<Location>(context, listen: false);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(),
          ),
          FutureBuilder(
            future: getuserByid(userDetails),
            builder: (con, AsyncSnapshot snp) {
              if (snp.data == null) {
                return SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.white,
                    expandedHeight: MediaQuery.of(context).size.height / 4,
                    flexibleSpace:
                        FlexibleSpaceBar(background: ShimmerAccountText()));
              }
              return SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                expandedHeight: MediaQuery.of(context).size.height / 2.5,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: AutoSizeText(
                                    '${snp.data['name']}'.toUpperCase(),
                                    style: semiBigTextstyle,
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0, left: 4, bottom: 16),
                                  child: Row(
                                    children: [
                                      AutoSizeText(
                                          '${snp.data['phoneNumber']}'
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                                  .withOpacity(0.5))),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text('||'),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      AutoSizeText(
                                          '${snp.data['email']}'.toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                                  .withOpacity(0.5))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.black,
                                  height: 2,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: AutoSizeText(
                                          'My Account',
                                          style: semiBigTextstyle,
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: 12,
                                      // ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: DropdownButton(
                                          icon: FaIcon(FontAwesomeIcons
                                              .arrowAltCircleDown),
                                          alignment:
                                              AlignmentDirectional.bottomStart,
                                          elevation: 0,
                                          hint: AutoSizeText('Explore'),
                                          disabledHint: AutoSizeText('Explore'),
                                          isExpanded: true,
                                          items: <String>[
                                            'Adresses',
                                            'Settings',
                                            'Saved cards'
                                          ].map((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0),
                                                    child: Text(value),
                                                  )),
                                            );
                                          }).toList(),
                                          onChanged: (_) {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.5),
                                  height: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8)),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 8, bottom: 8),
                                  child: Text('Past orders',
                                      style: TextStyle(
                                          //fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.black.withOpacity(0.5))),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          FutureBuilder(
            future: getuserByid(userDetails),
            builder: (con, AsyncSnapshot snp) {
              if (snp.data == null) {
                return ShimmerContainer();
              }
              //print(snp.data);
              // print(snp.data['activeOrders'][0]['restroName']);
              return SliverList(
                  delegate: SliverChildBuilderDelegate((con, index) {
                return Column(
                  children: [
                    ExpansionTile(
                      title: Text(
                        'Past orders',
                        style: GoogleFonts.poppins(),
                      ),
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snp.data['activeOrders'].length,
                            itemBuilder: (con, ind) {
                              if (snp.data['activeOrders'].length == 0) {
                                return Text('No past orders..');
                              }
                              //print(snp.data['activeOrders'][0]['shortOrderid']);
                              final List activeOrder = snp.data['activeOrders'];
                              activeOrder.sort((a, b) => dateFormat
                                  .format(DateTime.parse(b['dateOrderd']))
                                  .compareTo(dateFormat.format(
                                      DateTime.parse(a['dateOrderd']))));
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  width: MediaQuery.of(context).size.width / 2,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                    //color: Colors.orange[100],
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0, left: 4.0),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      image: DecorationImage(
                                                          fit: BoxFit.fill,
                                                          image: NetworkImage(
                                                              '${activeOrder[ind]['restroName']['imgurl']}')),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        AutoSizeText(
                                                          '${activeOrder[ind]['restroName']['name']}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        AutoSizeText(
                                                          '${activeOrder[ind]['shortOrderid']}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        )
                                                      ],
                                                    ),
                                                    AutoSizeText(
                                                      '${activeOrder[ind]['orderStatus']}',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.green),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                        flex: 4,
                                      ),
                                      // Divider(thickness: 1,),
                                      Expanded(
                                          flex: 5,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount: activeOrder[
                                                                    ind]
                                                                ['orderItems']
                                                            .length,
                                                        itemBuilder:
                                                            (con, indx) {
                                                          return Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  height: 15,
                                                                  width: 15,
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(activeOrder[ind]['orderItems'][indx]['item']['isveg']
                                                                              ? 'images/veg.png'
                                                                              : 'images/non-veg.png'))),
                                                                ),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                AutoSizeText(
                                                                  '${activeOrder[ind]['orderItems'][indx]['quantity'].toString()}x ',
                                                                  style: GoogleFonts
                                                                      .poppins(),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                ),
                                                                AutoSizeText(
                                                                  '${activeOrder[ind]['orderItems'][indx]['item']['itemName']}',
                                                                  style: GoogleFonts
                                                                      .poppins(),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }),
                                                  ),
                                                ),
                                                Divider(
                                                  thickness: 0.5,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 6.0,
                                                          right: 6.0),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          AutoSizeText(
                                                            '${dateFormat.format(DateTime.parse(activeOrder[ind]['dateOrderd']).toLocal())}',
                                                            style: GoogleFonts.poppins(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.6)),
                                                          ),
                                                          Row(
                                                            children: [
                                                              activeOrder[ind][
                                                                          'paymentId'] ==
                                                                      null
                                                                  ? AutoSizeText(
                                                                      'COD',
                                                                      style: GoogleFonts.poppins(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.red),
                                                                    )
                                                                  : AutoSizeText(
                                                                      'PAID',
                                                                      style: GoogleFonts.poppins(
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          color:
                                                                              Colors.green),
                                                                    ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              AutoSizeText(
                                                                '₹${activeOrder[ind]['orderTotal']}',
                                                                style: GoogleFonts.poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .green),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      activeOrder[ind][
                                                                  'orderStatus'] ==
                                                              "Delivered"
                                                          ? activeOrder[ind]
                                                                  ['isRated']
                                                              ? Container()
                                                              : Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      'Rate Order',
                                                                      style: GoogleFonts.poppins(
                                                                          fontSize:
                                                                              12,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.6)),
                                                                    ),
                                                                    RatingBar
                                                                        .builder(
                                                                      itemSize:
                                                                          20,
                                                                      initialRating:
                                                                          0,
                                                                      minRating:
                                                                          1,
                                                                      direction:
                                                                          Axis.horizontal,
                                                                      allowHalfRating:
                                                                          true,
                                                                      itemCount:
                                                                          5,
                                                                      itemPadding:
                                                                          EdgeInsets.symmetric(
                                                                              horizontal: 0.0),
                                                                      itemBuilder:
                                                                          (context, _) =>
                                                                              Icon(
                                                                        Icons
                                                                            .star,
                                                                        color: Colors
                                                                            .amber,
                                                                      ),
                                                                      onRatingUpdate:
                                                                          (rating) async {
                                                                        await rate.rateRestro(
                                                                            userDetails,
                                                                            rating,
                                                                            activeOrder[ind]['_id'],
                                                                            activeOrder[ind]['restroName']['_id']);
                                                                        // print(rating);
                                                                      },
                                                                    )
                                                                  ],
                                                                )
                                                          : Container()
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),

                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Column(
                                      //     mainAxisAlignment: MainAxisAlignment.start,
                                      //     children: [
                                      //       Align(
                                      //           alignment: Alignment.topLeft,
                                      //           child: Row(
                                      //             mainAxisAlignment:
                                      //                 MainAxisAlignment.spaceBetween,
                                      //             children: [
                                      //             AutoSizeText(
                                      //                 'Order total: ₹${activeOrder[ind]['orderTotal']}',
                                      //                 style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.green),
                                      //               ),
                                      //               SizedBox(
                                      //                 width: 10,
                                      //               ),
                                      //               AutoSizeText(
                                      //                 ' ${activeOrder[ind]['orderStatus']}',
                                      //                 style: GoogleFonts.poppins(),
                                      //               ),
                                      //             ],
                                      //           )),
                                      //       Container(
                                      //         height:
                                      //             MediaQuery.of(context).size.height /
                                      //                 8,
                                      //         width: MediaQuery.of(context).size.width,
                                      //         child: ListView.builder(
                                      //             scrollDirection: Axis.horizontal,
                                      //             itemCount: activeOrder[ind]
                                      //                     ['orderItems']
                                      //                 .length,
                                      //             itemBuilder: (con, indx) {
                                      //               return Padding(
                                      //                 padding:
                                      //                     const EdgeInsets.all(4.0),
                                      //                 child: OutlineButton(
                                      //                   borderSide: BorderSide(
                                      //                     width: 2.0,
                                      //                     color: Colors.orange,
                                      //                     style: BorderStyle.solid,
                                      //                   ),
                                      //                   onPressed: () {
                                      //                   },
                                      //                   child: Container(
                                      //                       decoration: BoxDecoration(
                                      //                         borderRadius:
                                      //                             BorderRadius.circular(
                                      //                                 8),
                                      //                       ),
                                      //                       child: Column(
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment
                                      //                                 .start,
                                      //                         crossAxisAlignment:
                                      //                             CrossAxisAlignment
                                      //                                 .start,
                                      //                         children: [
                                      //                           Expanded(
                                      //                             child: AutoSizeText(
                                      //                               '${activeOrder[ind]['orderItems'][indx]['item']['itemName']}',
                                      //                               style: GoogleFonts
                                      //                                   .poppins(),
                                      //                             ),
                                      //                           ),
                                      //                           Expanded(
                                      //                             child: AutoSizeText(
                                      //                               '${activeOrder[ind]['orderItems'][indx]['quantity'].toString()}x',
                                      //                               style: GoogleFonts
                                      //                                   .poppins(),
                                      //                               textAlign:
                                      //                                   TextAlign.start,
                                      //                             ),
                                      //                           ),
                                      //                           Expanded(
                                      //                             child: AutoSizeText(
                                      //                                 '₹${activeOrder[ind]['orderItems'][indx]['price'].toString()}',
                                      //                                 style: GoogleFonts
                                      //                                     .poppins()),
                                      //                           ),
                                      //                           Expanded(
                                      //                             child: AutoSizeText(
                                      //                               '${dateFormat.format(DateTime.parse(activeOrder[ind]['dateOrderd']).toLocal())}',
                                      //                               style: GoogleFonts
                                      //                                   .poppins(),
                                      //                             ),
                                      //                           )
                                      //                         ],
                                      //                       )),
                                      //                 ),
                                      //               );
                                      //             }),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                              // Card(child: Column(
                              //   children: [
                              //     Text('${snp.data['activeOrders'][ind]['orderItems'][0]['item']['itemName']}')
                              //   ],
                              // )

                              //);
                            }),
                      ],
                    ),
                    Container(
                      width: 150,
                      child: OutlineButton(
                          child: new Text(
                            "Logout",
                            style: GoogleFonts.poppins(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500),
                          ),
                          borderSide:
                              BorderSide(color: Colors.orange, width: 2),
                          onPressed: () async {
                            final SharedPreferences _sp =
                                await SharedPreferences.getInstance();
                            _sp.remove('Account Details');
                            _sp.setBool('isUser', false);
                            snackBar('logedout', context);
                          }),
                    ),
                  ],
                );
              }, childCount: 1));
            },
          )
        ],
      ),
    );
  }
}
