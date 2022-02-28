import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodorder_userapp/Backend/LoginRegisterapi.dart';
import 'package:foodorder_userapp/LocationService/Location.dart';
import 'package:provider/provider.dart';


import 'Screens/fetchLocfirstpage.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(mybackgroundmsghndler);
      runApp(MyApp());
      configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
   // ..customAnimation = CustomAnimation();
}


Future<void> mybackgroundmsghndler(RemoteMessage message) async {
  await Firebase.initializeApp();
  return _showNotif(message);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future _showNotif(RemoteMessage msg) async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      //'this chanel used for importence notif',
      enableLights: true,
      playSound: true,
      importance: Importance.high);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  RemoteNotification? data = msg.notification;
  AndroidNotification? android = msg.notification?.android;
  if (data != null) {
    flutterLocalNotificationsPlugin.show(
        4,
        data.title,
        data.body,
        NotificationDetails(
            android: AndroidNotificationDetails(

              channel.id, channel.name,
                importance: Importance.high,
                priority: Priority.high,
                icon: android?.sound,
                setAsGroupSummary: true)));
  }
}

class MyApp extends StatefulWidget {
  
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String fcmtoken = " lol";
 
  @override
  void initState() {
     getToken();
    var initializSettingAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializSettingAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        //onSelectNotification: onSelectNotification
        );
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      RemoteNotification? _notification=event.notification;
      AndroidNotification? android=event.notification?.android;
      if(_notification!=null && android!=null){
       _showNotif(event);
      }
    });
   
    super.initState();
  }

   getToken() async {
    String? token = await _firebaseMessaging.getToken();
    setState(() {
      fcmtoken = token!;
    });
  }

  // onSelectNotification(payload) async {
  //   //print("onselect: " + payload);
  // }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chefoo',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: AnimatedSplashScreen(
          splashTransition: SplashTransition.slideTransition,
          //pageTransitionType: PageTransitionType.scale,
          backgroundColor: Colors.orange.shade100,
          duration: 3000,
          nextScreen: MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (BuildContext context) {
                  return Location();
                },),
                ChangeNotifierProvider(
                create: (BuildContext context) {
                  return RegisterUser();
                },)
            ],
            child: FetchLoc(),
          ),
          splash: CircleAvatar(
            radius: 400,
            child: ClipRRect(
              child: Image.asset('images/LOGO.png'),
              borderRadius: BorderRadius.circular(120.0),
            ),
            backgroundColor: Colors.pink,
          )),
          builder: EasyLoading.init(),
    );
  }
}
