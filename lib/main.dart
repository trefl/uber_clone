import 'dart:io';

import 'file:///C:/FlutterProject/cab_rider/lib/screens/registrationpage.dart';
import 'package:cab_rider/screens/loginpage.dart';
import 'package:cab_rider/screens/mainpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp(
    name: 'db2',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:151749733936:ios:c1f92dcd0cd00de73887f5',
      apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
      projectId: 'flutter-firebase-plugins',
      messagingSenderId: '151749733936',
      databaseURL: 'https://geetaxi-33def-default-rtdb.europe-west1.firebasedatabase.app',
    )
        : FirebaseOptions(
      appId: '1:151749733936:android:dfd195afe6126e0a3887f5',
      apiKey: 'AIzaSyA_FFj58_p33Oy-PGffn7ACD84BI7HmSkE',
      messagingSenderId: '297855924061',
      projectId: 'flutter-firebase-plugins',
      databaseURL: 'https://geetaxi-33def-default-rtdb.europe-west1.firebasedatabase.app',
    ),
  );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MAIN PAGE',
      theme: ThemeData(
        fontFamily: 'Brand-Regular',
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: MainPage.id,
      routes: {
        RegistrationPage.id: (context) => RegistrationPage(),
        LoginPage.id: (context) => LoginPage(),
        MainPage.id: (context) => MainPage(),

      },
    );
  }
}

