import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xchange/core/app_color.dart';
import 'package:xchange/core/routes/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; // Get logged-in user

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            // Profile Image
            CircleAvatar(
              radius: 50,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : const AssetImage("assets/profile_placeholder.png") as ImageProvider,
            ),

            const SizedBox(height: 15),

            // User Name
            Text(
              user?.displayName ?? "Anonymous User",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),

            // User Email
            Text(
              user?.email ?? "No Email",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // Barter History
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Barter History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),

            _barterHistoryItem("Exchanged Laptop for Camera", "Completed", Colors.green),
            _barterHistoryItem("Offered Design Services", "Pending", Colors.orange),
            _barterHistoryItem("Traded Books for Digital Credits", "Completed", Colors.green),

            const SizedBox(height: 30),

            // Edit Profile & Logout Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _actionButton(Icons.edit, "Edit Profile", () {
                  Get.snackbar("Coming Soon", "Edit Profile feature is under development!");
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
    );
  }

  Widget _barterHistoryItem(String title, String status, Color statusColor) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}
