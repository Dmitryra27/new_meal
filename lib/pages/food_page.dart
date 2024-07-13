import 'package:flutter/material.dart';

import 'dish_page.dart';

class FoodPage extends StatelessWidget {
  const FoodPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Страница выбора Блюд'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Выберите блюда",
            style: TextStyle(fontSize: 30, color: Colors.green),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DishPage(dishName: 'Breakfast',),
                ),
              );
            },
            child: Text(
              "Завтрак",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 30,),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DishPage(dishName: 'Soup',),
                ),
              );
            },
            child: Text(
              "Первое блюдо",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 30,),
        ],
      ),
    );
  }
}
