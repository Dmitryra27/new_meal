import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; // Для работы с Uint8List
import 'dart:html' as html; // Для работы с файлами в вебе



class AdminDishesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dish Registration',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DishRegistrationPage(),
    );
  }
}

class DishRegistrationPage extends StatefulWidget {
  @override
  _DishRegistrationPageState createState() => _DishRegistrationPageState();
}
class _DishRegistrationPageState extends State<DishRegistrationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  String? _imageUrl;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _receiptController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  double? _stars;
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Если мы на вебе, используем Uint8List
      if (html.window.navigator.userAgent.contains('Mozilla')) {
        // Для веба
        final byteData = await pickedFile.readAsBytes(); // Замените на правильное получение байтов
        await _uploadImage(byteData, pickedFile.name);
      } else {
        // Для мобильных устройств
        final imageFile = File(pickedFile.path);
        final byteData = await imageFile.readAsBytes(); // Используйте await для получения байтов
        await _uploadImage(byteData, pickedFile.name);
      }
    }
  }
  Future<void> _uploadImage(Uint8List imageData, String fileName) async {
    try {
      // Используем имя файла, чтобы сохранить в Firebase Storage
      Reference ref = _storage.ref().child('dishes/$fileName');
      UploadTask uploadTask = ref.putData(imageData);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      _imageUrl = downloadUrl;
      _addDish();
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _addDish() async {
    if (_imageUrl != null) {
      try {
        await _firestore.collection('dishes').add({
          'name': _nameController.text,
          'receipt': _receiptController.text,
          'image': _imageUrl,
          'ingredients': _ingredientsController.text,
          'stars': _stars,
        });
        setState(() {
          _nameController.clear();
          _receiptController.clear();
          _ingredientsController.clear();
          _stars = null;
          _imageUrl = null;
        });
      } catch (e) {
        print('Error adding dish: $e');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register Dish')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _receiptController,
              decoration: InputDecoration(labelText: 'Receipt'),
            ),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredients'),
            ),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Stars (0-5)'),
              onChanged: (value) {
                _stars = double.tryParse(value);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Pick Image'),
            ),
            if (_imageUrl != null)
              Image.network(_imageUrl!, height: 150, width: 150),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addDish,
              child: Text('Submit Dish'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('dishes').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var dishes = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: dishes.length,
                    itemBuilder: (context, index) {
                      var dish = dishes[index];
                      return ListTile(
                        title: Text(dish['name']),
                        subtitle: Row(
                          children: [
                            Text('Ingredients: ${dish['ingredients']}'),
                            SizedBox(width: 10), // Отступ между текстом и изображением
                            if (dish['image'] != null)
                              Image.network(dish['image'], height: 150, width: 150), // Изображение из Firestore
                          ],
                        ),
                        trailing: Text('Stars: ${dish['stars']}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
