import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/book.dart';

class BookService {

Future<List<Book>> fetchBooks(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  // Use the compute function to run parseBooks in a separate isolate.
  return compute(parseBooks, response.body);
}

// A function that converts a response body into a List<Book>.
List<Book> parseBooks(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Book>((json) => Book.fromJson(json)).toList();
}
}
