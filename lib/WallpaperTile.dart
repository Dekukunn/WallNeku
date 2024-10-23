import 'package:app_wallpaper/wallpaper_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:like_button/like_button.dart';

class WallpaperTile1 extends StatelessWidget {
  final String imageUrl;


  const WallpaperTile1({
    Key? key,
    required this.imageUrl, required String wallpaperUrl,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WallpaperDetailPage(
              imageUrl: imageUrl, wallpaperUrl: '',
 
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
  
          ],
        ),
      ),
    );
  }
}
