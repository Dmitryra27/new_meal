import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:new_meal/pages/home_page.dart';
import '../firebase_options.dart';

Future<void> main() async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Люблю вкусно поесть !',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3949AB), // Primary color - заголовок страниц
          brightness: Brightness.light,
          secondary: Colors.green,
          error: Colors.red,
        ),
        // Дополнительные стили
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3), // Blue color -
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFBC02D), // Yellow color
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,

      home: const HomePage(),

    );
  }
}
