import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  String userId = DateTime.now().millisecondsSinceEpoch.toString();
  String userName = DateTime.now().toString();
  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 539079675, 
      appSign: "e56738ae25a8db4fa8b5b2d7045a4629fc63bfb41b1c4d4173fa7fb35152925d", 
      callID: 'demo_call_id_for_testing', 
      userID: userId, 
      userName: userName, 
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
      );
  }
}