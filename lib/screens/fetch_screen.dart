import 'package:arti/screens/reader_screen.dart';
import 'package:flutter/material.dart';
import '../services/fetch_service.dart';
import '../services/html_parser_service.dart';
import '../services/storage_service.dart';
import 'package:uuid/uuid.dart';

class FetchScreen extends StatefulWidget {
  @override
  _FetchScreenState createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _fetchAndRedirect(String url) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Fetch HTML content
      final htmlContent = await fetchHtmlFromUrl(url);

      // Parse and process HTML (replace images with data URLs)
      final parsedContent = await parseHtml(htmlContent, url);

      // Save the processed HTML content and generate metadata
      final storageService = StorageService();
      final uuid = Uuid();

      final fileName = uuid.v4(); // Generates a unique GUID.
      final filePath =
          await storageService.saveHtmlFile(fileName, parsedContent);
      final fileMetadata = await parseMetadata(htmlContent, filePath);

      // Update metadata.json
      await storageService.saveMetadata([fileMetadata]);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReaderScreen(
            htmlFilePath: filePath,
            articleTitle: fileMetadata.title,
          ),
          settings: RouteSettings(arguments: fileMetadata),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch HTML Content'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Enter URL',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final url = _urlController.text.trim();
                if (url.isNotEmpty) {
                  _fetchAndRedirect(url);
                } else {
                  setState(() {
                    _errorMessage = 'URL cannot be empty';
                  });
                }
              },
              child: const Text('Fetch and View'),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator(),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
