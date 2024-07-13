import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_meal/auth/profile_page.dart';
import '../auth/login_page.dart';

//Попадаем с Main, проверяем авторизацию,
//если не авторизован - то LoginPage,
//если авторизован - то FoodPage
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Произошла ошибка'),
          );
        } else if (snapshot.hasData) {
          // Пользователь авторизован
          return ProfilePage();
        } else {
          // Пользователь не авторизован
          return LoginPage();
        }
      },
    );
  }
}
