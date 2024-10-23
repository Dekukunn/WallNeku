import 'package:app_wallpaper/WallpaperTile.dart';
import 'package:app_wallpaper/wallpaper_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

const String appUrl = 'https://play.google.com/store/apps/details?id=com.nourdin_mellasse_deku_app_wallpaper';

Future<void> _launchUrl(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $url');
  }
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> homeImages = [];
  bool isLoading = true;

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    fetchImages(); // Fetch images again on refresh
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/Dekukunn/Glitter_wallpaper/refs/heads/main/Glitter_wallpaper'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          homeImages = List<String>.from(data['home_images']);
          homeImages.shuffle();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 24, 24, 24),

        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 24, 24, 24),
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
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
              'Glitter Wallpaper',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: const Color.fromARGB(255, 24, 24, 24),
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 24, 24, 24),
                ),
                child: Text(
                  'Glitter Wallpaper',
                  style: TextStyle(color: Colors.green, fontSize: 25),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text(
                  'About',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.star_border_outlined, color: Colors.white),
                title: const Text(
                  'Rate App',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  try {
                    await _launchUrl(appUrl);
                  } catch (e) {
                    _showSnackBar(context, 'Could not open the app store.');
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.white),
                title: const Text(
                  'Share App',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Share.share('Check out this awesome app: $appUrl');
                },
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            LiquidPullToRefresh(
              color: Colors.black12,
              backgroundColor: Colors.green,
              onRefresh: _handleRefresh,
              height: 200,
              animSpeedFactor: 2,
              showChildOpacityTransition: false,
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.green))
                  : homeImages.isEmpty
                      ? const Center(child: Text('No images available'))
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 7,
                              mainAxisSpacing: 7,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: homeImages.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                          print(homeImages);

                                },
                                child: Image.network(homeImages[index], fit: BoxFit.cover),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 24, 24, 24),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 24, 24, 24),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About This App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'This app is designed to provide amazing wallpapers for your device. Enjoy high-quality images that enhance your home screen experience. With user-friendly navigation and regular updates, you’ll always find fresh and stunning wallpapers to personalize your device.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text('Version: 1.0.0', style: TextStyle(fontSize: 16, color: Colors.white)),
            SizedBox(height: 16),
            Text('Developed by Noureddine Mellasse',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
