import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/html_files_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HtmlFilesProvider()),
        ],
        child: MaterialApp(
          title: 'Arti',
          theme: ThemeData(
            colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: Colors.white,
              onPrimary: Color(0xFF202125),
              secondary: Color(0xFF3399FE),
              onSecondary: Color(0xFF202125),
              error: Colors.red,
              onError: Colors.white,
              surface: Color(0xFF303030),
              onSurface: Colors.white,
            ),
            useMaterial3: true,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => HomeScreen(),
            '/reader': (context) => PlaceholderScreen(title: 'Reader Screen'),
            '/fetch': (context) => PlaceholderScreen(title: 'Fetch Screen'),
          },
        ));
  }
}

class PlaceholderScreen extends StatelessWidget {
  //Constructor Declaration
  const PlaceholderScreen({super.key, required this.title});

  //Fields
  final String title;

  @override
  Widget build(BuildContext context) {
    // .build is called whenever the widget needs to be rendered or rebuilt
    return Scaffold(
      // scaffold = rusztowanie/szkielet
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('This is the $title.')),
    );
  }
}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Arti',
//       theme: ThemeData(
//         colorScheme: ColorScheme(
//           brightness: Brightness.dark,
//           primary: Colors.white,
//           onPrimary: Color(0xFF202125),
//           secondary: Color(0xFF3399FE),
//           onSecondary: Color(0xFF202125),
//           error: Colors.red,
//           onError: Colors.white,
//           surface: Color(0xFF303030),
//           onSurface: Colors.white,
//         ),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Arti'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final TextEditingController _controller = TextEditingController();
//   bool _isLoading = false;

//   // List to store the content widgets (text and images)
//   List<Widget> _contentWidgets = [];

//   // Function to fetch the website content
//   Future<void> _fetchWebsite(String url) async {
//     setState(() {
//       _isLoading = true;
//       _contentWidgets = []; // Clear previous content
//     });

//     try {
//       final response = await http.get(Uri.parse(url));

//       if (response.statusCode == 200) {
//         // Parse the HTML content of the website
//         var document = parse(response.body);

//         // Extract all paragraphs and images
//         List<Widget> contentWidgets = [];

//         var paragraphs = document.getElementsByTagName('p');
//         for (var paragraph in paragraphs) {
//           contentWidgets.add(Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               paragraph.text,
//               style: TextStyle(fontSize: 16),
//             ),
//           ));
//         }

//         var images = document.getElementsByTagName('img');
//         for (var img in images) {
//           var src = img.attributes['src'];
//           if (src != null) {
//             // Resolve relative URLs to absolute URLs
//             var imageUrl = Uri.parse(url).resolve(src).toString();

//             contentWidgets.add(Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Image.network(
//                 imageUrl,
//                 loadingBuilder: (BuildContext context, Widget child,
//                     ImageChunkEvent? loadingProgress) {
//                   if (loadingProgress == null) return child;
//                   return Center(
//                     child: CircularProgressIndicator(
//                       value: loadingProgress.expectedTotalBytes != null
//                           ? loadingProgress.cumulativeBytesLoaded /
//                               (loadingProgress.expectedTotalBytes ?? 1)
//                           : null,
//                     ),
//                   );
//                 },
//               ),
//             ));
//           }
//         }

//         setState(() {
//           _contentWidgets = contentWidgets;
//         });
//       } else {
//         setState(() {
//           _contentWidgets = [
//             Text("Failed to load website. ${response.statusCode}")
//           ];
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _contentWidgets = [Text("Error fetching website.")];
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         actions: <Widget>[
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: SizedBox(
//               width: 200,
//               child: TextField(
//                 controller: _controller,
//                 decoration: const InputDecoration(
//                   hintText: 'Search URL',
//                   border: InputBorder.none,
//                 ),
//                 onSubmitted: (value) {
//                   _fetchWebsite(value);
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : SingleChildScrollView(
//                 child: Column(
//                   children: _contentWidgets,
//                 ),
//               ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _fetchWebsite(_controller.text);
//         },
//         tooltip: 'Fetch Website',
//         child: const Icon(Icons.search),
//       ),
//     );
//   }
// }
