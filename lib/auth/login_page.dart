import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_meal/auth/password_change_page.dart';
import 'package:new_meal/auth/registration_page.dart';
import 'package:new_meal/pages/food_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigate to the next page upon successful sign in
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => FoodPage()));
    } catch (e) {
      // Handle sign in errors
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Ошибка Авторизации'),
            content: Text('Попробуйте еще раз.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Зарегистрироваться'),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationPage()));
                },
              ),
            ],
          );
        },
      );
    }
  }
  /*#3F51B5 - фиолетовый
  * #E91E63 — насыщенный розовый цвет, который добавит энергии и выразительности.
#03A9F4 — яркий голубой цвет, который создаст приятный градиент с основным синим цветом.
#FFEB3B — светлый желтый цвет, который добавит яркости и жизнерадостности.
#F5F5F5 — светло-серый цвет для фонов, который обеспечит хорошую читаемость и легкость восприятия
  * */
  final Color primaryColor = Color(0xFF3F51B5);//Color(0xFF1E88E5);
  final Color secondaryColor = Color(0xFFF5F5F5);//Color(0xFFFFF176);
  final Color accentColor = Color(0xFFE91E63);
  final Color yellowColor = Color(0xFFFFEB3B);
  final Color whiteBlueColor = Color(0xFF03A9F4);//Color(0xFFAB47BC);
  final Color textColor = Color(0xFF212121);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: whiteBlueColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width < 600
                ? MediaQuery.of(context).size.width * 0.9
                : 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Вход в систему',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _signIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Войти',
                    style: TextStyle(fontSize: 16, color: Colors.white, ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PasswordChangePage()),
                    );
                  },
                  child: Text(
                    'Забыли пароль?',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*
// Не забудьте создать класс ProfilePage и RegistrationPage
class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile Page')),
      body: Center(child: Text('Welcome to Profile Page!')),
    );
  }
}
class RegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration Page')),
      body: Center(child: Text('Welcome to Registration Page!')),
    );
  }
}
*
 */
