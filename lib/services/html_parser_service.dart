import 'package:arti/models/html_file_metadata.dart';
import 'package:arti/services/fetch_service.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:arti/services/storage_service.dart';

Future<String> parseHtml(String htmlContent, String baseUrl) async {
  final document = parse(htmlContent);

  // Replace <img> tags with data URLs
  for (var img in document.getElementsByTagName('img')) {
    final src = img.attributes['src'];
    if (src != null) {
      final imageUrl = Uri.parse(baseUrl).resolve(src).toString();
      try {
        final imageData = await fetchImageAsDataUrl(imageUrl);
        img.attributes['src'] = imageData;
      } catch (e) {
        img.remove(); // Remove image if it can't be fetched
      }
    }
  }

  return document.outerHtml;
}

Future<HtmlFileMetadata> parseMetadata(
    String htmlContent, String filePath) async {
  final document = parse(htmlContent);

  // Extract title
  final titleElement = document.querySelector('title');
  final title = titleElement != null ? titleElement.text : 'no_title';

  // Extract meta description
  final metaDescriptionElement =
      document.querySelector('meta[name="description"]');
  final description = metaDescriptionElement != null
      ? metaDescriptionElement.attributes['content']
      : 'N/A';

  // Extract categories (assuming categories are in meta tags with name="category")
  final categoryElements = document.querySelectorAll('meta[name="category"]');
  final categories = categoryElements
      .map((element) => element.attributes['content'] ?? '')
      .toList();

  // Extract OpenGraph image
  final ogImageElement = document.querySelector('meta[property="og:image"]');
  String? imagePath;
  if (ogImageElement != null) {
    final imageUrl = ogImageElement.attributes['content'];
    if (imageUrl != null) {
      final imageData = await fetchImage(imageUrl);
      final storage = StorageService();
      final filename = '${Uuid().v4()}.jpg';
      await storage.saveImage(imageData, filename);
      imagePath = '/$filename';
    }
  }

  return HtmlFileMetadata(
    title: title,
    description: description ?? 'N/A',
    categories: categories,
    filePath: filePath,
    coverImagePath: imagePath ?? '/test.png',
  );
}

Future<String> fetchImageAsDataUrl(String url) async {
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final mimeType = response.headers['content-type'] ?? 'image/jpeg';
    final base64Data = base64Encode(response.bodyBytes);
    return 'data:$mimeType;base64,$base64Data';
  } else {
    throw Exception('Failed to fetch image from $url');
  }
}
