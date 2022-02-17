import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class csvToJson {
  Future<List<dynamic>> loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/csv/Check.csv");
    List<dynamic> _listData = CsvToListConverter().convert(_rawData);
    return _listData;
  }
}
