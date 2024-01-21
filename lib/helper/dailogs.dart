import 'package:flutter/material.dart';

class Dialogs {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent, // Set background color to transparent
        elevation: 0, // Remove shadow
        behavior: SnackBarBehavior.floating, // Make the snackbar float above the bottom sheet
        duration: Duration(seconds: 3), // Set the duration of the snackbar
        animation: CurvedAnimation(
          parent: AlwaysStoppedAnimation<double>(1),
          curve: Interval(0.75, 1.0, curve: Curves.easeOut), // Exit animation curve
        ),
        content: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xffC33764).withOpacity(.8), 
              Color(0xff1D2671).withOpacity(.8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),  
          child: Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              msg,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
  static void showProgressBar(BuildContext context){
    showDialog(
      context: context, 
      builder: (_) => Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 224, 18, 128),))
      );
  }
}