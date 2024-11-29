import 'package:fanconnect_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(FanConnectApp());
}

class FanConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FanConnect',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
