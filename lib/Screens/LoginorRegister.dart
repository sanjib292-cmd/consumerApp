import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodorder_userapp/Backend/LoginRegisterapi.dart';
import 'package:foodorder_userapp/Design&Ui/bottomsheetlogin.dart';
import 'package:foodorder_userapp/Design&Ui/konst.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginOrRegister extends StatefulWidget {
  var lat,lon;
  LoginOrRegister({this.lat,this.lon});

  @override
  _LoginOrRegisterState createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  
  bool isUser = false;
  Future getIfuserLogedin() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var obtainedIsuser = sharedPreferences.getBool('isUser');
    setState(() {
      isUser = obtainedIsuser!;
    });
  }
    Future<void> launchsite(String url) async {
    if (!await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    )) {
      throw 'Could not launch $url';
    }
  }
  

  String num = '';
  @override
  void initState() {
    getIfuserLogedin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   
    print(widget.lat);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('images/accountpage2.jpg'))),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  color: Colors.grey,
                                  spreadRadius: 5)
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 56,
                            child: CircleAvatar(
                              radius: 54,
                              backgroundImage: AssetImage('images/foodpic.jpg'),
                            ),
                          ),
                        ),
                      )),
                ],
              )),
          Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    topLeft: Radius.circular(40.0),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 16,
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, bottom: 4),
                              child: Text('ACCOUNT', style: semiBigTextstyle),
                            )),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                'Login/Create Account quickly to manage orders..',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.start,
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 8),
                          child: SizedBox(
                            height: 42,
                            child: FlatButton(
                                color: Colors.orange,
                                onPressed: () {
                                  Future(() => showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return ChangeNotifierProvider(
                                            create: (BuildContext context) {
                                              return RegisterUser();
                                            },
                                            child: ShowBottomsheet());
                                      }));
                                },
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Container(height: 2, color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 15),
                          child: Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.infoCircle,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: (){                                            launchsite('https://www.chefoo.in/');
},
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.0),
                                  child: Text('About Us',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// _bottomSheet(context) {
//   String num = '';
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext c) {
//         return Container(
//           padding:
//               EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Align(
//                 alignment: Alignment.topLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 25.0, left: 20),
//                   child: Text(
//                     "LOGIN",
//                     style: semiBigTextstyle,
//                   ),
//                 ),
//               ),
//               Align(
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 2.0, left: 20),
//                     child: Text("Enter your phone number to proceed"),
//                   )),
//               Align(
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 8.0, left: 20),
//                     child: Text(
//                       "10 digit mobile number",
//                       style: TextStyle(
//                           fontSize: 12, color: Colors.black.withOpacity(0.6)),
//                     ),
//                   )),
//               Align(
//                   alignment: Alignment.topLeft,
//                   child: Padding(
//                       padding: const EdgeInsets.only(
//                         top: 3.0,
//                         left: 20,
//                         right: 20,
//                       ),
//                       child: TextField(
//                         onChanged: (val) {
//                           set
//                           num == val;
//                           print(val);
//                         },
//                         decoration: InputDecoration(labelText: "+91"),
//                         keyboardType: TextInputType.number,
//                         maxLength: 10,
//                         maxLengthEnforced: true,
//                       ))),
//               Padding(
//                 padding: const EdgeInsets.only(
//                     left: 15, right: 15, top: 8, bottom: 4),
//                 child: SizedBox(
//                   height: 42,
//                   child: FlatButton(
//                       color: Colors.orange,
//                       onPressed: () {
//                         _bottomSheet(context);
//                       },
//                       child: Text(
//                         "LOGIN",
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       )),
//                 ),
//               ),
//             ],
//           ),
//         );
//       });
// }
