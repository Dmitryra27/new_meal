import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../old_pages/profile_page_old_not_work.dart';
import 'food_page.dart';
class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({Key? key}) : super(key: key);
  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}
class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String _name = '22222';
  String _email = '22@22.22';
  String _phoneNumber = '222222';
/*
  @override
  void initState() {
    super.initState();
    _getUserData();
  }
*/
  Future<void> _updateUserData() async {
    try{
      if (_formKey.currentState!.validate()) {
        final docRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
        await docRef.set({
          'name': _name,
          'email': _email,
          'phoneNumber': _phoneNumber,
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
      }
    }catch(e){print('Error: $e');}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменение данных пользователя '),
      ),
      body: user == null
          ? const Center(child: Text('Please login to view your profile'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                onSaved: (value) => _phoneNumber = value!,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _updateUserData,
                child: const Text('Обновить профиль'),
              ),
              const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Переход на другую страницу
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePage(), // Замените SecondPage на имя вашей целевой страницы
                ),
              );
            },
            child: const Text('Перейти к профилю пользователя'),
          ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Переход на другую страницу
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FoodPage(), // Замените SecondPage на имя вашей целевой страницы
                    ),
                  );
                },
                child: const Text('Перейти На страницу Блюд'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
