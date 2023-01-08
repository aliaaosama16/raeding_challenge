import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'book_screen.dart';
import 'dart:math' as math;

enum Status { completed, inProgress, notCompleted }

class BooksScreen extends StatefulWidget {
  const BooksScreen({Key? key}) : super(key: key);

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  // files will be array of string to store all converted urls to pdf files
  String remotePDFpath = "";
  bool bookISReady = false;
  List<Map<String, dynamic>> books = [
    {
      'id': 1,
      'title': 'التصور العربي الشعبي',
      'image': "https://via.placeholder.com/150/771796",
      'status': Status.completed
    },
    {
      'id': 2,
      'title': 'البيان في تفسير علوم القرأن',
      'image': "https://via.placeholder.com/150/771796",
      'status': Status.completed
    },
    {
      'id': 3,
      'title': 'العدالة والحرية في فجر النهضة العربية الحديثة',
      'image': "https://via.placeholder.com/150/771796",
      'status': Status.notCompleted
    },
    {
      'id': 4,
      'title': 'الصراع على القمة',
      'image': "https://via.placeholder.com/150/771796",
      'status': Status.notCompleted
    },
  ];

  @override
  void initState() {
    _getBooks();
    super.initState();
    // api to get all books that attached to this student
    // call create for all files
    // allowed books only will be clickable
    createFileOfPdfUrl().then((f) {
      setState(() {
        if (f.path.isNotEmpty) {
          // ignore: avoid_print
          print('book is ready');
          bookISReady = true;
          remotePDFpath = f.path;
        } else {
          // ignore: avoid_print
          print('book is not ready');
          bookISReady = false;
        }
      });
    });
  }

  _getBooks() {
    //BookService().getBook().then((response) => {
    //var x= jsonDecode(response.body) ;
    // ignore: avoid_print
    // print(jsonResponse['data']['first_image']);
    // });
  }

  Future<File> createFileOfPdfUrl() async {
    Completer<File> completer = Completer();
    // ignore: avoid_print
    print("Start download file from internet!");
    try {
      const url = "https://app.egfarm.net/pdf/3.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      // ignore: avoid_print
      print("Download files");
      // ignore: avoid_print
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PDF View',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF295BB3),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.13,
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/icons/clock.png'),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '05:30',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'JanaRegular',
                              fontSize: 16),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/icons/flag.png'),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '03',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'JanaRegular',
                              fontSize: 16),
                        )
                      ],
                    ),
                    Image.asset('assets/icons/profile.png'),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              height: MediaQuery.of(context).size.height * 0.87,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: books.length,
                  itemBuilder: (BuildContext context, int index) {
                    return index.isOdd
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BookTitle(
                                    title: books[index]['title'],
                                    status: books[index]['status'],
                                  ),
                                  const RowSpacer(),
                                  BookContainer(
                                      filePath: remotePDFpath,
                                      status: books[index]['status']),
                                ],
                              ),
                              if (index != books.length - 1)
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: LinkedLine(
                                      status: books[index]['status']),
                                ),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BookContainer(
                                      filePath: remotePDFpath,
                                      status: books[index]['status']),
                                  const RowSpacer(),
                                  BookTitle(
                                    title: books[index]['title'],
                                    status: books[index]['status'],
                                  ),
                                ],
                              ),
                              if (index != books.length - 1)
                                LinkedLine(status: books[index]['status'])
                            ],
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class BookContainer extends StatelessWidget {
  final String filePath;
  final Status status;
  const BookContainer({Key? key, required this.filePath, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ignore: avoid_print
        print('remotePDFpath is $filePath');
        if (filePath.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('waiting for downloading'),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(
                path: filePath,
                name: filePath.substring(filePath.lastIndexOf('/') + 1),
              ),
            ),
          );
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          border: Border.all(
            color: status == Status.completed
                ? const Color(0XFFFDB400)
                : const Color(0xFFEBEBEB),
            width: 10,
          ),
          color: status == Status.completed
              ? const Color(0xFFFFFFFF)
              : const Color(0xFF295BB3),
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.2),
        ),
        child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFEBEBEB),
                width: 10,
              ),
              color: status == Status.completed
                  ? const Color(0xFF295BB3)
                  : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width * 0.2),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/book.png',
                width: double.infinity,
              ),
            ) //:Center(child: CircularProgressIndicator()),
            ),
      ),
    );
  }
}

class BookTitle extends StatelessWidget {
  final String title;
  final Status status;

  const BookTitle({super.key, required this.title, required this.status});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: status == Status.completed ? 'JanaBold' : 'JanaRegular',
            fontSize: 16,
            color: status == Status.completed
                ? const Color(0xFF6687C2)
                : const Color(0xFF767676),
          ),
        ),
      ),
    );
  }
}

class LinkedLine extends StatelessWidget {
  final Status status;
  const LinkedLine({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      height: MediaQuery.of(context).size.width * 0.5,
      child: status == Status.completed
          ? Image.asset(
              'assets/icons/path_left_colored.png',
              width: double.infinity,
            )
          : Image.asset(
              'assets/icons/path_left_not_colored.png',
              width: double.infinity,
            ),
    );
  }
}

class RowSpacer extends StatelessWidget {
  const RowSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.1,
    );
  }
}
