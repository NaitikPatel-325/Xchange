import 'dart:convert';

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xchange/core/app_color.dart';
import 'package:xchange/core/routes/routes.dart';

// Define theme colors (without redefining darkBackgroundColor)
const Color primaryPurple = Color(0xFF9C27B0);
const Color lightPurple = Color(0xFFBB86FC);
const Color darkPurple = Color(0xFF6A1B9A);
const Color surfaceColor = Color(0xFF1E1E1E);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _selectedFilter = "Active";
  List<Map<String, dynamic>> barterHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBarterHistory();
  }

  Future<void> _fetchBarterHistory() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? userId = prefs.getString("MONGO_USER_ID")?.trim();

      if (userId == null) {
        throw Exception('User ID not found in SharedPreferences');
      }

      print('Raw User ID: "$userId"');
      print('User ID Length: ${userId.length}');

      final isValidObjectId = RegExp(r'^[0-9a-fA-F]{24}$').hasMatch(userId);
      if (!isValidObjectId) {
        throw Exception('Invalid ObjectId format: $userId');
      }

      print('Fetching transactions for User ID: $userId');
      final response = await http.get(
        Uri.parse('http://192.168.19.73:3000/api/transaction/user/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['success']) {
          if (mounted) { // Check if widget is still mounted
            setState(() {
              barterHistory = List<Map<String, dynamic>>.from(jsonData['data']);
              _isLoading = false;
            });
          }
        } else {
          throw Exception(jsonData['message']);
        }
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) { // Check if widget is still mounted
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching transactions: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Filter barter history based on selected filter
    List<Map<String, dynamic>> filteredHistory = barterHistory.where((item) {
      return item["status"].toString().toLowerCase() == _selectedFilter.toLowerCase();
    }).toList();

    print('Barter History Length: ${barterHistory.length}');
    print('Filtered History Length: ${filteredHistory.length}');

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              darkBackgroundColor,
              Color(0xFF1A1A1A),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Profile Image with purple glow
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryPurple.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: primaryPurple,
                  child: CircleAvatar(
                    radius: 52,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : const AssetImage("assets/profile_placeholder.png")
                    as ImageProvider,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // User Name
              Text(
                user?.email ?? "Anonymous User",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: primaryPurple,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),

              // User Email
              // Text(
              //   user?.email ?? "No Email",
              //   style: const TextStyle(
              //     fontSize: 16,
              //     color: Colors.grey,
              //     letterSpacing: 0.5,
              //   ),
              // ),

              const SizedBox(height: 40),

              // Barter History Section with purple accent
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryPurple.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: primaryPurple.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Title with purple accent
                    Row(
                      children: [
                        Container(
                          height: 24,
                          width: 4,
                          decoration: BoxDecoration(
                            color: lightPurple,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Barter History",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Filter Buttons - Changed "All" to "Active"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _filterButton("Active"),
                        _filterButton("Pending"),
                        _filterButton("Completed"),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Filtered Barter History
                    filteredHistory.isNotEmpty
                        ? Column(
                      children: filteredHistory
                          .map((item) => _barterHistoryItem(
                        item["id"],
                        item["title"]!,
                        item["status"]!,
                        _getStatusColor(item["status"]!),
                      ))
                          .toList(),
                    )
                        : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "No $_selectedFilter barters available",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Edit Profile & Logout Buttons - visible regardless of filter
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _actionButton(Icons.edit, "Edit Profile", () {
                    Get.snackbar(
                      "Coming Soon",
                      "Edit Profile feature is under development!",
                      colorText: Colors.white,
                      backgroundColor: darkPurple.withOpacity(0.7),
                    );
                  }),
                  _actionButton(Icons.logout, "Logout", () {
                    FirebaseAuth.instance.signOut();
                    Get.offAllNamed(Routes.signInScreen);
                  }),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return lightPurple;
      case "Active":
        return Colors.green;
      case "Pending":
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  Widget _filterButton(String label) {
    bool isSelected = _selectedFilter == label;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? primaryPurple : surfaceColor,
          foregroundColor: isSelected ? Colors.white : Colors.grey,
          elevation: isSelected ? 4 : 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? lightPurple : Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedFilter = label;
          });
        },
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _barterHistoryItem(String id, String title, String status, Color statusColor) {
    // Show checkbox only for Active barters
    bool isActive = status.toLowerCase() == "active";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryPurple.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: statusColor.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          // Checkbox to mark active barters as complete
          if (isActive)
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      _showCompleteConfirmation(id, title);
                    },
                    icon: Icon(
                      Icons.check_circle_outline,
                      color: lightPurple,
                      size: 18,
                    ),
                    label: Text(
                      "Mark as Complete",
                      style: TextStyle(
                        color: lightPurple,
                        fontSize: 13,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      backgroundColor: lightPurple.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _showCompleteConfirmation(String barterId, String barterTitle) {
    Get.dialog(
      Dialog(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: lightPurple,
                size: 48,
              ),
              SizedBox(height: 16),
              Text(
                "Complete Barter",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Are you sure you want to mark '$barterTitle' as completed?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey,
                      side: BorderSide(color: Colors.grey),
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Update barter status in our local data
                      _completeActiveBarter(barterId);

                      // Close the dialog
                      Get.back();

                      // Show success message
                      Get.snackbar(
                        "Barter Completed",
                        "The barter has been marked as completed",
                        backgroundColor: primaryPurple.withOpacity(0.7),
                        colorText: Colors.white,
                        duration: Duration(seconds: 3),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryPurple,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Complete"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to update a barter from Active to Completed
  void _completeActiveBarter(String barterId) {
    setState(() {
      // Find the index of the barter with the given ID
      int index = barterHistory.indexWhere((item) => item["id"] == barterId);

      if (index != -1) {
        // Update the status of the barter
        barterHistory[index]["status"] = "Completed";

        // Here you would also update this in your database
        // Example API call (not implemented):
        // apiService.updateBarterStatus(barterId, "Completed");

        // If the current filter is "Active", we need to switch to "Completed"
        // to see the updated barter
        if (_selectedFilter == "Active") {
          _selectedFilter = "Completed";
        }
      }
    });
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryPurple.withOpacity(0.4),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              customBorder: const CircleBorder(),
              splashColor: lightPurple.withOpacity(0.3),
              child: Ink(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryPurple,
                      darkPurple,
                    ],
                  ),
                ),
                child: Container(
                  width: 60,
                  height: 60,
                  alignment: Alignment.center,
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}