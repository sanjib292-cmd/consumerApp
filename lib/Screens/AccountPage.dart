import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
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
import 'package:shimmer/shimmer.dart';

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
    var user = await getuser.getUser(userdetails,context);
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
    DateFormat dateFormat = DateFormat.yMMMMd('en_US').add_jm();
    var restroDetails = Provider.of<AllRestaurent>(context, listen: false);
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
                  automaticallyImplyLeading:false,
                    backgroundColor: Colors.white,
                    expandedHeight: MediaQuery.of(context).size.height / 4,
                    flexibleSpace:
                        FlexibleSpaceBar(background: ShimmerAccountText()));
              }
              return SliverAppBar(
                automaticallyImplyLeading:false,
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
                            color: Colors.grey[300],
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
              return SliverList(
                  delegate: SliverChildBuilderDelegate((con, index) {
                return Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snp.data['activeOrders'].length,
                        itemBuilder: (con, ind) {
                          if (snp.data['activeOrders'].length == 0) {
                            return Text('No past orders..');
                          }
                          final List activeOrder = snp.data['activeOrders'];
                          activeOrder.sort((a, b) => dateFormat
                              .format(DateTime.parse(b['dateOrderd']))
                              .compareTo(dateFormat
                                  .format(DateTime.parse(a['dateOrderd']))));
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 5.5,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.orange[100],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Align(
                                        alignment: Alignment.topLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            FutureBuilder(
                                              future:
                                                  restroDetails.getRestrobyId(
                                                      activeOrder[ind]
                                                          ['restroName']),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<dynamic>
                                                      snapshot) {
                                                if (snapshot.data == null) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                        child:
                                                            Shimmer.fromColors(
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .white,
                                                                  height: 10,
                                                                  width: 50,
                                                                ),
                                                                baseColor:
                                                                    Colors.grey[
                                                                        400]!,
                                                                highlightColor:
                                                                    Colors.grey[
                                                                        300]!)),
                                                  );
                                                }
                                                return AutoSizeText(
                                                  '${snapshot.data['name']}',
                                                  style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                );
                                              },
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            AutoSizeText(
                                              ' ${activeOrder[ind]['orderStatus']}',
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ],
                                        )),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      width: MediaQuery.of(context).size.width,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: activeOrder[ind]
                                                  ['orderItems']
                                              .length,
                                          itemBuilder: (con, indx) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: OutlineButton(
                                                borderSide: BorderSide(
                                                  width: 2.0,
                                                  color: Colors.orange,
                                                  style: BorderStyle.solid,
                                                ),
                                                onPressed: () {
                                                },
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            'Item: ${activeOrder[ind]['orderItems'][indx]['item']['itemName']}',
                                                            style: GoogleFonts
                                                                .poppins(),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            'qty: ${activeOrder[ind]['orderItems'][indx]['quantity'].toString()}',
                                                            style: GoogleFonts
                                                                .poppins(),
                                                            textAlign:
                                                                TextAlign.start,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: AutoSizeText(
                                                              'price: ${activeOrder[ind]['orderItems'][indx]['price'].toString()}',
                                                              style: GoogleFonts
                                                                  .poppins()),
                                                        ),
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            '${dateFormat.format(DateTime.parse(activeOrder[ind]['dateOrderd']).toLocal())}',
                                                            style: GoogleFonts
                                                                .poppins(),
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            );
                                          }),
                                    ),
                                  ],
                                ),
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
