import 'package:flutter/material.dart';
import 'package:worldskill_module1/pages/homePage.dart';

void main() {
  runApp(const MyApp(home: HomePage(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,required this.home});
  final Widget home;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WorldSkill Module',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}

