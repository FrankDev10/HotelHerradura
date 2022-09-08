import 'package:flutter/material.dart';
import 'package:hotel3/src/pages/login/login_page.dart';
import 'package:splashscreen/splashscreen.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  Widget build(BuildContext context)  {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new LoginPage(),
      title: Text("",
      //title: Text("Universidad Técnica de Cotopaxi",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26, color: Colors.red
        ),
      ),
      image: Image.asset('assets/img/logo_hotel_herradura.png'),
      photoSize: 150,
      backgroundColor: Colors.white,
      loaderColor: Colors.blueAccent,
      //loadingText: Text("Carrera Ingeniería en \n Sistemas de Información",
      loadingText: Text("\n ",
        style: TextStyle(
            color: Colors.black,
            fontSize: 16.0
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
