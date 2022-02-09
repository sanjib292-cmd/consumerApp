import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/getallRestaurents.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class Serchpage extends StatefulWidget {
  const Serchpage({Key? key}) : super(key: key);

  @override
  _SerchpageState createState() => _SerchpageState();
}

class _SerchpageState extends State<Serchpage> {
  //TextEditingController textController = TextEditingController();
  var searchTxt;
  @override
  Widget build(BuildContext context) {
    var serch = Provider.of<AllRestaurent>(context, listen: false);
    Stream search(txt) async* {
      //print(searchTxt);
      yield* Stream.periodic(Duration(seconds: 1), (_) {
        return txt.length >= 3 ? serch.serchProduct('$txt', context) : null;
      }).asyncMap((event) async => await event);
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              autofocus: true,
              onChanged: (val) {
                setState(() {
                  searchTxt = val;
                });
                //print(searchTxt);
              },
              // validator: (value) {
              //   if (value != null && value.trim().length < 3) {
              //     return 'This field requires a minimum of 3 characters';
              //   }

              //   return null;
              // },
              decoration: const InputDecoration(
                  labelText: 'Search for food',
                  border: OutlineInputBorder(gapPadding: 3),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 5))),
            ),
          ),
          StreamBuilder(
              stream: search(searchTxt),
              builder: (con, AsyncSnapshot snap) {
                if (snap.data == null) {
                  return Container();
                } else if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                 if (snap.data.length == 0) {
                         return Center(
                            child: Lottie.network(
                                'https://assets6.lottiefiles.com/temp/lf20_USCruP.json',height: 120),
                          );
                        }

                //print('tok ${snap.data.length}');
                return Expanded(
                  child: ListView.builder(
                      itemCount: snap.data!.length,
                      itemBuilder: (con, ind) {
                        // print(snap.data);
                        // print(snap.data.length);
                       
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
                                                  image: AssetImage(snap
                                                                  .data[ind]
                                                              ['restro']
                                                          ['items']['isveg']
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
                                            snap.data[ind]['restro']['items']
                                                ['itemName'],
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
                                              snap.data[ind]['restro']['items']
                                                      ['price']
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
                                                  "${snap.data[ind]['restro']['items']['itmImg']}"),
                                              placeholder: AssetImage(
                                                  'images/FoodVector.jpg'),
                                            ),
                                          ),
                                        ),
                                        Container(
                                            width: 90,
                                            child: snap.data[ind]['restro']
                                                    ['items']['inStock']
                                                ? MaterialButton(
                                                    color: Colors.green,
                                                    onPressed: () async {
                                                      // final SharedPreferences
                                                      //     sp =
                                                      //     await SharedPreferences.getInstance();
                                                      // var userId =
                                                      //     sp.getString('Account Details');
                                                      // if (userId ==
                                                      //     null) {
                                                      //   return snackBar(
                                                      //       'Please login to add this to cart',
                                                      //       context);
                                                      // }
                                                      // Map<String,
                                                      //         dynamic>
                                                      //     payload =
                                                      //     Jwt.parseJwt(userId);
                                                      //     print(widget.restroDetails['cord']['lon']);
                                                      // await cart.addToCart(
                                                      //     id:payload['id'],
                                                      //     item:widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx],
                                                      //     quantity:1,
                                                      //     price:widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]['price'],
                                                      //     token:userId,
                                                      //     restroId:widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]['restroId'],
                                                      //    itmid: widget.restroDetails['cusineType'][index]['restro'][0]['items'][indx]['_id'],
                                                      //     lat:widget.restroDetails['cord']['lat'],
                                                      //     lon:widget.restroDetails['cord']['lon']);
                                                      // cart.sucessFullyaded !=
                                                      //         null
                                                      //     ? snackBar('${cart.sucessFullyaded}',
                                                      //         context)
                                                      //     : snackBar('${cart.notAdded}',
                                                      //         context);
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
                      }),
                );
              })
        ],
      ),
    );
  }
}
