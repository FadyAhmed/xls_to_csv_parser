import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';

void main() async {
  List<String> sections = [];
  List<String> setSections = [];
  List<String> specs = [];
  List<String> setSpecs = [];
  File gen = new File('generated.txt');
  int totalMale = 0;
  int totalFemale = 0;
  int wrong = 0;

  var file = "tb.xlsx";
  var bytes = File(file).readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table].rows) {
      // if (row[8].toString().trim() == 'ذكر') totalMale++;
      // if (row[8].toString().trim() == 'انثى' ||
      //     row[8].toString().trim() == 'أنثى') totalFemale++;
      specs.add(row[6].toString().trim().replaceAll("  ", " "));
    }
  }
  int male;
  int female;

  setSections = sections.toSet().toList();
  setSpecs = specs.toSet().toList();

  for (var spec in setSpecs) {
    male = 0;
    female = 0;
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table].rows) {
        if (row[6].toString().trim().replaceAll("  ", " ") == spec.trim()) {
          if (row[8].toString().trim() == 'ذكر' ||
              row[8].toString().trim() == 'ذكز' ||
              row[8].toString().trim() == 'ذكور') {
            male++;
            totalMale++;
          } else if (row[8].toString().trim() == 'انثى' ||
              row[8].toString().trim() == 'أنثى' ||
              row[8].toString().trim() == 'ثى') {
            female++;
            totalFemale++;
          } else {
            print("$row ${row[8].toString().trim()}");
            wrong++;
          }
        }
      }
      if (male != 0 || female != 0) {
        await gen.writeAsString(
            jsonEncode(spec) +
                "," +
                jsonEncode(male) +
                "," +
                jsonEncode(female) +
                "," +
                "\n",
            mode: FileMode.append);
      }
    }
  }

  print('female: ' + totalFemale.toString());
  print('male: ' + totalMale.toString());
  print(wrong);
  print(totalFemale + totalMale);
  print("//////////////done\\\\\\\\\\\\\\\\");
}
