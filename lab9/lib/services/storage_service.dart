import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<List<dynamic>> loadAssetsJson(String assetPath) async {
    final String response = await rootBundle.loadString(assetPath);
    return jsonDecode(response);
  }

  Future<File> _getLocalFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  Future<List<Map<String, dynamic>>> readJsonFile(String fileName) async {
    final file = await _getLocalFile(fileName);
    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];
      final List<dynamic> decoded = jsonDecode(content);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {

      await file.writeAsString(jsonEncode([]));
      return [];
    }
  }

  Future<void> writeJsonFile(String fileName, List<Map<String, dynamic>> data) async {
    final file = await _getLocalFile(fileName);
    await file.writeAsString(jsonEncode(data));
  }
}