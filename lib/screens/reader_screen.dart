import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html_2/flutter_html_2.dart';

import '../services/storage_service.dart';
// import 'package:provider/provider.dart';
// import '../providers/html_files_provider.dart';
// import '../models/html_file_metadata.dart';

class ReaderScreen extends StatelessWidget {
  final String htmlFilePath;
  final String? articleTitle;

  const ReaderScreen(
      {super.key, required this.htmlFilePath, this.articleTitle});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadHtmlContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(articleTitle ?? "Reader"),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(articleTitle ?? "Reader"),
            ),
            body: Center(child: Text('Error loading file: ${snapshot.error}')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(articleTitle ?? "no_title"),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Html(
                data: snapshot.data!,
                style: {
                  "body": Style(
                    fontSize: FontSize.large,
                  ),
                },
              ),
            ),
          );
        }
      },
    );
  }

  Future<String> _loadHtmlContent() async {
    final StorageService _storageService = StorageService();
    return await _storageService.loadHtmlFile(htmlFilePath);
  }
}
