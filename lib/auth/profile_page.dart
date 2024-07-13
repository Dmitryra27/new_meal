import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_meal/auth/profile_update_page.dart';

import '../pages/food_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  //final _firestore = FirebaseFirestore.instance;
  //DocumentReference? _userDoc;

  //final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
    _listenToUserData();
  }

  Future<void> _getUserData() async {
    final docRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final doc = await docRef.get();
    if (doc.exists) {
      setState(() {
        _name = doc.data()!['name'];
        _email = doc.data()!['email'];
        _phoneNumber = doc.data()!['phoneNumber'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User document not found')));
    }
  }

  void _listenToUserData() {
    //_userDoc = _firestore.collection('users').doc(user!.uid);
    final docRef =
    FirebaseFirestore.instance.collection('users').doc(user!.uid);
    //if (docRef != null) {
      docRef.snapshots().listen((snapshot) {
        if (snapshot.exists) {
          setState(() {
            _name = snapshot.data()!['name'];
            _email = snapshot.data()!['email'] ;
            _phoneNumber = snapshot.data()!['phoneNumber'] ;
          });
        }
      });
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Данные пользователя'),
      ),
      body: user == null
          ? const Center(child: Text('Please login to view your profile'))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Личные данные ',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Имя: $_name',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: $_email',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone: $_phoneNumber',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Переход на другую страницу
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProfileUpdatePage(), // Замените SecondPage на имя вашей целевой страницы
                        ),
                      );
                    },
                    child: const Text('Изменить данные пользователя'),
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
    );
  }
}
