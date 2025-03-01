import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xchange/core/routes/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> savePreferences() async {
    if (otherController.text.isNotEmpty) {
      selectedPreferences.add(otherController.text);
    }

    final String baseUrl = 'http://192.168.19.58:3000';
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? userId = pref.getString('MONGO_USER_ID');
      print(userId);

      if (userId == null || userId.isEmpty) {
        throw Exception("User ID not found in shared preferences");
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/users/$userId'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'preferences': selectedPreferences}),
      ).timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception("Request timed out. Check the backend server.");
      });

      if (response.statusCode == 200) {
        Get.toNamed(Routes.homePage, arguments: {'preferences': selectedPreferences});
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
