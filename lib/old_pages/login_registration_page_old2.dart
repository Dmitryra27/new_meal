import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class LoginRegistrationPage extends StatefulWidget {
  const LoginRegistrationPage({Key? key}) : super(key: key);
  @override
  State<LoginRegistrationPage> createState() => _LoginRegistrationPageState();
}
class _LoginRegistrationPageState extends State<LoginRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoggingIn = true;
  Future<String> fetchApiKey() async {
    // Replace 'YOUR_PROJECT_ID' and 'YOUR_SECRET_NAME' with your actual values
    final url = Uri.parse('https://secretmanager.googleapis.com/v1/projects/YOUR_PROJECT_ID/secrets/YOUR_SECRET_NAME:access');
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['payload']['data'];
    } else {
      throw Exception('Failed to fetch API key');
    }
  }
  Future<UserCredential> login(String email, String password) async {
    final apiKey = await fetchApiKey();
    return await FirebaseAuth.instanceFor(apiKey: apiKey, app: null).signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  Future<UserCredential> register(String email, String password) async {
    final apiKey = await fetchApiKey();
    return await FirebaseAuth.instanceFor(apiKey: apiKey).createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLoggingIn ? 'Login' : 'Register'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_isLoggingIn) {
                      _handleLogin();
                    } else {
                      _handleRegister();
                    }
                  }
                },
                child: Text(_isLoggingIn ? 'Login' : 'Register'),
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoggingIn = !_isLoggingIn;
                  });
                },
                child: Text(_isLoggingIn ? 'Don\'t have an account? Register' : 'Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _handleLogin() async {
    try {
      await login(_emailController.text, _passwordController.text);
      // Navigate to home page or other relevant page
    } catch (e) {
      // Handle login error
    }
  }
  Future<void> _handleRegister() async {
    try {
      await register(_emailController.text, _passwordController.text);
      // Navigate to login page or other relevant page
    } catch (e) {
      // Handle registration error
    }
  }
}
