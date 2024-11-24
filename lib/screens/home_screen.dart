import 'dart:io';

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
              childAspectRatio: 2 / 3,
            ),
            itemCount: files.length,
            itemBuilder: (ctx, index) {
              final file = files[index];
              return GestureDetector(
                onTap: () {
                  // Open reader screen with file
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReaderScreen(
                          htmlFilePath: file.filePath,
                          articleTitle: file.title),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Image.file(
                        File(
                            "/storage/emulated/0/Arti${file.coverImagePath}"), // Use the imagePath to load the image
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover, // Adjust the image to fit the box
                      ),
                      Expanded(
                        child: SizedBox(
                          height:
                              5, // This height will be ignored because of Expanded
                        ),
                      ),
                      Text(
                        file.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
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
