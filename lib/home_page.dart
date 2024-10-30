import 'package:app_wallpaper/wallpaper_detail_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarVisible = true;

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
    _scrollController.addListener(_handleScroll);
  }

  Future<void> fetchImages() async {
    try {
      final response = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/Dekukunn/Glitter_wallpaper/main/Glitter_wallpaper'));
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

  void _handleScroll() {
    final userScrollDirection = _scrollController.position.userScrollDirection;
    if (userScrollDirection == ScrollDirection.reverse && _isAppBarVisible) {
      setState(() => _isAppBarVisible = false);
    } else if (userScrollDirection == ScrollDirection.forward &&
        !_isAppBarVisible) {
      setState(() => _isAppBarVisible = true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  PreferredSizeWidget _buildAppBar() {
    return _isAppBarVisible
        ? AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: SizedBox(
              height: 65,
              child: Image.asset(
                "assets/images/bar.png",
                fit: BoxFit.contain,
              ),
            ),
          )
        : PreferredSize(
            preferredSize: const Size.fromHeight(0), child: Container());
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(right: 40.0, top: 40, left: 20),
            child: Image.asset(
              'assets/images/bar.png',
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.info),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
              ),
              Container(
                width: 250,
                child: InkWell(
                  splashColor: Colors.green,
                  child: const Text('About',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AboutPage()),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.star_rate),
                onPressed: () async {
                  const url =
                      'https://play.google.com/store/apps/details?id=com.Nourdine_mellasse_Glitter_Wallpaper';
                  _launchUrl(url);
                },
              ),
              Container(
                width: 250,
                child: InkWell(
                  splashColor: Colors.green,
                  child: const Text('Rate App',
                      style: TextStyle(color: Colors.white)),
                  onTap: () async {
                    const url =
                        'https://play.google.com/store/apps/details?id=com.Nourdine_mellasse_Glitter_Wallpaper';
                    _launchUrl(url);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.share),
                onPressed: () {
                  Share.share(
                      'Check out this awesome app: https://play.google.com/store/apps/details?id=com.Nourdine_mellasse_Glitter_Wallpaper');
                },
              ),
              Container(
                width: 250,
                child: InkWell(
                  splashColor: Colors.green,
                  child: const Text('Share App',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Share.share(
                        'Check out this awesome app: https://play.google.com/store/apps/details?id=com.Nourdine_mellasse_Glitter_Wallpaper');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
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
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                : homeImages.isEmpty
                    ? const Center(
                        child: Text('No images available',
                            style: TextStyle(color: Colors.white)),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: homeImages.length,
                          itemBuilder: (context, index) {
                            final imageUrl = homeImages[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WallpaperDetailPage(
                                      imageUrl: imageUrl,
                                      wallpaperUrl: imageUrl,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Image.asset(
                                    "assets/images/loading.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
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
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'This app is designed to provide amazing wallpapers for your device. Enjoy high-quality images that enhance your home screen experience. With user-friendly navigation and regular updates, you’ll always find fresh and stunning wallpapers to personalize your device.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 16),
            Text('Version: 1.0.0',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            SizedBox(height: 16),
            Text('Developed by Noureddine Mellasse',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
