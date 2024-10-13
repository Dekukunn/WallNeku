import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  List<String> _favoriteWallpapers = [];

  FavoritesProvider() {
    _loadFavorites();
  }

  List<String> get favoriteWallpapers => _favoriteWallpapers;

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _favoriteWallpapers = prefs.getStringList('favorites') ?? [];
    notifyListeners();
  }

  Future<void> toggleFavorite(String imageUrl) async {
    if (_favoriteWallpapers.contains(imageUrl)) {
      _favoriteWallpapers.remove(imageUrl);
    } else {
      _favoriteWallpapers.add(imageUrl);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favoriteWallpapers);
    notifyListeners();
  }

  bool isFavorite(String imageUrl) {
    return _favoriteWallpapers.contains(imageUrl);
  }
}
