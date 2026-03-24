import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model.dart'; // Beach model

class TopRatedBeachProvider with ChangeNotifier {
  List<Beach> _topRatedBeaches = [];
  bool _isLoading = false;

  List<Beach> get topRatedBeaches => _topRatedBeaches;
  bool get isLoading => _isLoading;

  Future<void> fetchTopRatedBeaches() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("https://beachflow-app-production-7bce.up.railway.app/api/beach/top-rated"),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        final List<dynamic> beachesData = data["data"] ?? [];

        _topRatedBeaches = beachesData.map((e) => Beach.fromJson(e)).toList();
      } else {
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load top-rated beaches: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // اختياري: لتحديث البيانات عند pull-to-refresh
  Future<void> refreshTopRatedBeaches() async {
    await fetchTopRatedBeaches();
  }
}