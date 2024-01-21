import 'dart:io';

import 'package:chattingapp/api/api.dart';
import 'package:chattingapp/helper/dailogs.dart';
import 'package:chattingapp/main.dart';
import 'package:chattingapp/screens/home_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if(user != null){
        if((await APIs.userExists())){
          Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen()));
        }else{
          APIs.createUser().then((value){
           Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => HomeScreen())); 
          });
        }
      }
      
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
        // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
       print('\n_signInWithGoogle: $e');
       Dialogs.showSnackbar(context, '⚠️ Something went wrong please check Internet');
       return null;
    }
  }

  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 33, 33),
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Text(
          "Welcome to Pico Chat",
          style: GoogleFonts.pacifico(
            // Change the font here
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xffC33764),
                Color(0xff1D2671),
              ],
            ),
          ),
        ),
      ),
      body: Stack(children: [
        Positioned(
            top: mq.height * .15,
            left: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset("images/icon.png")),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Center(
            child: Container(
              width: 300,
              height: 65,
              decoration: const ShapeDecoration(
                shape: StadiumBorder(),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffC33764),
                    Color(0xff1D2671),
                  ],
                ),
              ),
              child: MaterialButton(
                child: Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: Row(
                    children: [
                      Image(
                        image: AssetImage("images/google.png"),
                        width: 22,
                        height: 22,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Login with Google',
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  _handleGoogleBtnClick();
                },
              ),
            ),
          ),
        )
      ]),
    );
  }
}
