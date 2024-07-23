import 'package:flutter/material.dart';
import '../pages/image_list_page.dart';
import '../pages_in_dev/debug_page.dart';


class FoodPage extends StatelessWidget {
  FoodPage({Key? key}) : super(key: key);

  // Определение цветов
  final Color primaryColor = Color(0xFF3F51B5);
  final Color secondaryColor = Color(0xFFF5F5F5);
  final Color accentColor = Color(0xFFE91E63);
  final Color yellowColor = Color(0xFFFFEB3B);
  final Color whiteBlueColor = Color(0xFF03A9F4);
  final Color textColor = Color(0xFF212121);
  final Color buttomColor = Color(0xFFA1887F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Страница выбора Блюд - FoodPage'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        color: secondaryColor, // Фон для всей страницы
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Выберите, что вы хотите съесть!",
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                _buildMenuButton(context, 'Салат', isSalad: true,alias:'salad' ),
                _buildMenuButton(context, 'Первые блюда',  isSoup: true, alias: 'soup'),
                _buildMenuButton(context, 'Debug Page',  isDebugPage: true, alias: 'soup'),
                //_buildMenuButton(context, 'Admin Dishes', null, isAdmin: true),
                //
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title,
      {bool isAdmin = false,
      bool isImageList = false,
      bool isSalad = false,
      bool isSoup = false,
      bool isDebugPage = false,
      required String alias}
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        width: double.infinity, // Занять всю ширину
        child: ElevatedButton(
          onPressed: () {
            if (isSalad) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ImageListPage(alias: 'salad')));
            } else if (isSoup) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ImageListPage(
                            alias: 'soup',
                          )));
            } else if (isDebugPage) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DebugPage()));
            } else {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DebugPage()));
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.secondaryContainer, // Цвет кнопки
            padding: const EdgeInsets.symmetric(vertical: 15.0),
          ),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, color: textColor),
          ),
        ),
      ),
    );
  }
}
