import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'favorites_provider.dart';
import 'wallpaper_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final List<String> favoriteWallpapers =
        favoritesProvider.favoriteWallpapers;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Wallpapers"),
        backgroundColor: Colors.black12,
      ),
      body: favoriteWallpapers.isEmpty
          ? const Center(child: Text("No favorites yet."))
          : GridView.builder(
              padding: const EdgeInsets.all(5),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 0.6,
              ),
              itemCount: favoriteWallpapers.length,
              itemBuilder: (context, index) {
                final String imageUrlToShow = favoriteWallpapers[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WallpaperDetailPage(
                          imageUrl: imageUrlToShow,
                          isInitiallyFavorite: true,
                          onFavoriteToggle: () {
                            favoritesProvider.toggleFavorite(imageUrlToShow);
                          },
                        ),
                      ),
                    );
                  },
                  child: GridTile(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          imageUrlToShow,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              favoritesProvider.isFavorite(imageUrlToShow)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  favoritesProvider.isFavorite(imageUrlToShow)
                                      ? Colors.red
                                      : Colors.white,
                            ),
                            onPressed: () {
                              // This will toggle the favorite status
                              favoritesProvider.toggleFavorite(imageUrlToShow);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
