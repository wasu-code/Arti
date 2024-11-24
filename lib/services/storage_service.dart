import 'dart:io';
import 'package:path/path.dart'; // Helps with path manipulation
import '../models/html_file_metadata.dart';
import 'dart:convert';

class StorageService {
  static const String metadataFileName = 'metadata.json';

  // Get the application's documents directory manually (platform-specific)
  Future<Directory> getAppDirectory() async {
    final directory = Directory('/storage/emulated/0/Arti'); // Android
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }

  // Save metadata
  Future<void> saveMetadata(List<HtmlFileMetadata> metadata) async {
    final dir = await getAppDirectory();
    final metadataFile = File('${dir.path}/$metadataFileName');
    final jsonString = jsonEncode(metadata.map((e) => e.toJson()).toList());
    await metadataFile.writeAsString(jsonString);
  }

  // Load metadata
  Future<List<HtmlFileMetadata>> loadMetadata() async {
    final dir = await getAppDirectory();
    final metadataFile = File('${dir.path}/$metadataFileName');
    if (!metadataFile.existsSync()) {
      return [];
    }
    final jsonString = await metadataFile.readAsString();
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((e) => HtmlFileMetadata.fromJson(e)).toList();
  }

  // Save file content
  Future<String> saveHtmlFile(String fileName, String content) async {
    final dir = await getAppDirectory();
    final file = File(join(dir.path, '$fileName.html'));
    await file.writeAsString(content);
    return file.path;
  }

  // Load file content
  Future<String> loadHtmlFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '';
  }
}
