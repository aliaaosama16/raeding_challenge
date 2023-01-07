class Book {
  // final int bookId;
  // final String bookTitle;
  // final String bookProgress;
  // final String bookUrl;

  // const Book({
  //   required this.bookId,
  //   required this.bookTitle,
  //   required this.bookProgress,
  //   required this.bookUrl,
  // });

  // factory Book.fromJson(Map<String, dynamic> json) {
  //   return Book(
  //     bookId: json['bookId'],
  //     bookTitle: json['bookTitle'],
  //     bookProgress: json['bookProgress'],
  //     bookUrl: json['bookUrl'],
  //   );
  // }

  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Book({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}