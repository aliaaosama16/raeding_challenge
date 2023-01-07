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
          print('book is ready');
          bookISReady = true;
          remotePDFpath = f.path;
        } else {
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
              //padding: const EdgeInsets.all(8.0),
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
                                  Flexible(
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                        // textDirection: TextDirection.rtl,
                                        books[index]['title'],
                                        style: TextStyle(
                                          fontFamily: books[index]['status'] ==
                                                  Status.completed
                                              ? 'JanaBold'
                                              : 'JanaRegular',
                                          fontSize: 16,
                                          color: books[index]['status'] ==
                                                  Status.completed
                                              ? const Color(0xFF295BB3)
                                              : const Color(0xFF767676),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            name: remotePDFpath.substring(
                                                remotePDFpath.lastIndexOf('/') +
                                                    1),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(
                                              0XFFFDB400), //Color(0xFFEBEBEB),
                                          width: 10,
                                        ),
                                        color: const Color(0xFF295BB3),
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.25),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFFEBEBEB),
                                            width: 10,
                                          ),
                                          color: const Color(0xFF295BB3),
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/icons/book.png',
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (index != books.length - 1)
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(math.pi),
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 0),
                                    height:
                                        MediaQuery.of(context).size.width * 0.5,
                                    child: books[index]['status'] ==
                                            Status.completed
                                        ? Image.asset(
                                            'assets/icons/path_left_colored.png',
                                            width: double.infinity,
                                          )
                                        : Image.asset(
                                            'assets/icons/path_left_not_colored.png',
                                            width: double.infinity,
                                          ),
                                  ),
                                ),
                            ],
                          )
                        : Column(
                            children: [
                              Row(
                                //mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PDFScreen(
                                            path: remotePDFpath,
                                            name: remotePDFpath.substring(
                                                remotePDFpath.lastIndexOf('/') +
                                                    1),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(
                                              0XFFFDB400), //Color(0xFFEBEBEB),
                                          width: 10,
                                        ),
                                        color: const Color(0xFF295BB3),
                                        borderRadius: BorderRadius.circular(
                                            MediaQuery.of(context).size.width *
                                                0.25),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color(0xFFEBEBEB),
                                            width: 10,
                                          ),
                                          color: const Color(0xFF295BB3),
                                          borderRadius: BorderRadius.circular(
                                              MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25),
                                        ),
                                        child: Center(
                                          child: Image.asset(
                                            'assets/icons/book.png',
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.1,
                                  ),
                                  Flexible(
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.5,
                                    child: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                        books[index]['title'],
                                        style: TextStyle(
                                          fontFamily: books[index]['status'] ==
                                                  Status.completed
                                              ? 'JanaBold'
                                              : 'JanaRegular',
                                          fontSize: 16,
                                          color: books[index]['status'] ==
                                                  Status.completed
                                              ? const Color(0xFF295BB3)
                                              : const Color(0xFF767676),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (index != books.length - 1)
                                Container(
                                  margin: const EdgeInsets.only(top: 0),
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child:
                                      books[index]['status'] == Status.completed
                                          ? Image.asset(
                                              'assets/icons/path_left_colored.png',
                                              width: double.infinity,
                                            )
                                          : Image.asset(
                                              'assets/icons/path_left_not_colored.png',
                                              width: double.infinity,
                                            ),
                                )
                            ],
                          );
                  }),
            ),
          ],
        ),
      ),

      //   Center(child: Builder(
      //     builder: (BuildContext context) {
      //       return Column(
      //         children: <Widget>[
      //           TextButton(
      //             child: const Text("الكتاب الاول"),
      //             onPressed: () {
      //               if (remotePDFpath.isNotEmpty) {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => PDFScreen(
      //                       path: remotePDFpath,
      //                       name: remotePDFpath
      //                           .substring(remotePDFpath.lastIndexOf('/') + 1),
      //                     ),
      //                   ),
      //                 );
      //               } else {
      //                 // loading circle
      //                 showDialog(
      //                   context: context,
      //                   builder: (context) => const Center(
      //                     child: CircularProgressIndicator(),
      //                   ),
      //                 );
      //                 //Navigator.of(context).pop();
      //               }
      //             },
      //           ),
      //           TextButton(
      //             child: const Text("الكتاب الثاني"),
      //             onPressed: () {
      //               if (remotePDFpath.isNotEmpty) {
      //                 Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                     builder: (context) => PDFScreen(
      //                       path: remotePDFpath,
      //                       name: remotePDFpath
      //                           .substring(remotePDFpath.lastIndexOf('/') + 1),
      //                     ),
      //                   ),
      //                 );
      //               } else {
      //                 showDialog(
      //                     context: context,
      //                     builder: (context) => const Center(
      //                           child: CircularProgressIndicator(),
      //                         ));
      //               }
      //             },
      //           ),
      //         ],
      //       );
      //     },
      //   )),
      // ),
    );
  }
}
