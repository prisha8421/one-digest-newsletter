import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../database/news_service.dart';
import 'auth_page.dart';
import 'package:update_latest/customisations/topic_preference.dart';
import 'package:update_latest/customisations/delivery_page.dart';
import 'package:update_latest/customisations/summary_page.dart';
import 'package:update_latest/customisations/tone_format_page.dart';
import 'package:update_latest/customisations/language_page.dart';
import '../models/news_article.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showDigest = true;
  List<NewsArticle> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLatestNews();
  }

  Future<void> fetchLatestNews() async {
    try {
      final news = await NewsService().fetchLatestGeneralNews();
      setState(() {
        articles = news;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load news: $e")),
      );
    }
  }

  Future<void> triggerEmailNewsletter() async {
    final uri = Uri.parse('http://10.0.2.2:5000/generate-and-send'); // Use your backend URL
    try {
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Newsletter sent successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed to send email: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ Error: $e')),
      );
    }
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8981DF),
        elevation: 0,
        title: const Text(''),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: _logout,
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
            children: [
              const Text(
                'Account Preferences',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3986),
                ),
              ),
              const SizedBox(height: 20),
              FeatureDrawerButton(label: 'Topics & Preferences', targetPage: TopicPreferencePage()),
              FeatureDrawerButton(label: 'Summary Depth', targetPage: SummaryPage()),
              FeatureDrawerButton(label: 'Tone & Format', targetPage: ToneFormatPage()),
              FeatureDrawerButton(label: 'Language', targetPage: LanguagePage()),
              FeatureDrawerButton(label: 'Delivery Settings', targetPage: DeliverySettingsPage()),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: triggerEmailNewsletter,
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Send Newsletter', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F3986),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Logout', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF968CE4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF8981DF),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      letterSpacing: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'ONE', style: TextStyle(color: Colors.white)),
                      TextSpan(text: 'DIGEST', style: TextStyle(color: Color(0xFF3F3986))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Welcome, Name',
            style: TextStyle(
              fontSize: 35,
              fontFamily: 'Georgia',
              color: Color(0xFF3F3986),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF8981DF),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton('Your Digest', showDigest),
                const SizedBox(width: 10),
                _buildToggleButton('Saved', !showDigest),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: fetchLatestNews,
                    child: articles.isEmpty
                        ? ListView(
                            children: const [
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24.0),
                                  child: Text("No articles found."),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              final NewsArticle item = articles[index];
                              return _buildModernNewsletterCard(item, context);
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showDigest = (text == 'Your Digest');
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$text selected (coming soon)')),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 22),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3F3986) : const Color(0xFF8981DF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? const Color.fromARGB(255, 170, 161, 241) : Colors.white,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildModernNewsletterCard(NewsArticle item, BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(item.url)),
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE8E6FB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item.imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(height: 180, color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F3986),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF3F3986).withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Source: ${item.source}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureDrawerButton extends StatelessWidget {
  final String label;
  final Widget targetPage;

  const FeatureDrawerButton({
    super.key,
    required this.label,
    required this.targetPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => targetPage),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF968CE4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
