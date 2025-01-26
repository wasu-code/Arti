import 'dart:typed_data';

import 'package:http/http.dart' as http;

Future<String> fetchHtmlFromUrl(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load content from $url');
  }
}

Future<Uint8List> fetchImage(String imageUrl) async {
  final response = await http.get(Uri.parse(imageUrl));
  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to download image from $imageUrl');
  }
}
