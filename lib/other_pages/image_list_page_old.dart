import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ImageListScreen extends StatefulWidget {
  @override
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  final _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
 

  @override
  void initState(){
    super.initState();
    print("Init state");    //futureImages = getDishImageFromFirebase(_alias);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Список изображений из Dish'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('dish').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final images = snapshot.data!.docs.map((doc)
            {
              final data = doc.data() as Map<String, dynamic>; // Приведение к типу
              print(data["name"]);
                return data['imageUrl'];

            }
            ).toList();
            return ListView.builder(
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Image.network(images[index]);

                //return Image.network(images[index]);
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
