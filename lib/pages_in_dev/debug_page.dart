import 'package:flutter/material.dart';

import '../admin_pages/admin_dishes.dart';

class DebugPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Debug Page')),
        body: Center(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width < 600
                      ? MediaQuery.of(context).size.width * 0.9
                      : 400,
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminDishesPage())),
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => Colors.blue[300])),
                        child: const Text("Админ Page")
                    ),
                    /* ElevatedButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageListPage())),
                        child: const Text("Image List Page"),
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.resolveWith(
                                (states) => Colors.blue[300]))
                                )
                    */
                  ]),
                ))));
  }
}
