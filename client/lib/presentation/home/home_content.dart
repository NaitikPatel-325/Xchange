import 'package:flutter/material.dart';
import 'package:xchange/widgets/custom_carousel.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Improved top section with app header
          _buildAppHeader(context),
          const SizedBox(height: 20),

          _buildSectionHeader(
            title: "Featured Trades",
            icon: Icons.local_fire_department,
            color: Colors.deepOrange,
          ),
          const SizedBox(height: 16),
          CustomCarousel(), // Assuming this is your carousel widget

          const SizedBox(height: 24),
          _buildSectionHeader(
            title: "Popular Barter Deals",
            icon: Icons.star,
            color: Colors.amber,
          ),
          const SizedBox(height: 16),
          _popularBarters(),

          const SizedBox(height: 24),
          _buildSectionHeader(
            title: "Explore Categories",
            icon: Icons.explore,
            color: Colors.teal,
          ),
          const SizedBox(height: 16),
          _tradeCategories(),

          const SizedBox(height: 80), // Extra space at bottom for navigation bar
        ],
      ),
    );
  }

  // New app header with search bar
  Widget _buildAppHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Find Your Perfect Trade",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[700]!),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[400]),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for items to trade...",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.tune, color: Colors.grey[400]),
                  onPressed: () {},
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            "See All",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _popularBarters() {
    // More realistic barter items with image URLs
    List<Map<String, String>> barters = [
      {
        "title": "MacBook Pro for DSLR Camera",
        "user": "John Doe",
        "image": "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=200",
        "avatar": "https://randomuser.me/api/portraits/men/32.jpg"
      },
      {
        "title": "Mountain Bike for AirPods Pro",
        "user": "Alice Smith",
        "image": "https://images.unsplash.com/photo-1485965120184-e220f721d03e?q=80&w=200",
        "avatar": "https://randomuser.me/api/portraits/women/44.jpg"
      },
      {
        "title": "iPad Pro for DJI Mini Drone",
        "user": "David Johnson",
        "image": "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?q=80&w=200",
        "avatar": "https://randomuser.me/api/portraits/men/22.jpg"
      },
      {
        "title": "Gaming PC for Apple Watch",
        "user": "Michael Lee",
        "image": "https://images.unsplash.com/photo-1593640408182-31c70c8268f5?q=80&w=200",
        "avatar": "https://randomuser.me/api/portraits/men/42.jpg"
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: barters.length,
      itemBuilder: (context, index) {
        var item = barters[index];
        return Card(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item["image"] ?? "",
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.shopping_cart, color: Colors.purpleAccent, size: 40),
                      ),
                    ),
                  ),
                ),
              ),

              // Content section
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item["title"] ?? "",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Fixed avatar row to prevent overflow
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: item["avatar"] ?? "",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[700],
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[700],
                                  child: const Icon(Icons.person, color: Colors.white, size: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item["user"] ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _tradeCategories() {
    List<Map<String, dynamic>> categories = [
      {
        "icon": Icons.devices,
        "label": "Electronics",
        "color": Colors.blue
      },
      {
        "icon": Icons.pedal_bike,
        "label": "Transport",
        "color": Colors.green
      },
      {
        "icon": Icons.sports_basketball,
        "label": "Sports",
        "color": Colors.orange
      },
      {
        "icon": Icons.palette,
        "label": "Arts",
        "color": Colors.pink
      },
      {
        "icon": Icons.chair,
        "label": "Furniture",
        "color": Colors.amber
      },
      {
        "icon": Icons.work,
        "label": "Jobs",
        "color": Colors.teal
      },
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          var category = categories[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      category["color"],
                      category["color"].withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: category["color"].withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.black26,
                    child: Icon(
                      category["icon"],
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category["label"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}