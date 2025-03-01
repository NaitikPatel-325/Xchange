import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../core/routes/routes.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("MONGO_USER_ID");
    if (userId != null) {
      _fetchUserAddress();
    }
  }

  Future<void> _fetchUserAddress() async {
    final String baseUrl = 'http://192.168.19.58:3000';
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          addressController.text = data['address'] ?? '';
        });
      }
    } catch (e) {
      print("Error fetching address: $e");
    }
  }

  Future<void> updateAddress() async {
    if (_formKey.currentState!.validate() && userId != null) {
      final String baseUrl = 'http://192.168.19.58:3000';
      try {
        final response = await http.put(
          Uri.parse('$baseUrl/api/users/$userId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'address': addressController.text}),
        );

        if (response.statusCode == 200) {
          Get.snackbar("Success", "Address updated successfully!", snackPosition: SnackPosition.BOTTOM);
          Get.toNamed(Routes.homePage);

        } else {
          Get.snackbar("Error", "Failed to update address", snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        print("Error updating address: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Address')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) => value!.isEmpty ? 'Enter address' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateAddress,
                child: Text('Update Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
