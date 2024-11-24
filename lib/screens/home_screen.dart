import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/html_files_provider.dart';
import '../models/html_file_metadata.dart';
import 'reader_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Library')),
      body: FutureBuilder(
        future: context.read<HtmlFilesProvider>().loadFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final files = context.watch<HtmlFilesProvider>().files;
          if (files.isEmpty) {
            return Center(child: Text('No files saved.'));
          }
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 3 / 2,
            ),
            itemCount: files.length,
            itemBuilder: (ctx, index) {
              final file = files[index];
              return GestureDetector(
                onTap: () {
                  // Open reader screen with file
                  // Navigator.pushNamed(context, '/reader');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReaderScreen(htmlFilePath: file.filePath),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        file.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        file.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to fetch screen
          Navigator.pushNamed(context, '/fetch');
        },
        child: Icon(Icons.add),
        tooltip: 'Fetch new content',
      ),
    );
  }
}
