import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DishPage extends StatefulWidget {
  final String dishId;
  const DishPage({Key? key, required this.dishId}) : super(key: key);
  @override
  _DishPageState createState() => _DishPageState();
}
class _DishPageState extends State<DishPage> {
  double userRating = 0;
  final List<String> comments = [];
  final List<String> reactions = [];
  final TextEditingController commentController = TextEditingController();
  String? selectedReaction;
  Map<String, dynamic>? dish;
  @override
  void initState() {
    super.initState();
  }
  Stream<DocumentSnapshot> fetchDishDetails() {
    return FirebaseFirestore.instance
        .collection('dishes')
        .doc(widget.dishId)
        .snapshots();
  }
  Stream<QuerySnapshot> fetchComments() {
    return FirebaseFirestore.instance
        .collection('reviews')
        .where('dishId', isEqualTo: widget.dishId)
        .snapshots();
  }
  void _submitComment() {
    if (commentController.text.isNotEmpty && selectedReaction != null) {
      FirebaseFirestore.instance.collection('reviews').add({
        'dishId': widget.dishId,
        'review': commentController.text,
        'reaction': selectedReaction,
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      commentController.clear();
      setState(() {
        comments.add(commentController.text);
        reactions.add(selectedReaction!);
        selectedReaction = null;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: fetchDishDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Загрузка...');
            }
            if (!snapshot.hasData) {
              return const Text('Ошибка загрузки');
            }
            dish = snapshot.data!.data() as Map<String, dynamic>?;
            return Text(dish?['name'] ?? 'Блюдо');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: new SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: fetchDishDetails(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('Ошибка загрузки блюда'));
                }
                dish = snapshot.data!.data() as Map<String, dynamic>?;
                return Flexible(
                  child: Image.network(
                    dish!['imageUrl'],
                    fit: BoxFit.cover,
                    width: 400,
                    height: 400, // Ограничение высоты до 600 px
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            Text(
              dish?['name'] ?? '',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(dish?['receipt'] ?? ''),
            SizedBox(height: 20),
            Text('Ваш отзыв:', style: TextStyle(fontSize: 18)),
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                labelText: 'Введите комментарий',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              hint: Text('Выберите реакцию'),
              value: selectedReaction,
              items: ['❤️', '👍', '😋', '😢', '🤢']
                  .map((reaction) => DropdownMenuItem(
                value: reaction,
                child: Text(reaction),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedReaction = value;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitComment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: Text('Отправить комментарий'),
            ),
            SizedBox(height: 20),
            Text('Комментарии:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: fetchComments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Ошибка загрузки комментариев'));
                  }
                  final commentDocs = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: commentDocs.length,
                    itemBuilder: (context, index) {
                      final doc = commentDocs[index];
                      String review = doc['review'] ?? '';
                      //String reaction = doc.data().containsKey('reaction') ? doc['reaction'] : '';
                      String reaction = index < reactions.length ? reactions[index] : '';
                      return ListTile(
                        title: Text(review),
                        subtitle: Text(reaction),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
