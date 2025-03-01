import 'package:flutter/material.dart';
import 'package:xchange/widgets/custom_carousel.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _sectionTitle("🔥 Featured Trades"),
          const SizedBox(height: 15),
          CustomCarousel(), // Carousel for featured trades

          const SizedBox(height: 30),
          _sectionTitle("✨ Popular Barter Deals"),
          const SizedBox(height: 15),
          _popularBarters(), // Popular trades grid

          const SizedBox(height: 30),
          _sectionTitle("🎯 Explore Categories"),
          const SizedBox(height: 15),
          _tradeCategories(), // Horizontal scrolling categories
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
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
        childAspectRatio: 0.75,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: barters.length,
      itemBuilder: (context, index) {
        var item = barters[index];
        return Card(
          color: Colors.grey[850],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart, color: Colors.purpleAccent, size: 50),
                const SizedBox(height: 15),
                Text(
                  item["title"] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "By ${item["user"]}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
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

    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 15),
        itemBuilder: (context, index) {
          var category = categories[index];
          return Column(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.purpleAccent,
                child: Icon(category["icon"], color: Colors.white, size: 30),
              ),
              const SizedBox(height: 8),
              Text(
                category["label"],
                style: const TextStyle(color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }
}
