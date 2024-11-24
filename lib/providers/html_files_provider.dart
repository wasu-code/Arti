import 'package:flutter/material.dart';
import '../models/html_file_metadata.dart';
import '../services/storage_service.dart';

class HtmlFilesProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  List<HtmlFileMetadata> _files = [];

  List<HtmlFileMetadata> get files => _files;

  Future<void> loadFiles() async {
    try {
      _files = await _storageService.loadMetadata();
      print("Loaded metadata: $_files");
      notifyListeners();
    } catch (e) {
      print("Error loading metadata: $e");
    }
  }

  //test (dummy data)
  // Future<void> loadFiles() async {
  //   _files = [
  //     HtmlFileMetadata(
  //       title: 'Sample File',
  //       description: 'This is a sample file.',
  //       filePath: '/path/to/file.html',
  //       coverImagePath: '',
  //       categories: ['Sample'],
  //     )
  //   ];
  //   notifyListeners();
  // }

  Future<void> addFile(HtmlFileMetadata metadata, String content) async {
    final filePath =
        await _storageService.saveHtmlFile(metadata.title, content);
    final newMetadata = metadata.copyWith(filePath: filePath);
    _files.add(newMetadata);
    await _storageService.saveMetadata(_files);
    notifyListeners();
  }
}
