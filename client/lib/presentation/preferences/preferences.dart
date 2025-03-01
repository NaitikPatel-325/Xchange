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


      if (response.statusCode == 200) {
        print("success");
        Get.toNamed(Routes.AddressScreen);

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Choose Your Interests",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: preferences.length,
          itemBuilder: (context, index) {
            final pref = preferences[index];
            final isSelected = selectedPreferences.contains(pref['name']);

            return GestureDetector(
              onTap: () => toggleSelection(pref['name']),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? pref['color'].withOpacity(0.2) : Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? pref['color'] : Colors.grey[800]!,
                    width: 3,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(pref['icon'], color: pref['color'], size: 40),
                    const SizedBox(height: 8),
                    Text(
                      pref['name'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.1), blurRadius: 10)],
        ),
        child: ElevatedButton(
          onPressed: selectedPreferences.length >= 3 ? savePreferences : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedPreferences.length >= 3 ? Colors.blue : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            selectedPreferences.length >= 3 ? "Continue" : "Select at least 3",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}