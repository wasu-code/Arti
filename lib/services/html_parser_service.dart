import 'package:arti/models/html_file_metadata.dart';
import 'package:arti/services/fetch_service.dart';
import 'package:html/parser.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:arti/services/storage_service.dart';

final MIN_IMAGE_DIMENSION = 250;

Future<String> parseHtml(String htmlContent, String baseUrl) async {
  final document = parse(htmlContent);

  // Focus on the main content by targeting specific tags
  final mainContent = document
      .body; // alternatively <article>?, not all websites abide by this though

  if (mainContent == null) {
    return '';
  }

  // Remove unnecessary elements like navbars, footers, and ads
  final elementsToRemove = mainContent.querySelectorAll(
      'nav, footer, aside, noscript, .sidebar, .ad, [role="navigation"], [role="banner"], [role="complementary"]');
  for (var element in elementsToRemove) {
    element.remove();
  }

  // Process images
  for (var img in mainContent.getElementsByTagName('img')) {
    final src = img.attributes['src'];
    if (src != null) {
      final imageUrl = Uri.parse(baseUrl).resolve(src).toString();

      // Filter out likely decorative images and icons based on attributes
      final width = int.tryParse(img.attributes['width'] ?? '');
      final height = int.tryParse(img.attributes['height'] ?? '');
      if ((width != null && width < MIN_IMAGE_DIMENSION) ||
          (height != null && height < MIN_IMAGE_DIMENSION)) {
        img.remove();
        continue;
      }

      try {
        final imageData = await fetchImageAsDataUrl(imageUrl);
        img.attributes['src'] = imageData;
      } catch (e) {
        img.remove(); // Remove image if it can't be fetched
      }
    } else {
      img.remove(); // Remove images without a valid src
    }
  }

  // Remove scripts and styles
  mainContent
      .querySelectorAll('script, style')
      .forEach((element) => element.remove());

  return mainContent.outerHtml;
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

  // Extract cover image
  String? imageUrl;

  // Try getting the image URL from Open Graph meta tag
  final ogImageElement = document.querySelector('meta[property="og:image"]');
  if (ogImageElement != null) {
    imageUrl = ogImageElement.attributes['content'];
  }

  // If Open Graph image is not found, check for the meta image tag
  if (imageUrl == null) {
    final metaImageElement = document.querySelector('meta[name="image"]');
    if (metaImageElement != null) {
      imageUrl = metaImageElement.attributes['content'];
    }
  }

  // If no image URL found in meta tags, check the first image on the page
  if (imageUrl == null) {
    final firstImageElement = document.querySelector('img[src]');
    if (firstImageElement != null) {
      imageUrl = firstImageElement.attributes['src'];
    }
  }

  // Fetch image
  String? imagePath;
  if (imageUrl != null) {
    try {
      final resolvedImageUrl = Uri.parse(filePath).resolve(imageUrl).toString();
      final storage = StorageService();
      final uuid = Uuid();
      final imageFileName = uuid.v4();
      final coverImage = await fetchImage(resolvedImageUrl);
      imagePath = await storage.saveImage(coverImage, imageFileName);
    } catch (e) {
      imagePath = null;
    }
  }

  return HtmlFileMetadata(
    title: title,
    description: description ?? 'N/A',
    categories: categories,
    filePath: filePath,
    coverImagePath: '/$imagePath',
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
