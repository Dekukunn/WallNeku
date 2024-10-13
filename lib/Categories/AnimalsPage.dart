import 'package:app_wallpaper/WallpaperTile.dart';
import 'package:app_wallpaper/favorites_provider.dart';
import 'package:flutter/material.dart';
import 'package:app_wallpaper/wallpaper_service.dart'; // Import ApiService
import 'package:provider/provider.dart';

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({super.key});

  @override
  _AnimalsPageState createState() => _AnimalsPageState();
}

class _AnimalsPageState extends State<AnimalsPage> {
  List<String> animalWallpapers = [];
  bool isLoading = true;
  ApiService apiService = ApiService(); // Initialize ApiService

  @override
  void initState() {
    super.initState();
    _fetchWallpapers(); // Fetch wallpapers for the "Animals" category
  }

  // Fetch wallpapers using the ApiService method
  Future<void> _fetchWallpapers() async {
    try {
      final fetchedWallpapers =
          await apiService.fetchWallpapers('Animals'); // Filter 'Animals'
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        animalWallpapers = fetchedWallpapers;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access the FavoritesProvider
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: Text('Animals Wallpaper',style: TextStyle(color: Colors.white),),
           leading: IconButton(
                icon: const Icon(Icons.arrow_back,
                    color: Colors.white, size: 25),
                onPressed: () => Navigator.of(context).pop(),
           )
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.green,))
            : animalWallpapers.isEmpty
                ? Center(child: Text('No images available'))
                : Padding(
                  padding: const EdgeInsets.only(left: 2,right: 2),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 3,
                        mainAxisSpacing: 3,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: animalWallpapers.length,
                      itemBuilder: (context, index) {
                        return WallpaperTile1(
                          imageUrl: animalWallpapers[index],
                          title: 'Wallpaper ${index + 1}',
                          isFavorite: favoritesProvider.isFavorite(
                              animalWallpapers[
                                  index]), // Check if wallpaper is favorite
                          onFavoriteToggle: () =>
                              favoritesProvider.toggleFavorite(animalWallpapers[
                                  index]), // Use provider to toggle favorite
                        );
                      },
                    ),
                ),
      ),
    );
  }
}
