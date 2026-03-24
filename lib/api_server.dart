import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model.dart'; // تأكد إن Beach model موجود

class BeachProvider with ChangeNotifier {
  List<Beach> _beaches = [];
  bool _isLoading = false;

  int? maxcount;
  int currentcount = 0;

  List<Beach> get beaches => _beaches;
  bool get isLoading => _isLoading;
  double get percentage {
    if (maxcount == null || maxcount == 0) return 0;
    return (currentcount / maxcount!) * 100;
  }

  /// جلب البيانات من API أو استخدام الكاش
  Future<void> fetchBeaches() async {
    if (_beaches.isNotEmpty) return; // استخدم الكاش لو موجود

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${ApiConstant.baseurl}api/beach"),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        _beaches = data.map((e) => Beach.fromJson(e)).toList();
        notifyListeners();
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load beaches: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh البيانات من API
  Future<void> refreshBeaches() async {
    if (_beaches.isNotEmpty) return;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("${ApiConstant.baseurl}api/beach"),
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        _beaches = data.map((e) => Beach.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Failed to refresh beaches: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
