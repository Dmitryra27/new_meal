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
          primary : const Color(0xFF3F51B5),//Color(0xFF1E88E5);
          secondary : const Color(0xFFF5F5F5),//Color(0xFFFFF176);
          surface: Color(0xFFFFFFFF),
          background: Color(0xFFEEEEEE),
          onPrimary:  Color(0xFFFFFFDE),
          onSecondary:   Color(0xFF000000),
          onError:    Color(0xFF000000),
          onSurface:     Color(0xFF000000),
          outline:        Color(0xFF000000),
          shadow:         Color(0xFF000000),
          inverseSurface: Color(0xFF000000),
          error: Color(0xFFB00020),
          primaryContainer: Color(0xFFBBDEFB),
          secondaryContainer: Color(0xFF90CAF9),
          tertiaryContainer: Color(0xFF7CB342),
          onSecondaryFixed: const Color(0xFFCFD8DC),//для кнопок
          brightness: Brightness.light,


        ),
        // Дополнительные стили
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2196F3), // Blue color -
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary, // Использование вторичного цвета из ColorScheme
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,

      home: const HomePage(),

    );
  }
}
