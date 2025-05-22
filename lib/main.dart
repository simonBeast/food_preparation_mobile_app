import 'package:flutter/material.dart';
import 'package:food_preparation/pages/home_screen.dart';
import 'package:food_preparation/util/My_Drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:food_preparation/data/recipes.dart';
void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void setIsDarkMode(){
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking Fun',
        theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: Colors.white)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark: ThemeMode.light  ,
      home: HomeScreen(
        isDarkMode: isDarkMode,
        setIsDarkMode: setIsDarkMode,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}




