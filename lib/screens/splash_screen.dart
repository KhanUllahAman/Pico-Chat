import 'package:chattingapp/api/api.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/screens/auth/login_screen.dart';
import 'package:chattingapp/screens/home_screens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500), () {
      if (APIs.auth.currentUser != null) {
        print('\nUser: ${APIs.auth.currentUser}');
        print('\nUserAdditionalInfo: ${APIs.auth.currentUser}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }

  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 33, 33),
      body: Stack(children: [
        Positioned(
            top: mq.height * .15,
            left: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset("images/icon.png")),
        Positioned(
          bottom: mq.height * .15,
          width: mq.width,
          child: Text(
            "Developed by M. Aman Khan 💖",
            textAlign: TextAlign.center,
            style: GoogleFonts.pacifico(
              // Change the font here
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
          ),
        )
      ]),
    );
  }
}
