import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Beach> favoriteBeaches = [];

  bool isFavorite(Beach beach) {
    return favoriteBeaches.any((b) => b.id == beach.id);
  }

  /// Token ثابت للتجربة
  final String token = "PUT_YOUR_FIXED_TOKEN_HERE";

  /// Toggle favorite
  Future<void> toggleFavorite(Beach beach) async {
    bool fav = isFavorite(beach);

    // تحديث فورًا
    if (fav) {
      favoriteBeaches.removeWhere((b) => b.id == beach.id);
    } else {
      favoriteBeaches.add(beach);
    }
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(
          "https://beachflow-app-production-7bce.up.railway.app/api/favorites/toggle",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
        body: {
          "beach_id": beach.id,
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed");
      }
    } catch (e) {
      // ارجع للحالة القديمة لو حصل خطأ
      if (fav) {
        favoriteBeaches.add(beach);
      } else {
        favoriteBeaches.removeWhere((b) => b.id == beach.id);
      }
      notifyListeners();
      print("Error toggling favorite: $e");
    }
  }

  /// Load favorites
  Future<void> loadFavorites() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://beachflow-app-production-7bce.up.railway.app/api/favorites",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        favoriteBeaches =
            data.map((json) => Beach.fromJson(json)).toList();
        notifyListeners();
      } else {
        print("Failed to load favorites: ${response.body}");
      }
    } catch (e) {
      print("Error loading favorites: $e");
    }
  }
}