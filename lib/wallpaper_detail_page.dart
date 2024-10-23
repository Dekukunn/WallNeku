import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class WallpaperDetailPage extends StatefulWidget {
  final String imageUrl;

  const WallpaperDetailPage({
    Key? key,
    required this.imageUrl, required String wallpaperUrl,

  }) : super(key: key);

  @override
  _WallpaperDetailPageState createState() => _WallpaperDetailPageState();
}

class _WallpaperDetailPageState extends State<WallpaperDetailPage> {
  File? _downloadedImage;


  Future<void> _requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      return;
    }
    await Permission.storage.request();
  }

  Future<void> _downloadImage() async {
    try {
      await _requestPermission();

      Dio dio = Dio();
      String fileName = path.basename(widget.imageUrl);
      Directory appDir = await getApplicationDocumentsDirectory();
      String savePath = path.join(appDir.path, fileName);

      await dio.download(widget.imageUrl, savePath);

      if (mounted) {
        setState(() {
          _downloadedImage = File(savePath);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image downloaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading image: $e')),
        );
      }
    }
  }

  Future<void> _setAsWallpaper(int location) async {
    if (_downloadedImage != null) {
      try {
        bool result = await WallpaperManager.setWallpaperFromFile(
          _downloadedImage!.path,
          location,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: result
                    ? Text('Wallpaper set successfully!')
                    : Text('Failed to set wallpaper')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error setting wallpaper: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No image to set as wallpaper')),
        );
      }
    }
  }

  Future<void> _showWallpaperOptions() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Set Wallpaper"),
          content: Text("Where would you like to set the wallpaper?"),
          actions: [
            TextButton(
              child: Text("Home Screen",style: TextStyle(color: Colors.green),),
              onPressed: () {
                Navigator.of(context).pop();
                _setAsWallpaper(WallpaperManager.HOME_SCREEN);
              },
            ),
            TextButton(
              child: Text("Lock Screen",style: TextStyle(color: Colors.green),),
              onPressed: () {
                Navigator.of(context).pop();
                _setAsWallpaper(WallpaperManager.LOCK_SCREEN);
              },
            ),
            TextButton(
              child: Text("Both",style: TextStyle(color: Colors.green),),
              onPressed: () {
                Navigator.of(context).pop();
                _setAsWallpaper(WallpaperManager.BOTH_SCREEN);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleDownloadAndSetWallpaper() async {
    await _downloadImage();
    _showWallpaperOptions();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: _downloadedImage != null
                  ? Image.file(
                      _downloadedImage!,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Text('Failed to load image'));
                      },
                    ),
            ),
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Colors.white, size: 25),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              bottom: 35,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
               Container(
  height: 45,
  width: 210,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.green.shade300, Colors.green.shade700],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.green.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 4,
        offset: Offset(0, 3),
      ),
    ],
  ),
  child: InkWell(
    onTap: _handleDownloadAndSetWallpaper,
    borderRadius: BorderRadius.circular(25),
    child: Center(
      child: Text(
        'Set Wallpaper',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),
)

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
