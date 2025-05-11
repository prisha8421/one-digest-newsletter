import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'auth_page.dart';
import '/customisations/topic_preference.dart';
import '/customisations/summary_page.dart';
import '/customisations/tone_format_page.dart';
import '/customisations/language_page.dart';
import '/customisations/delivery_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showDigest = true;

  final List<Map<String, String>> savedArticles = [];

  final List<Map<String, String>> newsletters = [
    {
      'title': 'AI in 2025',
      'summary': 'Top trends in Artificial Intelligence you should watch.',
    },
    {
      'title': 'Politics Today',
      'summary': 'Latest updates and news from the political world.',
    },
    {
      'title': 'Tech Digest',
      'summary': 'This week\'s must-know stories in tech and startups.',
    },
    {
      'title': 'Sports News',
      'summary': 'Catch up on all the latest sports events and updates.',
    },
    {
      'title': 'Entertainment News',
      'summary': 'Stay tuned with the newest in movies, music, and pop culture.',
    },
  ];

  void saveArticle(Map<String, String> article) {
    if (!savedArticles.contains(article)) {
      setState(() {
        savedArticles.add(article);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Article saved!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Already saved')),
      );
    }
  }

  void removeArticle(Map<String, String> article) {
    setState(() {
      savedArticles.remove(article);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Removed from saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayList = showDigest ? newsletters : savedArticles;

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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthPage()));
              },
              child: const Text(
                'Login',
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
              for (final feature in [
                'Topics & Preferences',
                'Summary Depth',
                'Tone & Format',
                'Language',
                'Delivery Settings',
              ])
                FeatureDrawerButton(label: feature),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out')),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F3986),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
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
            child: displayList.isEmpty
                ? const Center(
                    child: Text('No articles to display.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final item = displayList[index];
                      return _buildModernNewsletterCard(item);
                    },
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

  Widget _buildModernNewsletterCard(Map<String, String> item) {
    final isSaved = savedArticles.contains(item);

    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8E6FB),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF968CE4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item['title'] ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3F3986),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item['summary'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: const Color(0xFF3F3986).withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up_alt_outlined, color: Color(0xFF3F3986)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Upvoted! (coming soon)')),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.thumb_down_alt_outlined, color: Color(0xFF3F3986)),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downvoted! (coming soon)')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(
                    isSaved ? Icons.delete_outline : Icons.bookmark_border,
                    color: const Color(0xFF3F3986),
                  ),
                  onPressed: () {
                    isSaved ? removeArticle(item) : saveArticle(item);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureDrawerButton extends StatelessWidget {
  final String label;

  const FeatureDrawerButton({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          if (label == 'Topics & Preferences') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TopicPreferencePage()));
          } else if (label == 'Summary Depth') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SummaryPage()));
          } else if (label == 'Tone & Format') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ToneFormatPage()));
          } else if (label == 'Language') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguagePage()));
          } else if (label == 'Delivery Settings') {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const DeliverySettingsPage()));
          }
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
