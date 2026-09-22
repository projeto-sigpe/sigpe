import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:sigpe/views/home.dart';

void main(){
  runApp(DevicePreview(builder: (context) => App()));
}


class SigpeApp extends StatelessWidget {
  const SigpeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIGPE',
      home: const LoginPage(),
    );
  }
}