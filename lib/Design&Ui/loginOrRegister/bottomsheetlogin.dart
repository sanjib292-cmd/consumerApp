import 'package:flutter/material.dart';
import 'package:foodorder_userapp/Backend/LoginRegisterapi.dart';
import 'package:foodorder_userapp/LocationService/Location.dart';
import 'package:foodorder_userapp/Screens/otp.dart';
import 'package:foodorder_userapp/Screens/register.dart';
import 'package:provider/provider.dart';

import '../konst.dart';

class ShowBottomsheet extends StatefulWidget {
  var lat,lon;
ShowBottomsheet({this.lat,this.lon});

  @override
  _ShowBottomsheetState createState() => _ShowBottomsheetState();
}

class _ShowBottomsheetState extends State<ShowBottomsheet> {
  var number = '';
  @override
  Widget build(BuildContext context) {
    var verifynum = Provider.of<RegisterUser>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height,
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0, left: 20),
                child: Text(
                  "LOGIN",
                  style: semiBigTextstyle,
                ),
              ),
            ),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 20),
                  child: Text("Enter your phone number to proceed"),
                )),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 20),
                  child: Text(
                    "10 digit mobile number",
                    style: TextStyle(
                        fontSize: 12, color: Colors.black.withOpacity(0.6)),
                  ),
                )),
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: const EdgeInsets.only(
                      top: 3.0,
                      left: 20,
                      right: 20,
                    ),
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          number = val;
                        });
                      },
                      decoration: InputDecoration(labelText: "+91"),
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      maxLengthEnforced: true,
                    ))),
            Padding(
              padding:
                  const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 4),
              child: SizedBox(
                height: 42,
                child: FlatButton(
                    disabledColor: Colors.orange[200],
                    color: Colors.orange,
                    onPressed: number.length == 10
                        ? () async {
                            print('hello');
                            try{
                            await verifynum.verifyNumber(number,context);

                            if (verifynum.verifynumMsg) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (con) => ChangeNotifierProvider(
                                          create: (BuildContext context) {
                                            return RegisterUser();
                                          },
                                          child: RegisterUserScreen(
                                            number: number,lat: widget.lat,lon: widget.lon,
                                          ))));
                            } else {
                              await verifynum.sendLoginoTp(number);
                              verifynum.sendOtperror !=null?
                                  showDialog(context: context, builder: (ctx){
                                    return  AlertDialog(
                                      title: verifynum.sendOtperror,
                                    );
                                  }):
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (con) => ChangeNotifierProvider(
                                          create: (BuildContext ctx) {
                                            return RegisterUser();
                                          },
                                          child: Otp(number: number,lat: widget.lat,lon: widget.lon,))));
                            }}catch(e){
                              print(e);
                            }
                          }
                        : null,
                    child: Text(
                      number.length == 10 ? "CONTINUE" : "ENTER PHONE NUMBER",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
