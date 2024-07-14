import 'package:flutter/material.dart';

class DishPage extends StatelessWidget {
  final String dishName;
  const DishPage({Key? key, required this.dishName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Страница подбора блюд внутри категории',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
                fontFamily: "SF Pro Display",
              )),
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Условный рендеринг в зависимости от dishName
            if (dishName == 'Breakfast')
              Image.asset('../../assets/images/breakfast1.jpg',
                height: 200, // Установите желаемую высоту
                width: 300, )
            else if (dishName == 'Soup')
              Image.asset('../../assets/images/borch.jpeg',
                height: 200, // Установите желаемую высоту
                width: 300, )
            else
              Text('Изображение для $dishName не найдено.'),
            SizedBox(height: 20),
            Text(
              'Блюдо: $dishName',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
