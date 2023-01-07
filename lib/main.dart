import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:reading/screens/books_screen.dart';
// import 'package:reading/services/book.dart';
// import 'models/book.dart';
// import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en', 'US')],
      path: 'assets/translations', // <-- change the path of the translation files 
      fallbackLocale: const Locale('ar',),
      child:const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  const BooksScreen(),
    );
  }
}

// class Books extends StatelessWidget {
//   const Books({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('books'),
//       ),
//       body: FutureBuilder<List<Book>>(
//         future: BookService().fetchBooks(http.Client()),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text('An error has occurred!'),
//             );
//           } else if (snapshot.hasData) {
//             return BooksList(photos: snapshot.data!);
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class BooksList extends StatelessWidget {
//   const BooksList({super.key, required this.photos});

//   final List<Book> photos;

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       reverse: false,
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       itemCount: photos.length,
//       itemBuilder: (context, index) {
//         return Container(
//           margin: const EdgeInsets.all(10),
//           child: CircleAvatar(
//             radius: 48, // Image radius
//             backgroundImage: NetworkImage(photos[index].thumbnailUrl),
//           ),
//         );
//       },
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: false,
//         backgroundColor: Colors.orange,
//         title: const Text(
//           'reading',
//           style: TextStyle(
//             fontSize: 20,
//             color: Colors.purple,
//           ),
//         ),
//       ),
//       body: const Center(
//         child: Text(
//           'child',
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
