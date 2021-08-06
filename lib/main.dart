import 'package:flutter/material.dart';
import 'package:gitusers/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github Users',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: HomeScreen(),
      // routes: {
      //   HomeScreen.routeName: (ctx) => HomeScreen(),
      // },
      debugShowCheckedModeBanner: false,
    );
  }
}
