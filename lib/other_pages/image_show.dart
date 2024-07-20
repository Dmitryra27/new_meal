import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
Future<void> ImageShow() async {
  final url = Uri.parse('https://firebasestorage.googleapis.com/v0/b/new-meal-7df05.appspot.com/o/borch.jpeg?alt=media&token=768bd158-2526-4fb3-ab77-08f24c9c0095');
  final response = await http.get(url);
  if (response.statusCode == 200) {
    print("Сервер вернул код 200");
    final bytes = response.bodyBytes;
    Image image = Image.memory(bytes);
    runApp(MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Изображение'),
        ),
        body: Center(
          child: image,
        ),
      ),
    ));
  } else {
    print('Ошибка: ${response.statusCode}');
  }
}
