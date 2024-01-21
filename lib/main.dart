import 'package:chattingapp/firebase_options.dart';
import 'package:chattingapp/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

late Size mq;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initailizeFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

_initailizeFirebase() async {
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'pico',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Pico Chats',
);
print("/nNotification channel result: $result");
}