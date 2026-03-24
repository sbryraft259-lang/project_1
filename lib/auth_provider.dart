import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  bool isLoading = false;

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://beachflow-app-production-7bce.up.railway.app/api/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return {'success': false, 'message': 'حدث خطأ حاول مرة أخرى'};
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://beachflow-app-production-7bce.up.railway.app/api/auth/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return {'success': false, 'message': 'رمز غير صحيح'};
    }
  }
}