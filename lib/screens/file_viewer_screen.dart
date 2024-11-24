import 'package:flutter/material.dart';
import 'dart:io';

import '../models/html_file_metadata.dart';

class FileViewerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final file = ModalRoute.of(context)!.settings.arguments as HtmlFileMetadata;

    return Scaffold(
      appBar: AppBar(
        title: Text(file.title),
      ),
      body: FutureBuilder(
        future: File(file.filePath).readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading file.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(snapshot.data as String),
          );
        },
      ),
    );
  }
}
