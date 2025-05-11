import 'package:flutter/material.dart';

class TopicPreferencePage extends StatefulWidget {
  const TopicPreferencePage({super.key});

  @override
  State<TopicPreferencePage> createState() => _TopicPreferencePageState();
}

class _TopicPreferencePageState extends State<TopicPreferencePage> {
  final List<String> allTopics = [
    'Technology',
    'Health',
    'Finance',
    'Politics',
    'Entertainment',
    'Sports',
    'Science',
    'Travel',
    'Education',
  ];

  final Set<String> selectedTopics = {};

  void toggleTopic(String topic) {
    setState(() {
      if (selectedTopics.contains(topic)) {
        selectedTopics.remove(topic);
      } else {
        selectedTopics.add(topic);
      }
    });
  }

  void savePreferences() {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preferences saved: ${selectedTopics.join(', ')}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Topics'),
        backgroundColor: Color(0xFF8981DF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pick topics you’re interested in:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: allTopics.map((topic) {
                final isSelected = selectedTopics.contains(topic);
                return ChoiceChip(
                  label: Text(topic),
                  selected: isSelected,
                  selectedColor: Color(0xFF3F3986),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Color(0xFF3F3986),
                    fontWeight: FontWeight.w500,
                  ),
                  onSelected: (_) => toggleTopic(topic),
                  backgroundColor: Color(0xFFE8E6FB),
                );
              }).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: savePreferences,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3F3986),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Save Preferences',
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
