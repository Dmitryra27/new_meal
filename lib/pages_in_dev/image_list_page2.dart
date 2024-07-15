import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class ImageListScreen extends StatefulWidget {
  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}
class _ImageListScreenState extends State<ImageListScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;



  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список изображений'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('dish').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final images = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>; // Приведение к типу
              print(data["name"]);
              print(data["imageUrl"]);
              return data['imageUrl'];
            }).toList();
            return ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                if (image != null) {
                  return FutureBuilder<String>(
                    future: _storage.refFromURL(image).getDownloadURL(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.network(snapshot.data!);
                      } else if (snapshot.hasError) {
                        return Text('Ошибка: ${snapshot.error}');
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  );
                } else {
                  return Text('Ошибка: изображение не найдено');
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text('Ошибка: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
