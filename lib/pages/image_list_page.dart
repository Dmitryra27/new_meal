import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class ImageListPage extends StatefulWidget {
  const ImageListPage({super.key});

  @override
  _ImageListPageState createState() => _ImageListPageState();
}
class _ImageListPageState extends State<ImageListPage> {
  List<Map<String, dynamic>> dishes = [];
  @override
  void initState() {
    super.initState();
    fetchDishesFromFirebase();
  }
  Future<void> fetchDishesFromFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('dish')
          .where('alias', isEqualTo: 'soup')
          .get();
      setState(() {
        dishes = snapshot.docs.map((doc) => doc.data()).toList();
      });
    }
  }
  Future<Uint8List?> fetchImageFromStorage(String imageUrl) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      final bytes = await storageRef.getData();
      return bytes;
    } catch (e) {
      print('Error fetching image: $e');
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dish List'),
      ),
      body: ListView.builder(
        itemCount: dishes.length,
        itemBuilder: (context, index) {
          final dish = dishes[index];
          return ListTile(
            leading: FutureBuilder<void>(
              future: fetchImageFromStorage(dish['imageUrl']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Image.network(dish['imageUrl']);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            title: Text(dish['name']),
            subtitle: Text(dish['receipt']),
          );
        },
      ),
    );
  }
}
