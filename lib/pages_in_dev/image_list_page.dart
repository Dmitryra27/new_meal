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

  Future<String> _getDownloadURL(String filePath) async {
    try {
      //final url = 'https://firebasestorage.googleapis.com/v0/b/new-meal-7df05.appspot.com/o/$filePath?alt=media&token=$accessToken';
      //final ref = _storage.ref(filePath);
      //final downloadURL = await ref.getDownloadURL();
      return filePath;//downloadURL;
    } catch (error) {
      print('ERROR in function _getDownloadURL:$error');
      return '';
    }
  }
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
              print('Acceess-token: ${data["token"]} ');

              return data['imageUrl'];
            }).toList();
            return ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                final image = images[index];
                if (image != null) {
                  return FutureBuilder<String>(
                    future: _getDownloadURL(image, ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        print('От это подаем на вход Image.network :$snapshot.data!');
                        return Image.network(snapshot.data!);
                        //return Text(snapshot.data!,);
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
