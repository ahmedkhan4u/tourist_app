import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:tourist_app/views/splash.dart';
import 'package:firebase_core/firebase_core.dart';

import 'models/favoritesModel.dart';

const String FAVORITE_BOX = 'favorite_box';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   if (kIsWeb)
  await Firebase.initializeApp(
  options: FirebaseOptions(
    apiKey: "AIzaSyBHvYgLuhAWfx0L0PoxNaN_H4qg5a6rdaI",

    authDomain: "touristapp-41ed9.firebaseapp.com",

    projectId: "touristapp-41ed9",

    storageBucket: "touristapp-41ed9.appspot.com",

    messagingSenderId: "844070321275",

    appId: "1:844070321275:web:5d5d308a63145e4adc36de",

    measurementId: "G-LSK6XPPWZL"
  ),
);
else
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(FavoritesModelAdapter());
  await Hive.openBox<FavoritesModel>(FAVORITE_BOX);
  runApp(
    MyApp(),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
      ),
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
