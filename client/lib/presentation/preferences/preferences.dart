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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text("What are you interested in?",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: preferences.length,
              itemBuilder: (context, index) {
                final pref = preferences[index];
                final isSelected = selectedPreferences.contains(pref['name']);
                final Color color = pref['color'];
                return GestureDetector(
                  onTap: () => toggleSelection(pref['name']),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? color.withOpacity(0.15) : const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? color : Colors.grey[800]!, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                          child: Icon(pref['icon'], color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 12),
                        Text(pref['name'],
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
                        if (isSelected) ...[
                          const SizedBox(height: 8),
                          Container(width: 24, height: 3, color: color),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E)),
        child: ElevatedButton(
          onPressed: selectedPreferences.length >= 3 ? savePreferences : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            selectedPreferences.length >= 3 ? "Continue" : "Select at least 3 categories",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
