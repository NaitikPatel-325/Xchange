import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/core/routes/routes.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final List<Map<String, dynamic>> preferences = [
    {'name': 'Electronics', 'icon': Icons.devices},
    {'name': 'Furniture', 'icon': Icons.chair},
    {'name': 'Books', 'icon': Icons.menu_book},
    {'name': 'Clothing', 'icon': Icons.shopping_bag},
    {'name': 'Sports', 'icon': Icons.sports_soccer},
    {'name': 'Vehicles', 'icon': Icons.directions_car},
    {'name': 'Others', 'icon': Icons.more_horiz},
  ];

  List<String> selectedPreferences = [];
  TextEditingController otherController = TextEditingController();

  void toggleSelection(String preference) {
    setState(() {
      if (selectedPreferences.contains(preference)) {
        selectedPreferences.remove(preference);
      } else {
        selectedPreferences.add(preference);
      }
    });
  }

  void savePreferences() {
    if (otherController.text.isNotEmpty) {
      selectedPreferences.add(otherController.text);
    }
    // Navigate to home after selection
    Get.toNamed(Routes.homePage, arguments: {'preferences': selectedPreferences});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Preferences')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: preferences.map((pref) {
                return ListTile(
                  leading: Icon(pref['icon'], color: Colors.blueAccent),
                  title: Text(pref['name']),
                  trailing: Checkbox(
                    value: selectedPreferences.contains(pref['name']),
                    onChanged: (val) => toggleSelection(pref['name']),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: otherController,
              decoration: InputDecoration(
                labelText: 'Other (Specify)',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: savePreferences,
            child: Text('Continue'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
