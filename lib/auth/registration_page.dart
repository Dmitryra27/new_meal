import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../pages/plofile_page.dart';
// final appState = Provider.of<AppState>(context);
class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Function to validate the email and password entered by the user
  bool validate() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return false;
    }

    // You can add more validation here based on your requirements

    return true;
  }

  // Function to register a new user with Firebase authentication
  void registerUser() async {
    if (validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Сохраняем email в Firestore
        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
          'email': _emailController.text.trim(),
        });
        // User registration successful, you can navigate to a new screen or show a success message
        //setEmailInAppState(_emailController.text.trim());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfilePage()));
      } catch (e) {
        // Handle registration errors, such as invalid email, weak password, etc.
        print("Error registering user: $e");
      }
    } else {
      // Show an error message to the user for invalid input
      print("Invalid email or password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerUser,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
