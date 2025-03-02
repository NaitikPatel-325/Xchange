import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:xchange/presentation/chat/chat_screen.dart';

class BarterDetailScreen extends StatelessWidget {
  final Map<String, String> item;

  const BarterDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String title = item["title"] ?? "Barter Details";
    final String offer = item["offer"] ?? _extractOffer(title);
    final String request = item["request"] ?? _extractRequest(title);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.grey, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Posted by: ${item["email"] ?? "Unknown"}",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Description",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item["description"] ?? "No description available.",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoRow("Offering", offer),
              const SizedBox(height: 10),
              _buildInfoRow("Requesting", request),
              const SizedBox(height: 30),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  String _extractOffer(String title) {
    final parts = title.split(" for ");
    return parts.isNotEmpty ? parts.first : "Not specified";
  }

  String _extractRequest(String title) {
    final parts = title.split(" for ");
    return parts.length > 1 ? parts.last : "Not specified";
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, String?>> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString("MONGO_USER_ID"),
      'userEmail': prefs.getString("EMAIL"), // Use getString, not setString
    };
  }


  Future<void> _proposeExchange() async {
    try {
      final userData = await _loadUserData();
      final String? requestorId = userData['userId'];
      final String? requestorEmail = userData['userEmail'];
      print(item);

      if (requestorId == null) {
        print("Missing requestorId");
      }
      if (requestorEmail == null) {
        print("Missing requestorEmail");
      }
      if (item["listingId"] == null) {
        print("Missing barterListingId");
      }

      if (requestorId == null || requestorEmail == null || item["listingId"] == null) {
        Get.snackbar(
          "Error",
          "Missing required fields for proposal.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      print(item["userId"]);
      final Map<String, dynamic> proposalData = {
        'requestorId': requestorId,
        'requestorEmail': requestorEmail,
        'recipientId': item["userId"] ?? "", // Add this back with appropriate field
        'recipientEmail': item["email"],
        'listingId': item["listingId"],
        'offeredItem': {
          'title': item["title"],
          'description': item["description"],
          'offer': _extractOffer(item["title"] ?? ""),
        },
        'requestedItem': {
          'title': _extractRequest(item["title"] ?? ""),
        },
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
      };

      final response = await http.post(
        Uri.parse("http://192.168.19.58:3000/api/transaction/propose"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(proposalData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {

        Get.snackbar(
          "Success",
          "Exchange proposal sent successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAllNamed('/homePage');
      } else {
        final errorMessage = json.decode(response.body)['message'] ?? 'Failed to propose exchange';
        throw Exception('Error: $errorMessage');
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to send proposal: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _proposeExchange,
            child: const Text(
              "Propose Exchange",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.to(() => ChatScreen(
                user: item["offeredBy"] ?? "Unknown",
                title: item["title"] ?? "Barter Chat",
              ));
            },
            child: const Text(
              "Start Chat",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}