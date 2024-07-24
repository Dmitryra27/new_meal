import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dish_page.dart'; // Добавьте импорт DishPage

class ImageListPage extends StatefulWidget {
  final String alias; // Параметр alias для фильтрации блюд
  const ImageListPage({Key? key, required this.alias}) : super(key: key);
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
          .collection('dishes')
          .where('alias', isEqualTo: widget.alias)
          .get();
      setState(() {
        dishes = snapshot.docs.map((doc) {
          // Добавляем id документа в данные блюда
          final data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id; // Добавляем идентификатор документа к данным
          return data;
        }).toList();
        //print('Dishes - Ok:$dishes');
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
        title: Text('Блюда: ${widget.alias}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: dishes.length,
                itemBuilder: (context, index) {
                  final dish = dishes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: FutureBuilder<void>(
                        future: fetchImageFromStorage(dish['imageUrl']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            return Image.network(dish['imageUrl'], width: 50, height: 50, fit: BoxFit.cover);
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      title: Text(dish['name']),
                      subtitle: Text(dish['description']),

                      onTap: () {
                        // Переход на страницу DishPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DishPage(dishId: dish['id'] ?? ''),//'Pu7FgXlN3EZbLfbWBM1r'),//
                          ),
                        );
                      },
                    ),
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
