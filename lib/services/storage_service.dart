import 'dart:io';
import 'dart:typed_data';
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
  Future<void> saveMetadata(List<HtmlFileMetadata> metadataList) async {
    final dir = await getAppDirectory();
    final metadataFile = File('${dir.path}/$metadataFileName');
    List<HtmlFileMetadata> existingMetadata = [];

    // Read existing metadata if the file exists
    if (await metadataFile.exists()) {
      final jsonString = await metadataFile.readAsString();
      final jsonList = jsonDecode(jsonString) as List;
      existingMetadata =
          jsonList.map((json) => HtmlFileMetadata.fromJson(json)).toList();
    }

    // Add new metadata entries
    existingMetadata.addAll(metadataList);

    // Write the updated metadata back to the file
    final updatedJsonString =
        jsonEncode(existingMetadata.map((e) => e.toJson()).toList());
    await metadataFile.writeAsString(updatedJsonString);
  }

  // Load metadata
  Future<List<HtmlFileMetadata>> loadMetadata() async {
    final dir = await getAppDirectory();
    final metadataFile = File('${dir.path}/$metadataFileName');
    if (!metadataFile.existsSync()) {
      print('No metadata file found');
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
    // Return relative path
    return '${fileName}.html';
  }

  // Load file content
  Future<String> loadHtmlFile(String filePath) async {
    File file;
    if (filePath.startsWith("/storage")) {
      //is absolute path
      file = File(filePath);
    } else {
      //is relative path
      final dir = await getAppDirectory();
      file = File(join(dir.path, filePath));
    }
    if (await file.exists()) {
      return await file.readAsString();
    }

    return 'no file found for path $filePath';
  }

  Future<void> saveImage(Uint8List imageData, String filename) async {
    final dir = await getAppDirectory();
    final imageFile = File('${dir.path}/$filename');
    await imageFile.writeAsBytes(imageData);
  }

  Future<File> loadImage(String imagePath) async {
    final directory = await getAppDirectory();
    final imageFullPath =
        join(directory.path, imagePath); // Create the full path
    return File(imageFullPath);
  }
}
