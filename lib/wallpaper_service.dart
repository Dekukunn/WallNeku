import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // This method will fetch the wallpapers based on the category
  Future<List<String>> fetchWallpapers(String category) async {
    final response = await http.get(Uri.parse('https://raw.githubusercontent.com/Dekukunn/wallpaper/refs/heads/main/wallpaper'));  // Use the correct raw JSON URL

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final categories = jsonResponse['categories'] as List;
        for (var cat in categories) {
          if (cat['name'] == category) {
            return List<String>.from(cat['images']);
          }
        }
        return [];
      } catch (e) {
        print('Error decoding JSON: $e');
        return [];
      }
    } else {
      throw Exception('Failed to load wallpapers');
    }
  }
}
