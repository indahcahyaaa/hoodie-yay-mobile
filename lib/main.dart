import 'package:flutter/material.dart';
import 'package:hoodie_yay/menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.pink,
        ).copyWith(secondary: const Color(0xFF484C7F)),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    ); 
  }
}
