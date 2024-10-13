import 'package:app_wallpaper/CategoriesPage.dart';
import 'package:app_wallpaper/WallpaperTile.dart';
import 'package:app_wallpaper/settingpage.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:provider/provider.dart';
import 'favorites_provider.dart'; // Import your provider
import 'favorites_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _handleRefresh() async{
    return await Future.delayed(Duration(seconds: 2));
  }
  List<String> home_images = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/Dekukunn/wallpaper/refs/heads/main/wallpaper'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          home_images = List<String>.from(data['home_images']);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CategoriesPage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FavoritesPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context); 

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              Colors.green.shade100,
              Colors.green.shade500,
              Colors.green.shade900,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: const Text(
            'WallNeku',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: LiquidPullToRefresh(
        color: Colors.black12,
        backgroundColor: Colors.green,
        onRefresh: _handleRefresh,
        height: 200,
        animSpeedFactor: 2,
        showChildOpacityTransition: false,
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.green,))
            : home_images.isEmpty
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
                      itemCount: home_images.length,
                      itemBuilder: (context, index) {
                        return WallpaperTile1(
                          imageUrl: home_images[index],
                          title: 'Wallpaper ${index + 1}',
                          isFavorite: favoritesProvider.isFavorite(
                              home_images[index]), // Check if wallpaper is favorite
                          onFavoriteToggle: () => favoritesProvider.toggleFavorite(
                              home_images[
                                  index]), // Use provider to toggle favorite
                        );
                      },
                    ),
                ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size: 30),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 30),
            label: '',
          ),
        ],
      ),
    ));
  }
}
