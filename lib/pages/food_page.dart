import 'package:flutter/material.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Страница выбора Блюд'),
      ),
      body: const Center(
        child: Text('Пора отведать вкусненького !'),
      ),
    );
  }
}
