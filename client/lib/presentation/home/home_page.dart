import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xchange/core/app_color.dart';
import 'package:xchange/presentation/barter/barter_list.dart';
import 'package:xchange/presentation/wallet/wallet_screen.dart';
import 'package:xchange/presentation/chat/chat_list.dart';
import 'package:xchange/presentation/profile/profile_screen.dart';
import 'package:xchange/presentation/animations/fade_in_animation.dart';
import 'package:xchange/logic/controller/match_controller.dart';

class HomePage extends StatelessWidget {
  final MatchController matchController = Get.put(MatchController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    // Fetch AI recommendations when the home page loads
    matchController.fetchRecommendedBarters();

    return Scaffold(
      backgroundColor: darkBackgroundColor,
      appBar: AppBar(
        title: const Text("BarterPay", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animated Welcome Banner
            FadeInAnimation(child: _welcomeBanner(user?.displayName ?? "User")),
            const SizedBox(height: 25),

            // Quick Actions
            const Text("Quick Actions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 15),
            _quickActions(),

            const SizedBox(height: 30),

            // AI-Powered Barter Recommendations
            const Text(
              "Recommended Trades for You",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Obx(() => FadeInAnimation(child: _recommendedBarters())),

            const SizedBox(height: 30),

            // Featured Barter Listings
            const Text("Trending Barter Deals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            FadeInAnimation(child: _featuredBarters()),

            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
    );
  }

  // Welcome Banner
  Widget _welcomeBanner(String username) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.purpleAccent, Colors.black]),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome, $username 👋", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          const Text("Find and trade what you need today!", style: TextStyle(fontSize: 16, color: Colors.white70)),
        ],
      ),
    );
  }

  // AI-Powered Recommendations
  Widget _recommendedBarters() {
    return Column(
      children: matchController.recommendedBarters.map((item) {
        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(item["title"] ?? "", style: const TextStyle(color: Colors.white)),
            subtitle: Text("Offered by: ${item["user"]}", style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.purpleAccent),
            onTap: () {
              Get.to(() => BarterListScreen());
            },
          ),
        ).animate().slideX(begin: 0.2, end: 0, duration: 400.ms);
      }).toList(),
    );
  }

  // Quick Actions with Purple Accent
  Widget _quickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionCard(Icons.swap_horiz, "Barter", BarterListScreen()),
        _actionCard(Icons.account_balance_wallet, "Wallet", WalletScreen()),
        _actionCard(Icons.chat, "Chat", ChatListScreen()),
        _actionCard(Icons.person, "Profile", ProfileScreen()),
      ],
    );
  }

  Widget _actionCard(IconData icon, String label, Widget screen) {
    return GestureDetector(
      onTap: () => Get.to(() => screen),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.purpleAccent,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }

  // Featured Barter Listings
  Widget _featuredBarters() {
    List<Map<String, String>> barters = [
      {"title": "Laptop for Camera", "user": "John Doe"},
      {"title": "Web Design for Guitar", "user": "Alice Smith"},
      {"title": "Trading Books for Digital Credits", "user": "David Johnson"},
    ];

    return Column(
      children: barters.map((item) {
        return Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            title: Text(item["title"] ?? "", style: const TextStyle(color: Colors.white)),
            subtitle: Text("Offered by: ${item["user"]}", style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.purpleAccent),
            onTap: () {
              Get.to(() => BarterListScreen());
            },
          ),
        ).animate().slideX(begin: 0.2, end: 0, duration: 400.ms);
      }).toList(),
    );
  }

  // Bottom Navigation Bar with Purple Theme
  Widget _bottomNavBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.purpleAccent,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: "Barter"),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: "Wallet"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}