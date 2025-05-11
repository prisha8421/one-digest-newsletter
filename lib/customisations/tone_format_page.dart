import 'package:flutter/material.dart';

class ToneFormatPage extends StatefulWidget {
  const ToneFormatPage({super.key});

  @override
  State<ToneFormatPage> createState() => _ToneFormatPageState();
}

class _ToneFormatPageState extends State<ToneFormatPage> {
  String selectedTone = 'Casual';
  String selectedFormat = 'Bullet Points';

  final List<String> toneOptions = ['Casual', 'Formal', 'Friendly', 'Professional'];
  final List<String> formatOptions = ['Bullet Points', 'Paragraph', 'Brief Highlights'];

  void saveToneAndFormat() {
    // TODO: Store this to Firebase later
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved: $selectedTone tone, $selectedFormat format')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tone & Format'),
        backgroundColor: Color(0xFF8981DF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose your preferred **tone**:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3986))),
            const SizedBox(height: 16),
            for (String tone in toneOptions)
              RadioListTile<String>(
                title: Text(tone),
                value: tone,
                groupValue: selectedTone,
                activeColor: Color(0xFF3F3986),
                onChanged: (value) => setState(() => selectedTone = value!),
              ),
            const SizedBox(height: 24),
            Text('Choose your preferred **format**:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF3F3986))),
            const SizedBox(height: 16),
            for (String format in formatOptions)
              RadioListTile<String>(
                title: Text(format),
                value: format,
                groupValue: selectedFormat,
                activeColor: Color(0xFF3F3986),
                onChanged: (value) => setState(() => selectedFormat = value!),
              ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: saveToneAndFormat,
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
