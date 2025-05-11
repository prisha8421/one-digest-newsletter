import 'package:flutter/material.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  String selectedDepth = 'Brief Summary';

  final List<String> summaryOptions = [
    'Brief Summary',
    'Medium Length',
    'In-depth Article',
  ];

  void saveSummaryPreference() {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved preference: $selectedDepth')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Summary Customisation'),
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
            Text('Choose your preferred content depth:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3F3986),
                )),
            const SizedBox(height: 24),
            for (String option in summaryOptions)
              ListTile(
                title: Text(option),
                leading: Radio<String>(
                  value: option,
                  groupValue: selectedDepth,
                  onChanged: (value) {
                    setState(() {
                      selectedDepth = value!;
                    });
                  },
                ),
              ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: saveSummaryPreference,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3F3986),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Save Preference',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
