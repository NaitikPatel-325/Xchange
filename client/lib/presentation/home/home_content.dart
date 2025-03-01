import 'package:flutter/material.dart';
import 'package:xchange/widgets/custom_carousel.dart';

class HomeContent extends StatelessWidget {
  HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            "🔥 Featured Trades",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          CustomCarousel(), // ✅ Carousel with static data

          const SizedBox(height: 30),
          const Text(
            "✨ Popular Barter Deals",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _popularBarters(), // ✅ Static barter listings

          const SizedBox(height: 30),
          const Text(
            "🎯 Explore Categories",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          _tradeCategories(), // ✅ Quick Trade Categories
        ],
      ),
    );
  }

  Widget _popularBarters() {
    List<Map<String, String>> barters = [
      {"title": "Laptop for Camera", "user": "John Doe"},
      {"title": "Bicycle for Headphones", "user": "Alice Smith"},
      {"title": "iPad for Drone", "user": "David Johnson"},
      {"title": "Gaming PC for Smartwatch", "user": "Michael Lee"},
      {"title": "Furniture for Home Gym Equipment", "user": "Emma Watson"},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: barters.length,
      itemBuilder: (context, index) {
        var item = barters[index];
        return Card(
          color: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart, color: Colors.purpleAccent, size: 50),
              const SizedBox(height: 10),
              Text(
                item["title"] ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "By ${item["user"]}",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tradeCategories() {
    List<Map<String, dynamic>> categories = [
      {"icon": Icons.computer, "label": "Electronics"},
      {"icon": Icons.pedal_bike, "label": "Transport"},
      {"icon": Icons.sports, "label": "Sports"},
      {"icon": Icons.brush, "label": "Arts"},
      {"icon": Icons.home, "label": "Furniture"},
      {"icon": Icons.work, "label": "Jobs"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          categories.map((category) {
            return Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.purpleAccent,
                  child: Icon(category["icon"], color: Colors.white, size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  category["label"],
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            );
          }).toList(),
    );
  }
}
