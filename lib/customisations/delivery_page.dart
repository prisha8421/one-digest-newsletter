import 'package:flutter/material.dart';

class DeliverySettingsPage extends StatefulWidget {
  const DeliverySettingsPage({super.key});

  @override
  State<DeliverySettingsPage> createState() => _DeliverySettingsPageState();
}

class _DeliverySettingsPageState extends State<DeliverySettingsPage> {
  TimeOfDay preferredTime = TimeOfDay(hour: 8, minute: 0);
  final Set<String> selectedChannels = {'Email'};

  void pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: preferredTime,
    );
    if (picked != null) {
      setState(() => preferredTime = picked);
    }
  }

  void toggleChannel(String channel) {
    setState(() {
      if (selectedChannels.contains(channel)) {
        selectedChannels.remove(channel);
      } else {
        selectedChannels.add(channel);
      }
    });
  }

  void saveSettings() {
    // Placeholder for backend saving
    final formattedTime = preferredTime.format(context);
    final channels = selectedChannels.join(', ');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved: $formattedTime via $channels')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Settings'),
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
            const Text('Preferred Delivery Time:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: pickTime,
              icon: const Icon(Icons.schedule),
              label: Text(preferredTime.format(context)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F3986),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Delivery Channels:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Wrap(
              spacing: 10,
              children: ['Email', 'Push'].map((channel) {
                final isSelected = selectedChannels.contains(channel);
                return FilterChip(
                  label: Text(channel),
                  selected: isSelected,
                  selectedColor: const Color(0xFF3F3986),
                  onSelected: (_) => toggleChannel(channel),
                  labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF3F3986)),
                  backgroundColor: const Color(0xFFE8E6FB),
                );
              }).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: saveSettings,
                child: const Text('Save Settings'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F3986),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
