import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  @override
  void initState() {
    super.initState();
    _getUserData();
  }
  Future<void> _getUserData() async {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    final doc = await docRef.get();
    if (doc.exists) {
      setState(() {
        _name = doc.data()!['name'];
        _email = doc.data()!['email'];
        _phoneNumber = doc.data()!['phoneNumber'];
      });
    }
  }
  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      await docRef.set({
        'name': _name,
        'email': _email,
        'phoneNumber': _phoneNumber,
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
