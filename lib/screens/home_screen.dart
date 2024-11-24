import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Library')),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/reader');
            },
            child: Card(
              elevation: 5,
              child: Center(
                child: Text(
                  'File ${index + 1}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        },
        itemCount: 6, // Dummy items for now
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/fetch');
        },
        child: Icon(Icons.add),
        tooltip: 'Fetch new content',
      ),
    );
  }
}
