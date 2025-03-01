import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xchange/core/routes/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  // Ensure icons are properly defined and not null
  final List<Map<String, dynamic>> preferences = [
    {'name': 'Electronics', 'icon': Icons.devices, 'color': Colors.blue},
    {'name': 'Furniture', 'icon': Icons.chair, 'color': Colors.amber},
    {'name': 'Books', 'icon': Icons.menu_book, 'color': Colors.green},
    {'name': 'Clothing', 'icon': Icons.shopping_bag, 'color': Colors.purple},
    {'name': 'Sports', 'icon': Icons.sports_soccer, 'color': Colors.orange},
    {'name': 'Vehicles', 'icon': Icons.directions_car, 'color': Colors.red},
    {'name': 'Art', 'icon': Icons.palette, 'color': Colors.pink},
    {'name': 'Photography', 'icon': Icons.camera_alt, 'color': Colors.teal},
    {'name': 'Gaming', 'icon': Icons.sports_esports, 'color': Colors.indigo},
    {'name': 'Music', 'icon': Icons.music_note, 'color': Colors.deepOrange},
    {'name': 'Tools', 'icon': Icons.handyman, 'color': Colors.brown},
    {'name': 'Collectibles', 'icon': Icons.diamond, 'color': Colors.lightBlue},
  ];

  List<String> selectedPreferences = [];

  void toggleSelection(String preference) {
    setState(() {
      if (selectedPreferences.contains(preference)) {
        selectedPreferences.remove(preference);
      } else {
        selectedPreferences.add(preference);
      }
    });
  }

  Future<void> savePreferences() async {
    final String baseUrl = 'http://192.168.19.58:3000';
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? userId = pref.getString('MONGO_USER_ID');
      if (userId == null || userId.isEmpty) {
        throw Exception("User ID not found in shared preferences");
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'preferences': selectedPreferences}),
      );

      Get.toNamed(Routes.AddressScreen);

      if (response.statusCode == 200) {
        // Get.toNamed(Routes.homePage, arguments: {'preferences': selectedPreferences});
        print("succ");
      } else {
        throw Exception("Failed to save preferences");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simplify the widget structure to eliminate potential null issues
    return Scaffold(
      appBar: AppBar(title: Text('Select Preferences')),
      body: Column(
        children: [
          // Description text
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            color: const Color(0xFF1E1E1E),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select categories to personalize your barter trading experience. You can always change these later.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                // Info banner with fixed layout
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[400], size: 20),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Select at least 3 categories for the best experience",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Simplified grid - now using GridView.builder directly
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
