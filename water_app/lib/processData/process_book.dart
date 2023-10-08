// ignore_for_file: non_constant_identifier_names

import 'package:csv/csv.dart';
import 'package:water_app/Storage/cloud_storage.dart';

abstract class ProcessBook {
  static Map<String, Map<String, dynamic>> book = {};

  static Future<Map<String, Map<String, dynamic>>> processCsv(context) async {
    if (book.isEmpty) {
      var bookString = await CloudStorage.getRawtxtData("ill_book.csv");

      List<List<dynamic>> bookCsv =
          const CsvToListConverter().convert(bookString, eol: "\n");

      int REGIONIDX = 1;
      int SCINAMEIDX = 2;
      int COMMONNAMEIDX = 3;
      int RANKIDX = 4;
      int IMAGEIDX = 5;
      int NOBGIMAGEIDX = 6;

      for (int i = 1; i < bookCsv.length; i++) {
        Map<String, dynamic> bookData = {};
        String s = bookCsv[i][NOBGIMAGEIDX];
        bookData["no_bg_image"] = s.substring(0, s.length - 1);
        bookData["image"] = bookCsv[i][IMAGEIDX];
        bookData["scientific_name"] = bookCsv[i][SCINAMEIDX];
        bookData["common_name"] = bookCsv[i][COMMONNAMEIDX];
        bookData["rank"] = bookCsv[i][RANKIDX];
        bookData["country"] = (bookCsv[i][REGIONIDX] == "TW")
            ? "Taiwan"
            : bookCsv[i][REGIONIDX] == "US"
                ? "America"
                : "Canada";

        book[bookCsv[i][SCINAMEIDX]] = bookData;
      }
    }
    return book;
  }

  static String getCommonName(String scientificName) {
    return book[scientificName]!["common_name"];
  }
}
