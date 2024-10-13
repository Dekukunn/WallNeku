import 'package:app_wallpaper/wallpaper_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';

class WallpaperTile1 extends StatelessWidget {
  final String imageUrl;
  final String title;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const WallpaperTile1({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WallpaperDetailPage(
              imageUrl: imageUrl,
              isInitiallyFavorite: isFavorite,
              onFavoriteToggle: onFavoriteToggle,
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13.0),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: LikeButton(
                size: 35,
                isLiked: isFavorite,
                onTap: (isLiked) async {
                  // Toggle favorite status
                  onFavoriteToggle();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isLiked ? 'Removed from favorites' : 'Added to favorites'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return !isLiked; // Return the new favorite status
                },
                likeBuilder: (isLiked) {
                  return Icon(
                    isLiked ? Icons.favorite : Icons.favorite,
                    color: isLiked ? Colors.red : Colors.white,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
