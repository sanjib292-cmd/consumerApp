// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class TokenNuser  {
//   bool isUser = false;
//   var obtainedIsuser;
//   var tOken;
//   Future<String> getIfuserLogedin() async {
//     final SharedPreferences sharedPreferences =
//         await SharedPreferences.getInstance();
//     print('the fuck${sharedPreferences.getBool('isUser')}');
//     sharedPreferences.getBool('isUser') != null
//         ? obtainedIsuser = sharedPreferences.getBool('isUser')
//         : obtainedIsuser = false;
//     return obtainedIsuser;
//     //notifyListeners();
//   }

//   Future getToken() async {
//     final SharedPreferences sharedPreferences =
//         await SharedPreferences.getInstance();
//     var token = sharedPreferences.getString('Account Details');
//     return token;
//     //notifyListeners();
//   }
// }
