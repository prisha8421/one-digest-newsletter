import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  final Map<String, String> languageMap = {
    'en': 'English',
    'hi': 'Hindi',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ar': 'Arabic',
    'pt': 'Portuguese',
  };

  String selectedLanguage = 'en'; // Default language

  void saveLanguagePreference() {
    // TODO: Save to Firestore or apply using localization
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language set to ${languageMap[selectedLanguage]}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Language'),
        backgroundColor: const Color(0xFF8981DF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose your preferred language for content:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3986)),
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFE8E6FB),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
              icon: const Icon(Icons.language, color: Color(0xFF3F3986)),
              dropdownColor: Colors.white,
              items: languageMap.entries.map((entry) {
                return DropdownMenuItem(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLanguage = value!;
                });
              },
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: saveLanguagePreference,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F3986),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Save Language',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
