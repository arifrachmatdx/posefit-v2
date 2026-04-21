import 'package:flutter/material.dart';
import 'list_gerakan_screen.dart';

class KategoriGerakanScreen extends StatelessWidget {
  const KategoriGerakanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Upper Body',
      'Lower Body',
      'Cardio',
      'Flexibility',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Gerakan'), centerTitle: true),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.fitness_center, color: Colors.blue),
              title: Text(categories[index]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ListGerakanScreen(category: categories[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
