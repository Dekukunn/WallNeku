import 'package:flutter/material.dart';
import 'package:app_wallpaper/Categories/AnimalsPage.dart';
import 'package:app_wallpaper/Categories/CarsPage.dart';
import 'package:app_wallpaper/Categories/FlowerPage.dart';
import 'package:app_wallpaper/Categories/Games.dart';
import 'package:app_wallpaper/Categories/NaturePage.dart';
import 'package:app_wallpaper/Categories/NightPage.dart';
import 'package:app_wallpaper/Categories/SpacePage.dart';
import 'package:app_wallpaper/Categories/SportPage.dart';

class CategoriesPage extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {
      'title': 'Nature',
      'route': 'NaturePage',
      'imageUrl': 'assets/images/Nature.png'
    },
    {
      'title': 'Animals',
      'route': 'AnimalsPage',
      'imageUrl': 'assets/images/animals.webp'
    },
    {
      'title': 'Flower',
      'route': 'FlowerPage',
      'imageUrl': 'assets/images/Flower.jpg'
    },
    {
      'title': 'Cars',
      'route': 'CarsPage',
      'imageUrl': 'assets/images/cars.jpg'
    },
    {
      'title': 'Night',
      'route': 'NightPage',
      'imageUrl': 'assets/images/night.jpeg'
    },
    {
      'title': 'Space',
      'route': 'SpacePage',
      'imageUrl': 'assets/images/space.jpg'
    },
    {
      'title': 'Sport',
      'route': 'SportPage',
      'imageUrl': 'assets/images/sport.png'
    },
    {
      'title': 'Games',
      'route': 'GamesPage',
      'imageUrl': 'assets/images/games.jpeg'
    },
  ];

  CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories',),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    _navigateToCategory(context, category['route']!);
                  },
                  child: _buildCategoryCard(
                      category['title']!, category['imageUrl']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String route) {
    switch (route) {
      case 'NaturePage':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NaturePage()));
        break;
      case 'FlowerPage':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FlowerPage()));
        break;
      case 'AnimalsPage':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AnimalsPage()));
        break;
      case 'CarsPage':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => CarsPage()));
        break;
      case 'NightPage':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NightPage()));
        break;
      case 'SpacePage':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SpacePage()));
        break;
      case 'SportPage':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SportPage()));
        break;
      case 'GamesPage':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Games()));
        break;
    }
  }
}
