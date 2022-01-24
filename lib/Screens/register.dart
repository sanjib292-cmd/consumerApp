
import 'package:flutter/material.dart';
import 'package:foodorder_userapp/Backend/LoginRegisterapi.dart';
import 'package:foodorder_userapp/Design&Ui/konst.dart';
import 'package:provider/provider.dart';

import 'otp.dart';

class RegisterUserScreen extends StatefulWidget {
  var number,lat,lon;
  RegisterUserScreen({this.number,this.lat,this.lon});

  @override
  _RegisterUserScreenState createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {

  var email = '';
  var name = '';
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var registerUser = Provider.of<RegisterUser>(context, listen: false);

    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 100,
            padding: EdgeInsets.all(20),
            color: Colors.blueGrey[50],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'SIGN UP',
                      style: semiBigTextstyle,
                    )),
                SizedBox(
                  height: 3,
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Text('Create an account with new phone number..'))
              ],
            ),
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10.0,
                        left: 20,
                        right: 20,
                      ),
                      child: Text('10 digit mobile number'),
                    )),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 3.0,
                      left: 20,
                      right: 20,
                    ),
                    child: Text(
                      '${widget.number}',
                      style: semiBigTextstyle,
                    ),
                  ),
                ),
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
                              email = val;
                            });
                          },
                          decoration: InputDecoration(labelText: "EMAIL"),
                          keyboardType: TextInputType.emailAddress,
                          maxLength: 180,
                        ))),
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
                              name = val;
                            });
                          },
                          decoration: InputDecoration(labelText: "NAME"),
                          maxLength: 180,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: FlatButton(
                color: Colors.orange,
                onPressed: () async {
                  try {
                    await registerUser.registerUser(email, name, widget.number,context);
                  } on Exception catch (e) {
                    print(e);
                  }
                   Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (con) => 
                  ChangeNotifierProvider(
                      create: (BuildContext ctx) {
                        return RegisterUser();
                      },
                      child: Otp(number:  widget.number,email:email,name:name,lat: widget.lat,lon: widget.lon,))));
                },
                child: Text('Register')),
          )
        ],
      )),
    );
  }
}
