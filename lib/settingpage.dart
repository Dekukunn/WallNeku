import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme_provider.dart'; // Import your ThemeProvider

Future<void> _launchUrl(_url) async {
  final Uri url = Uri.parse(_url);
  if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode ==
        ThemeMode.dark; // Check if dark mode is active

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: isDarkMode ? Colors.black12 : Colors.green,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSettingsItem(
            
            context: context,
            icon: Icons.dark_mode,
            title: 'Toggle Dark Mode',
            trailing: Switch(
              
              value: isDarkMode,
              onChanged: (bool value) {
                themeProvider.toggleTheme(); // Toggle the theme
              },
            ),
          ),
          SizedBox(height: 10),
          _buildSettingsButton(
            context: context,
            icon: Icons.star_rate,
            title: 'Rate App',
            onTap: () async {
              const url =
                  'https://play.google.com/store/apps/details?id=com.nourdin_mellasse_deku_app_wallpaper';
              _launchUrl(url);
            },
          ),
          SizedBox(height: 10),
          // Share App button
          _buildSettingsButton(
            context: context,
            icon: Icons.share,
            title: 'Share App',
            onTap: () {
              // Replace with your Play Store or App Store link
              Share.share(
                  'Check out this awesome app: https://play.google.com/store/apps/details?id=com.nourdin_mellasse_deku_app_wallpaper');
            },
          ),

          SizedBox(height: 10),
          _buildSettingsButton(
            context: context,
            icon: Icons.info,
            title: 'About',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
          ),
          SizedBox(height: 10),
          _buildSettingsButton(
            context: context,
            icon: Icons.logout_outlined,
            title: 'Logout',
            onTap: () {
              _showLogoutConfirmationDialog(
                  context); // Show the confirmation dialog
            },
          ),
        ],
      ),
    );
  }

  // Function to show a confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Logout'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog and stay in the settings page
              },
              child: Text('Cancel',style: TextStyle(color: Colors.green),),
            ),
            TextButton(
              onPressed: () {
                // Simulate exiting the app by returning to the first route (initial page)
                SystemNavigator.pop();
              },
              child: Text('OK',style: TextStyle(color: Colors.green),),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingsItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? trailing,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode ==
        ThemeMode.dark; // Check if dark mode is active

    return ListTile(
      leading:
          Icon(icon, color: isDarkMode ? Colors.white : Colors.grey.shade700),
      title: Text(title,
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
      trailing: trailing,
    );
  }

  Widget _buildSettingsButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDarkMode = themeProvider.themeMode ==
        ThemeMode.dark; // Check if dark mode is active

    return TextButton(
      
      onPressed: onTap,
      child: Row(
        
        children: [
          Icon(icon, color: isDarkMode ? Colors.white : Colors.grey.shade700),
          SizedBox(width: 8),
          Text(title,
              style:
                  TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About This App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'This app is designed to provide amazing wallpapers for your device. You can explore various categories, such as Nature, Sports, and Abstract, and favorite your desired wallpapers for easy access. Enjoy high-quality images that enhance your home screen experience. With user-friendly navigation and regular updates, you’ll always find fresh and stunning wallpapers to personalize your device.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Developed by Noureddine Mellasse',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
