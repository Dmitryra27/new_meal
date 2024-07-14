import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DishPage extends StatefulWidget {
  final String dishName;

  const DishPage({Key? key, required this.dishName}) : super(key: key);

  @override
  State createState() => _DishPageState();
}

class _DishPageState extends State {
  // Получаем текущего пользователя
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Для хранения данных блюда
  Map? dishData;

  // Для хранения изображения
  String? imageUrl = 'https://firebasestorage.googleapis.com/v0/b/new-meal-7df05.appspot.com/o/borch.jpeg?alt=media&token=768bd158-2526-4fb3-ab77-08f24c9c0095';

  // Для хранения рейтинга
  double? rating;

   @override
  void initState() {
    super.initState();
    _fetchDishData();
  }

  Future _fetchDishData() async {
    // Получаем данные блюда из Firestore
    //var dishName;
    DocumentSnapshot dishDoc = await _firestore
        .collection('dish')
        .where('alias', isEqualTo: widget.key)
        .get()
        .then((snapshot) => snapshot.docs.first);
    setState(() {
      dishData = dishDoc.data() as Map;
      // Получаем ссылку на изображение из Firebase Storage
      _getImageUrl(dishData!['image']);
      //_getImageUrl(dishData!['imageUrl']);
    });
  }

  // Получаем ссылку на изображение из Firebase Storage
  Future _getImageUrl(String imageName) async {
    try {
     // String downloadUrl = await _storage//.ref('${imageUrl}');
     //     .ref('${imageName}'+'\\?'+'alt'+'\\='+'media'+'\\&'+'token'+'\\='+dishData!['token'])
      //    .getDownloadURL();
      setState(() {
        //imageUrl = {imageUrl} as String?;//downloadUrl;
        print('imageUrl:$imageUrl');
      });
    } catch (e) {
      print('Ошибка при получении изображения: $e');
    }
  }

  // Обновляем рейтинг
  Future _updateRating(double newRating) async {
    // Обновляем рейтинг в Firestore
    await _firestore
        .collection('dish')
        .doc(dishData!['id'])
        .update({'stars': newRating});
    setState(() {
      rating = newRating;
    });
  }

  // Добавляем оценку или эмодзи в коллекцию mark
  Future _addMark(String mark) async {
    await _firestore.collection('mark').add({
      'dishId': dishData!['id'],
      'userId': user!.uid,
      'mark': mark,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Блюдо: ${widget.key}',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
              fontFamily: "SF Pro Display",
            ),
          ),
        ),
        body: dishData != null
            ? SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Выводим изображение
                    imageUrl != null
                        ? Image.network(imageUrl!)
                        : const CircularProgressIndicator(),
                    const SizedBox(height: 16.0),
                    // Выводим информацию о блюде
                    Card(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dishData!['name'],
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Ингредиенты: ${dishData!['ingredients']}',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    'Рецепт: ${dishData!['receipt']}',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 8.0),
                                  // Выводим рейтинг
                                  Row(
                                    children: [
                                      const Icon(Icons.star),
                                      Text(
                                        '${dishData!['stars']}',
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      const SizedBox(height: 8.0),
                                    ],
                                  ),
                                  //if dishData != null else Container(),
                                ]
                            )
                        )
                    ),
                    const Divider(),
                    ElevatedButton(
                        onPressed: () => Navigator.pop<bool>(context, true),
                        child: const Text("Назад"),
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith((
                                states) => Colors.red[300]))),
                  ]
              )
          ),
        )
        : const Center(child: CircularProgressIndicator())

    );

  }
}

