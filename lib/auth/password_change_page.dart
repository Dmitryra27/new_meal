import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class PasswordChangePage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Enter your email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: emailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Password reset email sent!')),
                  );
                } on FirebaseAuthException catch (e) {
                  // Обработка ошибок
                  print(e.message);
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                  Theme.of(context).colorScheme.secondaryContainer),
              child: Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}
