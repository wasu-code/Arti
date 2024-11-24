import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/html_files_provider.dart';
import '../models/html_file_metadata.dart';

class FilesGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final filesProvider = Provider.of<HtmlFilesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Files'),
      ),
      body: FutureBuilder(
        future: filesProvider.loadFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final files = filesProvider.files;

          if (files.isEmpty) {
            return Center(child: Text('No files saved yet.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: files.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              final file = files[index];
              return FileGridItem(file: file);
            },
          );
        },
      ),
    );
  }
}

class FileGridItem extends StatelessWidget {
  final HtmlFileMetadata file;

  const FileGridItem({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/file_viewer', // Route to the file viewer
          arguments: file,
        );
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Display cover image or placeholder
            Expanded(
              child: file.coverImagePath.isNotEmpty
                  ? Image.file(
                      File(file.coverImagePath),
                      fit: BoxFit.cover,
                    )
                  : Icon(Icons.description, size: 48.0, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.title,
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    file.description,
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
