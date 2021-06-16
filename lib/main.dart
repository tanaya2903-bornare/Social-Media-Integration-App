import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social/signinPage.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
            backgroundColor: Color(0XFF81C784),
            splash: Image.asset('assets/images/sparks.png'),
            splashIconSize: 500.0,
            nextScreen: signinPage(),
            splashTransition: SplashTransition.slideTransition,
          )
      )
  );
}