import 'package:flutter/material.dart';
import 'package:recipe_hub/view/home_page.dart';
import 'package:recipe_hub/view/pages/api_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final prefs = snapshot.data;
            if (prefs!.getBool('init') ?? false) {
              return const HomeScreen();
            } else {
              return const ApiPage();
            }
          }
        },
      ),
    );
  }
}
