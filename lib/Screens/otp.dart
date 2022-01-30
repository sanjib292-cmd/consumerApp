// import 'package:flutter/material.dart';
// import 'package:foodorder_userapp/Backend/LoginRegisterapi.dart';
// import 'package:foodorder_userapp/Screens/register.dart';
// import 'package:otp_screen/otp_screen.dart';
// import 'package:provider/provider.dart';

// class Otp extends StatefulWidget {
//   var number;
//   Otp({this.number});

//   @override
//   _OtpState createState() => _OtpState();
// }

// class _OtpState extends State<Otp> {
//   //  Future<String> validateOtp(String otp) async {
//   //   await Future.delayed(Duration(milliseconds: 2000));
//   //   if (otp == "123456") {
//   //     return null;
//   //   } else {
//   //     return "The entered Otp is wrong";
//   //   }
//   // }
//   @override
//   Widget build(BuildContext context) {
//     var verifyotp = Provider.of<RegisterUser>(context, listen: false);
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: OtpScreen.withGradientBackground(
//           topColor: Color(0xFFcc2b5e),
//           bottomColor: Color(0xFF753a88),
//           otpLength: 6,
//           validateOtp: (code) async{
//              return await verifyotp.veriFylogin(widget.number, code);

//           },
//           //routeCallback: moveToNextScreen,
//           themeColor: Colors.white,
//           titleColor: Colors.white,
//           title: "Phone Number Verification",
//           subTitle: "Enter the code sent to \n ${widget.number}",
//           icon: Image.asset(
//             'images/foodie.png',
//             fit: BoxFit.fill,
//           ), routeCallback: (BuildContext ctx) { Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>RegisterUserScreen())); },
//         ));
//   }
// }

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:foodorder_userapp/Backend/LoginRegisterapi.dart';
import 'package:foodorder_userapp/Backend/cartbacknd.dart';
import 'package:foodorder_userapp/LocationService/Location.dart';
import 'package:foodorder_userapp/Screens/AccountPage.dart';
import 'package:foodorder_userapp/Screens/fetchLocfirstpage.dart';
import 'package:foodorder_userapp/Screens/homepage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  final number;
  final email;
  final name;
  var lat, lon;

  Otp({this.number, this.email, this.name, this.lat, this.lon});

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  veryFynummsg() async {
    var veryfyNum = Provider.of<RegisterUser>(context, listen: false);
    await veryfyNum.verifyNumber(widget.number, context);
  }

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    veryFynummsg();
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    var verifyotp = Provider.of<RegisterUser>(context, listen: false);
    print('${widget.lat} yo tp');
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset("images/LOGO.png"),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Phone Number Verification',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Enter the code sent to ",
                      children: [
                        TextSpan(
                            text: "${widget.number}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      obscuringWidget: FlutterLogo(
                        size: 24,
                      ),
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "I'm from validator";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () => snackBar("OTP resend!!"),
                      child: Text(
                        "RESEND",
                        style: TextStyle(
                            color: Color(0xFF91D3B3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      String? token = await _firebaseMessaging.getToken();
                      await veryFynummsg();
                      print('from otp page ${verifyotp.verifynumMsg}');
                      verifyotp.verifynumMsg == false
                          ? await verifyotp.veriFylogin(
                              widget.number, currentText, token, context)
                          : await verifyotp.veriFyregister(
                              widget.number,
                              currentText,
                              widget.email,
                              widget.name,
                              token,
                              context);
                      print(verifyotp.otpVeryfied);
                      // conditions for validating
                      if (verifyotp.otpVeryfied == false) {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        final SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setBool(
                            'isUser', verifyotp.otpVeryfied);
                        await sharedPreferences.setString(
                            'Account Details', verifyotp.userDetails);

                        setState(() {
                          hasError = false;
                          snackBar("OTP Verified!!");
                          // int count = 0;
                          // var nav=Navigator.of(context);
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return MultiProvider(providers: [
                              // ChangeNotifierProvider(create: (BuildContext context) { return Cart(); },),
                              ChangeNotifierProvider(
                                create: (BuildContext context) {
                                  return Location();
                                },
                              )
                            ], child: FetchLoc());
                          }));
                        });
                      }
                    },
                    child: Center(
                        child: Text(
                      "VERIFY".toUpperCase(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.green.shade300,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.green.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: TextButton(
                    child: Text("Clear"),
                    onPressed: () {
                      textEditingController.clear();
                    },
                  )),
                  Flexible(
                      child: TextButton(
                    child: Text("Set Text"),
                    onPressed: () {
                      setState(() {
                        textEditingController.text = "123456";
                      });
                    },
                  )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
