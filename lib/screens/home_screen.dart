import 'dart:io';
import 'package:arti/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/html_files_provider.dart';
import 'reader_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Library')),
      body: FutureBuilder(
        future: context.read<HtmlFilesProvider>().loadFiles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final files = context.watch<HtmlFilesProvider>().files;
          return RefreshIndicator(
            onRefresh: () async {
              await context.read<HtmlFilesProvider>().loadFiles();
            },
            child: files.isEmpty
                ? ListView(
                    children: [
                      Center(child: Text('No files saved.')),
                    ],
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: files.length,
                    itemBuilder: (ctx, index) {
                      final file = files[index];
                      return GestureDetector(
                        onTap: () {
                          // Open reader screen with file
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReaderScreen(
                                htmlFilePath: file.filePath,
                                articleTitle: file.title,
                              ),
                            ),
                          );
                        },
                        onLongPress: () async {
                          // Remove file and metadata entry
                          final storageService = StorageService();
                          await storageService
                              .removeFileAndMetadata(file.filePath);
                          Fluttertoast.showToast(
                            msg: "File removed.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Image.file(
                                    File(
                                        "/storage/emulated/0/Arti${file.coverImagePath}"), // Use the imagePath to load the image
                                    fit: BoxFit
                                        .cover, // Adjust the image to fit the box
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Icon(
                                        Icons.broken_image,
                                        size: 100,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                file.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to fetch screen
          Navigator.pushNamed(context, '/fetch');
        },
        child: Icon(Icons.add),
        tooltip: 'Fetch new content',
      ),
    );
  }
}
